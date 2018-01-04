//
//  APIClient.swift
//  DereGuide
//
//  Created by zzk on 03/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation
import MessagePack
import RijndaelSwift

class APIClient {
    
    static let shared = APIClient()
    
    private init() {
        
    }
    
    private let rijndaelKey = "s%5VNQ(H$&Bqb6#3+78h29!Ft4wSg)ex".data(using: .ascii)!
    
    private let salt = "r!I@nt8e5i=".data(using: .ascii)!
    
    private let userID = "775891250"
    private let viewerID = "910841675"
    private let udid = "600a5efd-cae5-41ff-a0c7-7deda751c5ed"
    
    private var sid: String?

    private var base = "https://game.starlight-stage.jp"
    
    private func lolfuscate(_ s: String) -> String {
        let mid = s.map { String.init(format: "%02d\($0.shiftScalarBy(10))%d", 100.arc4random, 10.arc4random) }.joined()
        let post = (0..<32).map { _ in String(10.arc4random) }.joined()
        return String.init(format: "%04x\(mid)\(post)", s.count)
    }
    
    private func unlolfuscate(_ s: String) -> String {
        let count = Int(s[..<s.index(s.startIndex, offsetBy: 4)], radix: 16) ?? 0
        return stride(from: 6, to: s.count, by: 4).enumerated()
            .filter { $0.offset < count }
            .map { String(s[s.index(s.startIndex, offsetBy: $0.element)].shiftScalarBy(-10)) }
            .joined()
    }
    
    func call(path: String, userInfo: [String: Any], callback: ((MessagePackValue?) -> Void)?) {
        let iv = (0..<32).map { _ in String(10.arc4random) }.joined().data(using: .ascii)!
        var params = userInfo
        params["viewer_id"] = iv + Rijndael(key: rijndaelKey, mode: .cbc)!.encrypt(data: viewerID.data(using: .ascii)!, blockSize: 32, iv: iv)!.base64EncodedData()
        var msgpack = [MessagePackValue: MessagePackValue]()
        for (key, value) in params {
            switch value {
            case let v as Data:
                msgpack[.string(key)] = .binary(v)
            case let v as String:
                msgpack[.string(key)] = .string(v)
            case let v as Int:
                msgpack[.string(key)] = .int(Int64(v))
            default:
                break
            }
        }
        
        let plain = pack(MessagePackValue(msgpack)).base64EncodedData()
        let key = Data(bytes: (0..<32).map { _ in UInt8.max.arc4random })
        let msgIV = udid.replacingOccurrences(of: "-", with: "").data(using: .ascii)
        let body = (Rijndael(key: key, mode: .cbc)!.encrypt(data: plain, blockSize: 32, iv: msgIV)! + key).base64EncodedData()
        let sid = self.sid ?? viewerID + udid
        let headers = [
            "PARAM": ((udid + viewerID + path).data(using: .ascii)! + plain).sha1().hexadecimal(),
            "KEYCHAIN": "",
            "USER_ID": lolfuscate(userID),
            "CARRIER": "google",
            "UDID": lolfuscate(udid),
            "APP_VER": CGSSVersionManager.default.gameVersion?.description ?? "3.5.2",
            "RES_VER": CGSSVersionManager.default.apiInfo?.truthVersion ?? "10013600",
            "IP_ADDRESS": "127.0.0.1",
            "DEVICE_NAME": "Nexus 42",
            "X-Unity-Version": Config.unityVersion,
            "SID": (sid.data(using: .ascii)! + salt).md5().hexadecimal(),
            "GRAPHICS_DEVICE_NAME": "3dfx Voodoo2 (TM)",
            "DEVICE_ID": "Totally a real Android".md5(),
            "PLATFORM_OS_VERSION": "Android OS 13.3.7 / API-42 (XYZZ1Y/74726f6c6c)",
            "DEVICE": "2",
            "Content-Type": "application/x-www-form-urlencoded",
            "User-Agent": "Dalvik/2.1.0 (Linux; U; Android 13.3.7; Nexus 42 Build/XYZZ1Y)",
        ]

        let url = URL(string: base + path)!

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.httpBody = body
        let task = BaseSession.shared.session.dataTask(with: request) { data, response, error in
            if error != nil {
                callback?(nil)
            } else {
                guard let data = data, let decodedData = Data(base64Encoded: data) else {
                    callback?(nil)
                    return
                }
                let rijndael = Rijndael(key: Data(decodedData[decodedData.count - 32..<decodedData.count]), mode: .cbc)!
                let plain = rijndael.decrypt(data: Data(decodedData[0..<decodedData.count - 32]), blockSize: 32, iv: msgIV)!.split(separator: 0)[0]
                guard let decodedPlain = Data(base64Encoded: plain) else {
                    callback?(nil)
                    return
                }
                guard let msg = try? unpack(decodedPlain) else {
                    callback?(nil)
                    return
                }
                callback?(msg.value)
            }
        }

        task.resume()
        
    }
    
    func versionCheck() {
        let args: [String: Any] = [
            "campaign_data": "",
            "campaign_user": 1337,
            "campaign_sign": "All your APIs are belong to us".md5(),
            "app_type": 0,
            ]
        call(path: "/load/check", userInfo: args, callback: nil)
    }
    
    func gachaRates(gachaID: Int) {
        let args: [String: Any] = [
            "gacha_id": gachaID,
            "timezone": "-07:00:00",
        ]
        call(path: "/gacha/get_rate", userInfo: args, callback: nil)
    }

}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

extension Data {
    func sha1() -> Data {
        var bytes: [UInt8] = Array(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(count), &bytes)
        }
        return Data(bytes: bytes)
    }
    func md5() -> Data {
        var bytes: [UInt8] = Array(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_MD5($0, CC_LONG(count), &bytes)
        }
        return Data(bytes: bytes)
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

extension UInt8 {
    var arc4random: UInt8 {
        return UInt8(arc4random_uniform(UInt32(self)))
    }
}

extension Character {
    func shiftScalarBy(_ offset: Int) -> Character {
        let unicode = UnicodeScalar(self.unicodeScalars.first!)
        let newUnicode = Int(unicode.value) + offset
        guard newUnicode > 0 else { return "\0" }
        return Character(UnicodeScalar(UInt32(newUnicode))!)
    }
}

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
import CryptoSwift

class APIClient {
    
    static let shared = APIClient()
    
    private init() {
        
    }
    
    private let rijndaelKey = "s%5VNQ(H$&Bqb6#3+78h29!Ft4wSg)ex".data(using: .ascii)!
    
    private let salt = "r!I@nt8e5i=".data(using: .ascii)!
    
//    private let userID = "775891250"
//    private let viewerID = "910841675"
//    private let udid = "600a5efd-cae5-41ff-a0c7-7deda751c5ed"
    
    var userID: String {
        get {
            return UserDefaults.standard.value(forKey: "user_id") as? String ?? "313178201"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "user_id")
        }
    }
    
    var viewerID: String {
        get {
            return UserDefaults.standard.value(forKey: "viewer_id") as? String ?? "679595005"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "viewer_id")
        }
    }
    
    var udid: String {
        get {
            return UserDefaults.standard.value(forKey: "udid") as? String ?? "c3798e43-3ea2-4fe5-a2ee-316ee478921c"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "udid")
        }
    }
    
    private var sid: String?

    private var base = "https://game.starlight-stage.jp"
    
    private var apis = "https://apis.game.starlight-stage.jp"
    
    private func lolfuscate(_ s: String) -> String {
        let mid = s.map { String(format: "%02d\($0.shiftScalarBy(10))%d", 100.arc4random, 10.arc4random) }.joined()
        let post = (0..<16).map { _ in String(10.arc4random) }.joined()
        return String(format: "%04x\(mid)\(post)", s.count)
    }
    
    private func unlolfuscate(_ s: String) -> String {
        let count = Int(s[..<s.index(s.startIndex, offsetBy: 4)], radix: 16) ?? 0
        return stride(from: 6, to: s.count, by: 4).enumerated()
            .filter { $0.offset < count }
            .map { String(s[s.index(s.startIndex, offsetBy: $0.element)].shiftScalarBy(-10)) }
            .joined()
    }
    
    func call(base: String? = nil, path: String, userInfo: [String: Any], callback: ((MessagePackValue?) -> Void)?) {
        let iv = (0..<16).map { _ in String(9.arc4random + 1) }.joined()
        var params = userInfo
        params["viewer_id"] = try! iv + AES(key: rijndaelKey.bytes, blockMode: CBC(iv: iv.bytes)).encrypt(viewerID.bytes).toBase64()!
        var msgpack = [MessagePackValue: MessagePackValue]()
        for (key, value) in params {
            switch value {
            case let v as Data:
                msgpack[.string(key)] = .binary(v)
            case let v as String:
                msgpack[.string(key)] = .string(v)
            case let v as Int:
                msgpack[.string(key)] = .int(Int64(v))
            case let v as UInt:
                msgpack[.string(key)] = .uint(UInt64(v))
            default:
                break
            }
        }
        
        let plain = pack(MessagePackValue(msgpack))
        let key = Data(Data(bytes: (0..<32).map { _ in UInt8.max.arc4random }).base64EncodedData()[0..<32])
        let msgIV = udid.replacingOccurrences(of: "-", with: "").hexadecimal()!
        let aes = try! AES(key: key.bytes, blockMode: CBC(iv: msgIV.bytes))
        let body = Data(bytes: (try! aes.encrypt(plain.base64EncodedData().bytes) + key.bytes)).base64EncodedData()
        let sid = self.sid ?? viewerID + udid

        let base = base ?? self.apis
        
        let url = URL(string: base + path)!
        
        var request = URLRequest(url: url)
        
        request.allHTTPHeaderFields = [
            "User-Agent": "BNEI0242/173 CFNetwork/976 Darwin/18.2.0",
            "PARAM": ((udid + viewerID + path).data(using: .ascii)! + plain.base64EncodedData()).sha1().hexadecimal(),
            "PROCESSOR-TYPE": "arm64",
            "DEVICE-NAME": "iPad5,3",
            "GRAPHICS-DEVICE-NAME": "Apple A8X GPU",
            "PLATFORM-OS-VERSION": "iOS 12.1.3",
            "KEYCHAIN": "148444250",
            "UDID": lolfuscate(udid),
            "DEVICE-ID": "432B4E5E-F7D8-470C-A71B-C5606522B0FF",
            "SID": (sid.data(using: .ascii)! + salt).md5().hexadecimal(),
            "X-Unity-Version": Config.unityVersion,
            "Connection": "keep-alive",
            "CARRIER": "",
            "IP-ADDRESS": "192.168.0.101",
            "Accept-Language": "zh-cn",
            "APP-VER": CGSSVersionManager.default.gameVersion?.description ?? "4.6.2",
            "RES-VER": CGSSVersionManager.default.newestTruthVersion,
            "USER-ID": lolfuscate(userID),
            "Accept": "*/*",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "br, gzip, deflate",
            "DEVICE": "1",
            "IDFA": "5D4DA824-C48A-4390-85F2-17EAAEB1F5FD"
        ]
        
        request.httpMethod = "POST"
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                callback?(nil)
            } else {
                guard let data = data, let decodedData = Data(base64Encoded: data) else {
                    callback?(nil)
                    return
                }
                let key = Data(decodedData[decodedData.count - 32..<decodedData.count])
                let aes = try! AES(key: key.bytes, blockMode: CBC(iv: msgIV.bytes))
                let cipher = Data(decodedData[0..<decodedData.count - 32])
                let plain = try! aes.decrypt(cipher.bytes)
                
                guard let decodedPlain = Data(base64Encoded: Data(bytes: plain)) else {
                    callback?(nil)
                    return
                }
                guard let msg = try? unpack(decodedPlain) else {
                    callback?(nil)
                    return
                }

                // Changed in 1.7.5: Since we used the same viewer id for all the app users, the sid will be easily invalid after other users request with the original sid. Instead of saving the sid, we always use the original sid.
                /* 
                if let sid = msg.value[.string("data_headers")]?[.string("sid")]?.stringValue, sid != "" {
                    self.sid = sid
                }
                 */
                callback?(msg.value)
            }
        }
        
        task.resume()
    }
    
    func check(callback: ((MessagePackValue?) -> Void)?) {
        let args: [String: Any] = [
            "campaign_data": "",
            "campaign_user": Int(120692),
            "campaign_sign": "1dbb135bae1054871887f76b891604d58b04e362",
            "app_type": UInt(0),
            "timezone": "09:00:00"
        ]
        call(path: "/load/check", userInfo: args) {
            callback?($0)
        }
    }
    
    func gachaRates(gachaID: Int, callback: ((MessagePackValue?) -> Void)?) {
        let args: [String: Any] = [
            "gacha_id": gachaID,
            "timezone": "09:00:00",
        ]
        call(path: "/gacha/get_rate", userInfo: args) { pack in
            callback?(pack)
        }
    }
    
    func tourRanking(page: Int, type: Int, callback: ((MessagePackValue?) -> Void)?) {
        let args: [String: Any] = [
                "page": UInt(page),
                "ranking_type": UInt(type),
                "timezone": "09:00:00",
            ]
        call(base: apis, path: "/event/tour/ranking_list", userInfo: args) { pack in
            callback?(pack)
        }
    }
    
    func ataponRanking(page: Int, type: Int, callback: ((MessagePackValue?) -> Void)?) {
        let args: [String: Any] = [
            "page": UInt(page),
            "ranking_type": UInt(type),
            "timezone": "09:00:00",
        ]
        call(base: apis, path: "/event/atapon/ranking_list", userInfo: args) { pack in
            callback?(pack)
        }
    }
    
    func grooveRanking(page: Int, type: Int, callback: ((MessagePackValue?) -> Void)?) {
        let args: [String: Any] = [
            "page": UInt(page),
            "ranking_type": UInt(type),
            "timezone": "09:00:00",
            ]
        
        // need more test
        call(base: apis, path: "/event/medley/ranking_list", userInfo: args) { pack in
            callback?(pack)
        }
    }
    
    func getProfile(friendID: Int, callback: ((MessagePackValue?) -> Void)?) {
        let args: [String: Any] = [
            "friend_id": UInt(friendID),
            "timezone": "09:00:00",
            ]
        
        // need more test
        call(base: apis, path: "/profile/get_profile", userInfo: args) { pack in
            callback?(pack)
        }
    }
    
    func resetSID() {
        sid = nil
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

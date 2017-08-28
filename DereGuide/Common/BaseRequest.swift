//
//  BaseRequest.swift
//  DereGuide
//
//  Created by zzk on 2017/1/25.
//  Copyright © 2017年 zzk. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseRequest {
    
    static let `default` = BaseRequest()
    
    var session = BaseSession.shared.session
    
    func getWith(urlStr:String, params:[String:String]?, callback:@escaping (_ data:Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        var newStr = urlStr
        if params != nil {
            newStr.append(encodeUnicode(string: paramsToString(params: params!)))
        }
        var request = URLRequest.init(url: URL.init(string: newStr)!)
        request.httpMethod = "GET"
        dataTask(with: request, completionHandler: callback)
    }
    
    func postWith(urlStr:String, params:[String:String]?, callback:@escaping (_ data:Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        var newStr = ""
        if params != nil {
            newStr.append(encodeUnicode(string: paramsToString(params: params!)))
        }
        var request = URLRequest.init(url: URL.init(string: urlStr)!)
        request.httpMethod = "POST"
        request.httpBody = newStr.data(using: .utf8)
        dataTask(with: request, completionHandler: callback)
    }
    
    func postWith(request:inout URLRequest, params:[String:String]?, callback:@escaping (_ data:Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        var newStr = ""
        if params != nil {
            newStr.append(encodeUnicode(string: paramsToString(params: params!)))
        }
        request.httpMethod = "POST"
        request.httpBody = newStr.data(using: .utf8)
        dataTask(with: request, completionHandler: callback)
    }
    
    func getWith(request:inout URLRequest, params: [String :String]? = nil, callback:@escaping (_ data:Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        var newStr = ""
        if params != nil {
            newStr.append(encodeUnicode(string: paramsToString(params: params!)))
        }
        request.httpMethod = "GET"
        request.httpBody = newStr.data(using: .utf8)
        dataTask(with: request, completionHandler: callback)
    }
    
    func getWith(urlString:String, params: [String :String]? = nil, callback:@escaping (_ data:Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        var newStr = ""
        if params != nil {
            newStr.append("?")
            newStr.append(encodeUnicode(string: paramsToString(params: params!)))
        }
        var request = URLRequest.init(url: URL.init(string: urlString + newStr)!)
        request.httpMethod = "GET"
        dataTask(with: request, completionHandler: callback)
    }
    
    fileprivate func paramsToString(params:[String:String]) -> String {
        if params.count == 0 {
            return ""
        }
        var paraStr = ""
        var paraArr = [String]()
        for (key, value) in params {
            paraArr.append("\(key)=\(value)")
        }
        paraStr.append(paraArr.joined(separator: "&"))
        return String(paraStr)
    }
    
    
    /// construct multipart url request
    ///
    /// - Parameters:
    ///   - urlStr: string of remote api
    ///   - params: params of the multipart form
    ///   - fileNames: file names of params with file data
    /// - Returns: the constructed request
    fileprivate func constructMultipartRequest(urlStr:String, params:[String:Any?], fileNames: [String:String]?) -> URLRequest {
        
        var request = URLRequest.init(url: URL.init(string: urlStr)!)
        let boundary = "Boundary+BFFF11CB6FF1E452"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        for (k, v) in params {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            if v is UIImage {
                data.append("Content-Disposition: form-data; name=\"\(k)\"; filename=\"\(fileNames?[k] ?? "")\"\r\n".data(using: .utf8)!)
                data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                let imageData = UIImagePNGRepresentation(v as? UIImage ?? UIImage()) ?? Data()
                data.append(imageData)
                data.append("\r\n".data(using: .utf8)!)
            } else if v is String {
                data.append("Content-Disposition: form-data; name=\"\(k)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(v!)\r\n".data(using: .utf8, allowLossyConversion: true)!)
            }
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = data
        return request
    }
    
    func dataTask(with request:URLRequest, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {

        #if DEBUG
            print("request the url: ", request.url?.absoluteString ?? "")
        #endif
        
        let task = session?.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if error != nil {
                
            } else {
                #if DEBUG
                    print("response code is ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                #endif
            }
            completionHandler(data, response as? HTTPURLResponse, error)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        task?.resume()
    }
    func encodeUnicode(string:String) -> String {
        var cs = CharacterSet.urlQueryAllowed
        cs.remove(UnicodeScalar.init("+"))
        let newStr = (string as NSString).addingPercentEncoding(withAllowedCharacters: cs)
        return newStr ?? ""
    }
}



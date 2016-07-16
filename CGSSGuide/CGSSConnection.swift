//
//  CGSSConnection.swift
//  CGSSFoundation
//
//  Created by zzk on 16/7/12.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation

class CGSSConnection: NSObject, NSURLConnectionDelegate {
    var downloadData = NSMutableData()
    var urlStr:String
    var connection:NSURLConnection?
    var target:AnyObject?
    var action:Selector?
    var isSuccess = false
    var tag = 0
    init(urlStr:String, target:AnyObject, action:Selector, tag:Int) {
        self.urlStr = urlStr
        self.target = target
        self.action = action
        self.tag = tag
    }
    func start() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let request = NSURLRequest.init(URL: NSURL.init(string: urlStr)!)
        connection = NSURLConnection.init(request: request, delegate: self)
    }
    
    //中断网络请求
    func stop() {
        connection?.cancel()
    }
    
    //析构
    deinit {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

//MARK: NSURLConnection回调方法
extension CGSSConnection: NSURLConnectionDataDelegate {
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        downloadData.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        downloadData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        isSuccess = true
        target?.performSelector(action!, withObject: self)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        isSuccess = false
        target?.performSelector(action!, withObject: self)
    }
}

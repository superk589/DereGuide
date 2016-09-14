//
//  LZ4Decompressor.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/11.
//  Copyright © 2016年 zzk. All rights reserved.
//

import Foundation
import lz4

class LZ4Decompressor {
    static func decompress(data: NSData) -> NSData {
        var destSize = 0
        data.getBytes(&destSize, range: NSRange.init(location: 4, length: 4))
        
        let newdata = data.subdataWithRange(NSRange.init(location: 16, length: data.length - 16))
        
        let source = UnsafePointer<Int8>.init(newdata.bytes)
        let dest = UnsafeMutablePointer<Int8>.alloc(destSize)
        
        LZ4_decompress_fast(source, dest, Int32(destSize))
        let decompressedData = NSData.init(bytes: dest, length: destSize)
        return decompressedData
    }
}

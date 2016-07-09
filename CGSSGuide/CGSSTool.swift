//
//  CGSSTool.swift
//  CGSSFoundation
//
//  Created by zzk on 16/6/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

public class CGSSTool: NSObject {

    //当前屏幕的宽度和高度常量
    public static let width = UIScreen.mainScreen().bounds.width
    public static let height = UIScreen.mainScreen().bounds.height
    
    public static let vocalColor = UIColor.init(red: 1.0*236/255, green: 1.0*87/255, blue: 1.0*105/255, alpha: 1)
    public static let danceColor = UIColor.init(red: 1.0*89/255, green: 1.0*187/255, blue: 1.0*219/255, alpha: 1)
    public static let visualColor = UIColor.init(red: 1.0*254/255, green: 1.0*154/255, blue: 1.0*66/255, alpha: 1)
    public static let lifeColor = UIColor.init(red: 1.0*75/255, green: 1.0*202/255, blue: 1.0*137/255, alpha: 1)
    
    public static let fullImageWidth:CGFloat = 1280
    public static let fullImageHeight:CGFloat = 824
    
    
    
    //应放置到逻辑层的函数,暂时放到这里
    static func getIconFromCardId(id:Int) -> UIImage {
        let dao = CGSSDAO.sharedDAO
        let cardIcon = dao.cardIconDict!.objectForKey(String(id)) as! CGSSCardIcon
        let iconFile = cardIcon.file_name!
        let image = UIImage(named: iconFile)
        let cgRef = image!.CGImage
        let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(cardIcon.col!), 96 * CGFloat(cardIcon.row!) as CGFloat, 96, 96))
        let icon = UIImage.init(CGImage: iconRef!)
        return icon
    }


      
    
}
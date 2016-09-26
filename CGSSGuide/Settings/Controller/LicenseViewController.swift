//
//  LicenseViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/20.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    var tv = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: CGSSGlobal.width, height: CGSSGlobal.height))
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.dataDetectorTypes = .link
        self.view.backgroundColor = UIColor.white
        tv.text = NSLocalizedString("本程序是非官方程序，所有本程序中使用的游戏相关数据版权所属为：\nBANDAI NAMCO Entertainment Inc.\n----------------------------------------\n本程序所使用的卡片、歌曲等数据来源于网络，其版权在不违反官方版权的前提下遵循提供者的版权声明。\n----------------------------------------\n本程序使用的第三方库\nSwiftyJson (MIT License)\nCopyright (c) 2014 Ruoyu Fu\nSDWebImage (MIT License)\nCopyright (c) 2016 Olivier Poitrey\nReachabilitySwift (MIT License)\nCopyright (c) 2016 Ashley Mills\nFMDB (MIT License)\nCopyright (c) 2008-2014 Flying Meat Inc.\nlz4 (BSD License)\nCopyright (c) 2011-2015, Yann Collet\n----------------------------------------\n本程序的所有界面、图标、非官方资源数据、代码基于MIT协议。\n如果对此项目感兴趣，请访问：\nhttps://github.com/superk589/CGSSGuide\n\n", comment: "版权声明页面")
        // Do any additional setup after loading the view.
        self.view.addSubview(tv)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

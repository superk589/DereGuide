//
//  AcknowledgementViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/20.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class AcknowledgementViewController: UIViewController {

    var tv = UITextView.init(frame: CGRect.init(x: 0, y: 0, width: CGSSGlobal.width, height: CGSSGlobal.height))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.dataDetectorTypes = .link
        tv.text = NSLocalizedString("数据来源：\nhttps://starlight.kirara.ca\nhttp://starlight.hyspace.io\nhttps://deresute.info\nhttps://hoshimoriuta.kirara.ca\nhttp://imascg-slstage-wiki.gamerch.com\n----------------------------------------\n技术支持：\nChieri\nCaiMiao\nstatementreply\nSnack-X\nsummertriangle-dev\n----------------------------------------\n封面设计：\nZXQ\n\n", comment: "致谢页面")
        view.addSubview(tv)
        // Do any additional setup after loading the view.
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

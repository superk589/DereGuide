//
//  CardDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

class CardDetailViewController: UIViewController {
    
    var card:CGSSCard!
    
    @IBOutlet weak var fullImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //显示大图
        if card.has_spread! {
            //let path = NSBundle.mainBundle().resourcePath! + "/fullImage/" + String(card.id!) + "_spread.png"
            //if let image = UIImage.init(named: String(card.id!) + "_spread.png" ) {
            
            if let image = UIImage.init(named: "200248" +  "_spread.png") {
                self.fullImage.image = image

            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

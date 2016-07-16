//
//  UpdatingViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/16.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class UpdatingViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var updater:CGSSUpdater!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        updater.updateCardIconData()
        CGSSNotificationCenter.add(self, selector: #selector(getCardData), name: "ICON_UPDATE_FINISH", object: nil)
        CGSSNotificationCenter.add(self, selector: #selector(finishAll), name: "CARD_UPDATE_FINISH", object: nil)
    }
    

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBOutlet weak var numberLabel: UILabel!
    func getCardData() {
        updater.updateCardData()
    }
    
    func taskProgress(a: Int, b: Int) {
        self.numberLabel.text = "\(a)/\(b)"
    }
    func currentContentType(s: String) {
        self.statusLabel.text = s
    }
    func finishAll() {
        self.dismissViewControllerAnimated(true, completion: nil)
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

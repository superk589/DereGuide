//
//  CardTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CGSSFoundation

class CardTableViewController: UITableViewController {
        
    var cardDict:NSDictionary!
    var cardList:NSArray!
    var presentedDict:NSMutableDictionary!
    var centerSkillDict:NSDictionary!
    var specialSkillDict:NSDictionary!
    //var cardTableArray:Array<CGSSCard>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dao = CGSSDAO.sharedDAO
        //self.cardList = dao.cardDict?.allValues as! NSArray
        self.cardList = dao.getSortedList(dao.cardDict, attList: ["album_id"], compare: (<))
        
        //        self.cardList = dao.getSortedList(dao.cardDict, attList: ["id"], compare: {$0<$1 })
//
//        let cardPListPath = NSBundle.mainBundle().pathForResource("Card", ofType: "plist")
//        cardDict = NSDictionary(contentsOfFile: cardPListPath!)
//        presentedDict = NSMutableDictionary()
//        for (k, v) in cardDict {
//            if let rare = v.objectForKey("cardRare")
//            {
//                switch rare as! String {
//                case "SSR", "SSR＋", "SR", "SR＋":
//                    presentedDict.setValue(v, forKey: k as! String)
//                default:
//                    break
//                }
//            }
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cardList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:CardTableViewCell! = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath) as? CardTableViewCell
        _ = CGSSDAO.sharedDAO
        let row = indexPath.row
        let card = cardList[row] as! CGSSCard
        
        cell.cardName.text = String(card.name) + String(card.album_id)
        
        
//        let iconIndex = cardList.valueForKey(cardName)?.valueForKey("iconIndex")!.integerValue
//        
//        
//        let imageFileNumber = iconIndex! / 64
//        let imageOffsetRow:Int = iconIndex! % 64 / 8
//        let imageOffsetCol:Int = iconIndex! % 64 % 8
//        let imagePath = String(format: "%d.jpg", imageFileNumber)
//        let image = UIImage(named: imagePath)
//        let cgRef = image!.CGImage
//        let iconRef = CGImageCreateWithImageInRect(cgRef, CGRectMake(96 * CGFloat(imageOffsetCol), 96 * CGFloat(imageOffsetRow) as CGFloat, 96, 96))
//        let icon = UIImage.init(CGImage: iconRef!)
//        cell.imageView?.image = icon
//        
//        //边角圆滑处理
//        cell.imageView?.layer.cornerRadius = 4
//        cell.imageView?.layer.masksToBounds = true
        
        //textLabel?.text = self.cardList[row] as? String
        
        

        //显示三项数值
        if let vocal = card.vocal_max {
            cell.vocal.text = String(vocal)
        }
        if let dance = card.dance_max {
            cell.dance.text = String(dance)
        }
        if let visual = card.visual_max {
            cell.visual.text = String(visual)
        }
        if let overall = card.overall_max {
            cell.total.text = String(overall)
        }
        
        
        
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

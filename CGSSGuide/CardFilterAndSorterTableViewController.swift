//
//  CardFilterAndSorterTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/4.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardFilterAndSorterTableViewController: UITableViewController {
  
    @IBOutlet weak var rarityStackView: UIView!
    @IBOutlet weak var cardTypeStackView: UIView!
    @IBOutlet weak var attributeStackView: UIView!
    @IBOutlet weak var favoriteStackView: UIView!

    @IBOutlet weak var ascendingStackView: UIView!
    @IBOutlet weak var attributeSortingStackView: UIView!
    @IBOutlet weak var otherSortingStackView: UIView!
 
    
    var sortingButtons:[UIButton]!
    
    var filter:CGSSCardFilter!
    var sorter:CGSSSorter!
    //let color = UIColor.init(red: 13/255, green: 148/255, blue: 252/255, alpha: 1)
    var sorterString = ["vocal","dance","visual","overall","update_id","rarity_ref","album_id"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backButton = UIBarButtonItem.init(title: "完成", style: .Plain, target: self, action: #selector(doneAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        for i in 0...7 {
            let button = rarityStackView.subviews[i] as! UIButton
            //button.layer.borderWidth = 1
            //button.layer.borderColor = color.CGColor
            button.addTarget(self, action: #selector(rarityButtonClick), forControlEvents: .TouchUpInside)
            //button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
            if filter.hasCardRarityFilterType(CGSSCardRarityFilterType.init(rarity: Int(7-i))!) {
                button.selected = true
                //button.backgroundColor = color
            }
        }
        
        for i in 0...2 {
            let button = cardTypeStackView.subviews[i] as! UIButton
            //button.layer.borderWidth = 1
            //button.layer.borderColor = UIColor.blueColor().CGColor
            //button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(cardTypeButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 1000 + i
            if filter.hasCardFilterType(CGSSCardFilterType.init(cardType: Int(i))!) {
                button.selected = true
                //button.backgroundColor = color
            }
        }
        
        for i in 0...2 {
            let button = attributeStackView.subviews[i] as! UIButton
            //button.layer.borderWidth = 1
            //button.layer.borderColor = UIColor.blueColor().CGColor
            //button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(attributeButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 1000 + i
            if filter.hasAttributeFilterType(CGSSAttributeFilterType.init(attributeType: Int(i))!) {
                button.selected = true
                //button.backgroundColor = color
            }
        }
        
        for i in 0...1 {
            let button = favoriteStackView.subviews[i] as! UIButton
            //button.layer.borderWidth = 1
            //button.layer.borderColor = UIColor.blueColor().CGColor
            //button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(favoriteButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 1000 + i
            if filter.hasFavoriteFilterType(CGSSFavoriteFilterType.init(rawValue: 1<<UInt(i))!) {
                button.selected = true
                //button.backgroundColor = color
            }
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.addTarget(self, action: #selector(ascendingAction), forControlEvents: .TouchUpInside)
        if sorter.ascending {
            ascendingbutton.selected = true
                //button.backgroundColor = color
        }
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.addTarget(self, action: #selector(descendingAction), forControlEvents: .TouchUpInside)
        if !sorter.ascending {
            descendingButton.selected = true
            //button.backgroundColor = color
        }

        sortingButtons = [UIButton]()
        for i in 0...3 {
            let button = attributeSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 1000+i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
            let index = sorterString.indexOf(sorter.att)
            if index == i {
                button.selected = true
            }
        }
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 2000+i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
            let index = sorterString.indexOf(sorter.att)
            if index == i + 4 {
                button.selected = true
            }
        }
        
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func rarityButtonClick(sender:UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            //sender.backgroundColor = UIColor.clearColor()
            filter.removeCardRarityFilterType(CGSSCardRarityFilterType.init(rarity: Int(7-tag))!)
        } else {
            sender.selected = true
            //sender.backgroundColor = color
            filter.addCardRarityFilterType(CGSSCardRarityFilterType.init(rarity: Int(7-tag))!)
        }
      
    }
    
    func attributeButtonClick(sender:UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            //sender.backgroundColor = UIColor.clearColor()
            filter.removeAttributeFilterType(CGSSAttributeFilterType.init(attributeType: Int(tag))!)
        } else {
            sender.selected = true
            //sender.backgroundColor = color
            filter.addAttributeFilterType(CGSSAttributeFilterType.init(attributeType: Int(tag))!)
        }
        
    }
    
    func favoriteButtonClick(sender:UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            //sender.backgroundColor = UIColor.clearColor()
            filter.removeFavoriteFilterType(CGSSFavoriteFilterType.init(rawValue: 1<<UInt(tag))!)
        } else {
            sender.selected = true
            //sender.backgroundColor = color
            filter.addFavoriteFilterType(CGSSFavoriteFilterType.init(rawValue: 1<<UInt(tag))!)
        }
        
    }

    func cardTypeButtonClick(sender:UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            //sender.backgroundColor = UIColor.clearColor()
            filter.removeCardFilterType(CGSSCardFilterType.init(cardType: Int(tag))!)
        } else {
            sender.selected = true
            //sender.backgroundColor = color
            filter.addCardFilterType(CGSSCardFilterType.init(cardType: Int(tag))!)
        }
        
    }
    
    func ascendingAction(sender:UIButton) {
        if !sender.selected {
            sender.selected = true
            let descendingButton = ascendingStackView.subviews[0] as! UIButton
            descendingButton.selected = false
            sorter.ascending = true
        }
    }
    func descendingAction(sender:UIButton){
        if !sender.selected {
            sender.selected = true
            let ascendingButton = ascendingStackView.subviews[1] as! UIButton
            ascendingButton.selected = false
            sorter.ascending = false
        }
    }
    
    
    func sortingButtonsAction(sender:UIButton) {
        if !sender.selected {
            for btn in sortingButtons {
                if btn.selected {
                    btn.selected = false
                }
            }
            sender.selected = true
            let index = sortingButtons.indexOf(sender)
            sorter.att = sorterString[index!]
        }
    }
    
    func doneAction() {
        //self.navigationController?.popViewControllerAnimated(true)
        //使用自定义动画效果
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        navigationController?.popViewControllerAnimated(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else {
            return 3
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

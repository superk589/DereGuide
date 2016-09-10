//
//  CardFilterAndSorterTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/4.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol CardFilterAndSorterTableViewControllerDelegate: class {
    func doneAndReturn(filter: CGSSCardFilter, sorter: CGSSSorter)
}

class CardFilterAndSorterTableViewController: UITableViewController {
    
    @IBOutlet weak var rarityStackView: UIView!
    @IBOutlet weak var cardTypeStackView: UIView!
    @IBOutlet weak var skillTypeView: UIView!
    @IBOutlet weak var skillTypeView2: UIView!
    @IBOutlet weak var attributeStackView: UIView!
    @IBOutlet weak var favoriteStackView: UIView!
    
    @IBOutlet weak var ascendingStackView: UIView!
    @IBOutlet weak var attributeSortingStackView: UIView!
    @IBOutlet weak var otherSortingStackView: UIView!
    
    @IBOutlet weak var rarityStackView2: UIView!
    
    var sortingButtons: [UIButton]!
    weak var delegate: CardFilterAndSorterTableViewControllerDelegate?
    var filter: CGSSCardFilter!
    var sorter: CGSSSorter!
    // let color = UIColor.init(red: 13/255, green: 148/255, blue: 252/255, alpha: 1)
    var sorterString = ["vocal", "dance", "visual", "overall", "update_id", "sRarity", "sAlbumId"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem.init(title: "完成", style: .Plain, target: self, action: #selector(doneAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        let resetButton = UIBarButtonItem.init(title: "重置", style: .Plain, target: self, action: #selector(resetAction))
        self.navigationItem.rightBarButtonItem = resetButton
        
        prepare()
        setup()
        
    }
    
    func setup() {
        var rarityButtons = [UIButton]()
        rarityButtons.appendContentsOf(rarityStackView.subviews as! [UIButton])
        rarityButtons.appendContentsOf(rarityStackView2.subviews as! [UIButton])
        for i in 0...7 {
            let button = rarityButtons[i]
            button.selected = filter.hasCardRarityFilterType(CGSSCardRarityFilterType.init(rarity: Int(7 - i))!)
        }
        
        var skillTypeButtons = [UIButton]()
        skillTypeButtons.appendContentsOf(skillTypeView.subviews as! [UIButton])
        skillTypeButtons.appendContentsOf(skillTypeView2.subviews as! [UIButton])
        for i in 0...8 {
            let button = skillTypeButtons[i]
            button.selected = filter.hasSkillFilterType(CGSSSkillFilterType.init(raw: 1 << UInt(i))!)
        }
        
        for i in 0...2 {
            let button = cardTypeStackView.subviews[i] as! UIButton
            button.selected = filter.hasCardFilterType(CGSSCardFilterType.init(cardType: Int(i))!)
        }
        
        for i in 0...2 {
            let button = attributeStackView.subviews[i] as! UIButton
            button.selected = filter.hasAttributeFilterType(CGSSAttributeFilterType.init(attributeType: Int(i))!)
        }
        
        for i in 0...1 {
            let button = favoriteStackView.subviews[i] as! UIButton
            button.selected = filter.hasFavoriteFilterType(CGSSFavoriteFilterType.init(rawValue: 1 << UInt(i))!)
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.selected = sorter.ascending
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.selected = !sorter.ascending
        
        for i in 0...3 {
            let button = attributeSortingStackView.subviews[i] as! UIButton
            let index = sorterString.indexOf(sorter.att)
            button.selected = (index == i)
            
        }
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            let index = sorterString.indexOf(sorter.att)
            button.selected = (index == i + 4)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func prepare() {
        var rarityButtons = [UIButton]()
        rarityButtons.appendContentsOf(rarityStackView.subviews as! [UIButton])
        rarityButtons.appendContentsOf(rarityStackView2.subviews as! [UIButton])
        for i in 0...7 {
            let button = rarityButtons[i]
            // button.layer.borderWidth = 1
            // button.layer.borderColor = color.CGColor
            button.addTarget(self, action: #selector(rarityButtonClick), forControlEvents: .TouchUpInside)
            // button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
        }
        
        var skillTypeButtons = [UIButton]()
        skillTypeButtons.appendContentsOf(skillTypeView.subviews as! [UIButton])
        skillTypeButtons.appendContentsOf(skillTypeView2.subviews as! [UIButton])
        for i in 0...8 {
            let button = skillTypeButtons[i]
            // button.layer.borderWidth = 1
            // button.layer.borderColor = color.CGColor
            button.addTarget(self, action: #selector(skillButtonClick), forControlEvents: .TouchUpInside)
            // button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
        }
        
        for i in 0...2 {
            let button = cardTypeStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(cardTypeButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 1000 + i
        }
        
        for i in 0...2 {
            let button = attributeStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(attributeButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 1000 + i
        }
        
        for i in 0...1 {
            let button = favoriteStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(favoriteButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 1000 + i
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.addTarget(self, action: #selector(ascendingAction), forControlEvents: .TouchUpInside)
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.addTarget(self, action: #selector(descendingAction), forControlEvents: .TouchUpInside)
        
        sortingButtons = [UIButton]()
        for i in 0...3 {
            let button = attributeSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
        }
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 2000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
        }
    }
    
    func rarityButtonClick(sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.removeCardRarityFilterType(CGSSCardRarityFilterType.init(rarity: Int(7 - tag))!)
        } else {
            sender.selected = true
            // sender.backgroundColor = color
            filter.addCardRarityFilterType(CGSSCardRarityFilterType.init(rarity: Int(7 - tag))!)
        }
        
    }
    
    func skillButtonClick(sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.removeSkillFilterType(CGSSSkillFilterType.init(raw: 1 << UInt(tag))!)
        } else {
            sender.selected = true
            // sender.backgroundColor = color
            filter.addSkillFilterType(CGSSSkillFilterType.init(raw: 1 << UInt(tag))!)
        }
        
    }
    
    func attributeButtonClick(sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.removeAttributeFilterType(CGSSAttributeFilterType.init(attributeType: Int(tag))!)
        } else {
            sender.selected = true
            // sender.backgroundColor = color
            filter.addAttributeFilterType(CGSSAttributeFilterType.init(attributeType: Int(tag))!)
        }
        
    }
    
    func favoriteButtonClick(sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.removeFavoriteFilterType(CGSSFavoriteFilterType.init(rawValue: 1 << UInt(tag))!)
        } else {
            sender.selected = true
            // sender.backgroundColor = color
            filter.addFavoriteFilterType(CGSSFavoriteFilterType.init(rawValue: 1 << UInt(tag))!)
        }
        
    }
    
    func cardTypeButtonClick(sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.removeCardFilterType(CGSSCardFilterType.init(cardType: Int(tag))!)
        } else {
            sender.selected = true
            // sender.backgroundColor = color
            filter.addCardFilterType(CGSSCardFilterType.init(cardType: Int(tag))!)
        }
        
    }
    
    func ascendingAction(sender: UIButton) {
        if !sender.selected {
            sender.selected = true
            let descendingButton = ascendingStackView.subviews[0] as! UIButton
            descendingButton.selected = false
            sorter.ascending = true
        }
    }
    func descendingAction(sender: UIButton) {
        if !sender.selected {
            sender.selected = true
            let ascendingButton = ascendingStackView.subviews[1] as! UIButton
            ascendingButton.selected = false
            sorter.ascending = false
        }
    }
    
    func sortingButtonsAction(sender: UIButton) {
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
        delegate?.doneAndReturn(filter, sorter: sorter)
        self.navigationController?.popViewControllerAnimated(true)
        // 使用自定义动画效果
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = kCATransitionReveal
         navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
         navigationController?.popViewControllerAnimated(false)*/
    }
    
    func resetAction() {
        if delegate is CardTableViewController {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, skillMask: 0b111111111, favoriteMask: nil)
            sorter = CGSSSorter.init(att: "update_id")
        } else if delegate is TeamCardSelectTableViewController {
            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, skillMask: 0b000000111, favoriteMask: nil)
            sorter = CGSSSorter.init(att: "update_id")
        } else {
            
        }
        setup()
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
            return 7
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

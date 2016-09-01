//
//  CharFilterAndSorterTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/31.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol CharFilterAndSorterTableViewControllerDelegate: class {
    func doneAndReturn(filter: CGSSCharFilter, sorter: CGSSSorter)
}

class CharFilterAndSorterTableViewController: UITableViewController {
    
    @IBOutlet weak var charTypeStackView: UIView!
    
    @IBOutlet weak var cvTypeView: UIView!
    
    @IBOutlet weak var charAgeView: UIView!
    
    @IBOutlet weak var charBloodTypeView: UIView!
    
    @IBOutlet weak var ascendingStackView: UIView!
    
    @IBOutlet weak var basicStackView: UIView!
    
    @IBOutlet weak var threeSizeStackView: UIView!
    
    @IBOutlet weak var otherSortingStackView: UIView!
    
    var sortingButtons: [UIButton]!
    weak var delegate: CharFilterAndSorterTableViewControllerDelegate?
    var filter: CGSSCharFilter!
    var sorter: CGSSSorter!
    // let color = UIColor.init(red: 13/255, green: 148/255, blue: 252/255, alpha: 1)
    var sorterString = ["sHeight", "sWeight", "sAge", "sizeB", "sizeW", "sizeH", "sName", "sCharaId"]
    
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
        for i in 0...2 {
            let button = charTypeStackView.subviews[i] as! UIButton
            button.selected = filter.hasCharFilterType(CGSSCharFilterType.init(cardType: i)!)
        }
        
        for i in 0...4 {
            let button = charAgeView.subviews[i] as! UIButton
            button.selected = filter.hasCharAgeFilterType(CGSSCharAgeFilterType.init(raw: 1 << i)!)
        }
        for i in 0...3 {
            let button = charBloodTypeView.subviews[i] as! UIButton
            button.selected = filter.hasCharBloodFilterType(CGSSCharBloodFilterType.init(raw: 1 << i)!)
        }
        
        for i in 0...1 {
            let button = cvTypeView.subviews[i] as! UIButton
            button.selected = filter.hasCharCVFilterType(CGSSCharCVTypeFilter.init(raw: 1 << i)!)
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.selected = sorter.ascending
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.selected = !sorter.ascending
        
        for i in 0...2 {
            let button = basicStackView.subviews[i] as! UIButton
            let index = sorterString.indexOf(sorter.att)
            button.selected = (index == i)
            
        }
        
        for i in 0...2 {
            let button = threeSizeStackView.subviews[i] as! UIButton
            let index = sorterString.indexOf(sorter.att)
            button.selected = (index == i + 3)
            
        }
        
        for i in 0...1 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            let index = sorterString.indexOf(sorter.att)
            button.selected = (index == i + 6)
        }
        
    }
    
    func prepare() {
        for i in 0...2 {
            let button = charTypeStackView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charTypeButtonClick), forControlEvents: .TouchUpInside)
            // button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
        }
        for i in 0...4 {
            let button = charAgeView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charAgeButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 2000 + i
        }
        for i in 0...3 {
            let button = charBloodTypeView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charBloodButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 3000 + i
        }
        for i in 0...1 {
            let button = cvTypeView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charCVButtonClick), forControlEvents: .TouchUpInside)
            button.tag = 4000 + i
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.addTarget(self, action: #selector(ascendingAction), forControlEvents: .TouchUpInside)
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.addTarget(self, action: #selector(descendingAction), forControlEvents: .TouchUpInside)
        
        sortingButtons = [UIButton]()
        for i in 0...2 {
            let button = basicStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
        }
        
        for i in 0...2 {
            let button = threeSizeStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 2000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
        }
        
        for i in 0...1 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 3000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), forControlEvents: .TouchUpInside)
        }
        
    }
    
    func charTypeButtonClick(sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.selected {
            sender.selected = false
            filter.removeCharFilterType(CGSSCharFilterType.init(cardType: tag)!)
        } else {
            sender.selected = true
            filter.addCharFilterType(CGSSCharFilterType.init(cardType: tag)!)
        }
        
    }
    
    func charCVButtonClick(sender: UIButton) {
        let tag = sender.tag - 4000
        if sender.selected {
            sender.selected = false
            filter.removeCharCVFilterType(CGSSCharCVTypeFilter.init(raw: 1 << tag)!)
        } else {
            sender.selected = true
            filter.addCharCVFilterType(CGSSCharCVTypeFilter.init(raw: 1 << tag)!)
        }
        
    }
    
    func charAgeButtonClick(sender: UIButton) {
        let tag = sender.tag - 2000
        if sender.selected {
            sender.selected = false
            filter.removeCharAgeFilterType(CGSSCharAgeFilterType.init(raw: 1 << tag)!)
        } else {
            sender.selected = true
            filter.addCharAgeFilterType(CGSSCharAgeFilterType.init(raw: 1 << tag)!)
        }
        
    }
    
    func charBloodButtonClick(sender: UIButton) {
        let tag = sender.tag - 3000
        if sender.selected {
            sender.selected = false
            filter.removeCharBloodFilterType(CGSSCharBloodFilterType.init(raw: 1 << tag)!)
        } else {
            sender.selected = true
            filter.addCharBloodFilterType(CGSSCharBloodFilterType.init(raw: 1 << tag)!)
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
        filter = CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11)
        sorter = CGSSSorter.init(att: "sName", ascending: true)
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
            return 4
        } else {
            return 4
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

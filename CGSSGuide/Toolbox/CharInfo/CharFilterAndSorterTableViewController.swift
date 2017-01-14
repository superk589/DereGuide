//
//  CharFilterAndSorterTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/31.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol CharFilterAndSorterTableViewControllerDelegate: class {
    func doneAndReturn(_ filter: CGSSCharFilter, sorter: CGSSSorter)
}

class CharFilterAndSorterTableViewController: UITableViewController {
    
    @IBOutlet weak var charTypeStackView: UIView!
    
    @IBOutlet weak var cvTypeView: UIView!
    
    @IBOutlet weak var charAgeView: UIView!
    
    @IBOutlet weak var charBloodTypeView: UIView!
    
    @IBOutlet weak var favoriteStackView: UIView!
    
    @IBOutlet weak var ascendingStackView: UIView!
    
    @IBOutlet weak var basicStackView: UIView!
    
    @IBOutlet weak var threeSizeStackView: UIView!
    
    @IBOutlet weak var otherSortingStackView: UIView!
    
    var sortingButtons: [UIButton]!
    weak var delegate: CharFilterAndSorterTableViewControllerDelegate?
    var filter: CGSSCharFilter!
    var sorter: CGSSSorter!
    // let color = UIColor.init(red: 13/255, green: 148/255, blue: 252/255, alpha: 1)
    var sorterString = ["sHeight", "sWeight", "BMI", "sAge", "sizeB", "sizeW", "sizeH", "sName", "sCharaId", "sBirthday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem.init(title: NSLocalizedString("完成", comment: "角色信息页面"), style: .plain, target: self, action: #selector(doneAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        let resetButton = UIBarButtonItem.init(title: NSLocalizedString("重置", comment: "角色信息页面"), style: .plain, target: self, action: #selector(resetAction))
        self.navigationItem.rightBarButtonItem = resetButton
        
        prepare()
        setup()
        
    }
    
    func setup() {
        for i in 0...2 {
            let button = charTypeStackView.subviews[i] as! UIButton
            button.isSelected = filter.charTypes.contains(CGSSCharTypes.init(type: i))
        }
        
        for i in 0...4 {
            let button = charAgeView.subviews[i] as! UIButton
            button.isSelected = filter.charAgeTypes.contains(CGSSCharAgeTypes.init(rawValue: 1 << UInt(i)))
        }
        for i in 0...3 {
            let button = charBloodTypeView.subviews[i] as! UIButton
            button.isSelected = filter.charBloodTypes.contains(CGSSCharBloodTypes.init(rawValue: 1 << UInt(i)))
        }
        
        for i in 0...1 {
            let button = cvTypeView.subviews[i] as! UIButton
            button.isSelected = filter.charCVTypes.contains(CGSSCharCVTypes.init(rawValue: 1 << UInt(i)))
        }
        for i in 0...1 {
            let button = favoriteStackView.subviews[i] as! UIButton
            button.isSelected = filter.favoriteTypes.contains(CGSSFavoriteTypes.init(rawValue: 1 << UInt(i)))
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.isSelected = sorter.ascending
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.isSelected = !sorter.ascending
        
        for i in 0...3 {
            let button = basicStackView.subviews[i] as! UIButton
            let index = sorterString.index(of: sorter.property)
            button.isSelected = (index == i)
            
        }
        
        for i in 0...2 {
            let button = threeSizeStackView.subviews[i] as! UIButton
            let index = sorterString.index(of: sorter.property)
            button.isSelected = (index == i + 4)
            
        }
        
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            let index = sorterString.index(of: sorter.property)
            button.isSelected = (index == i + 7)
        }
        
    }
    
    func prepare() {
        for i in 0...2 {
            let button = charTypeStackView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charTypeButtonClick), for: .touchUpInside)
            // button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
        }
        for i in 0...4 {
            let button = charAgeView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charAgeButtonClick), for: .touchUpInside)
            button.tag = 2000 + i
        }
        for i in 0...3 {
            let button = charBloodTypeView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charBloodButtonClick), for: .touchUpInside)
            button.tag = 3000 + i
        }
        for i in 0...1 {
            let button = cvTypeView.subviews[i] as! UIButton
            button.addTarget(self, action: #selector(charCVButtonClick), for: .touchUpInside)
            button.tag = 4000 + i
        }
        for i in 0...1 {
            let button = favoriteStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(favoriteButtonClick), for: .touchUpInside)
            button.tag = 5000 + i
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.addTarget(self, action: #selector(ascendingAction), for: .touchUpInside)
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.addTarget(self, action: #selector(descendingAction), for: .touchUpInside)
        
        sortingButtons = [UIButton]()
        for i in 0...3 {
            let button = basicStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), for: .touchUpInside)
        }
        
        for i in 0...2 {
            let button = threeSizeStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 2000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), for: .touchUpInside)
        }
        
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 3000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), for: .touchUpInside)
        }
        
    }
    
    func charTypeButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.isSelected {
            sender.isSelected = false
            filter.charTypes.remove(CGSSCharTypes.init(type: tag))
        } else {
            sender.isSelected = true
            filter.charTypes.insert(CGSSCharTypes.init(type: tag))
        }
        
    }
    
    func charCVButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 4000
        if sender.isSelected {
            sender.isSelected = false
            filter.charCVTypes.remove(CGSSCharCVTypes.init(rawValue: 1 << UInt(tag)))
        } else {
            sender.isSelected = true
            filter.charCVTypes.insert(CGSSCharCVTypes.init(rawValue: 1 << UInt(tag)))
        }
        
    }
    
    func charAgeButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 2000
        if sender.isSelected {
            sender.isSelected = false
            filter.charAgeTypes.remove(CGSSCharAgeTypes.init(rawValue: 1 << UInt(tag)))
        } else {
            sender.isSelected = true
            filter.charAgeTypes.insert(CGSSCharAgeTypes.init(rawValue: 1 << UInt(tag)))
        }
        
    }
    
    func charBloodButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 3000
        if sender.isSelected {
            sender.isSelected = false
            filter.charBloodTypes.remove(CGSSCharBloodTypes.init(rawValue: 1 << UInt(tag)))
        } else {
            sender.isSelected = true
            filter.charBloodTypes.insert(CGSSCharBloodTypes.init(rawValue: 1 << UInt(tag)))
        }
        
    }
    
    func favoriteButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 5000
        if sender.isSelected {
            sender.isSelected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.favoriteTypes.remove(CGSSFavoriteTypes.init(rawValue: 1 << UInt(tag)))
        } else {
            sender.isSelected = true
            // sender.backgroundColor = color
            filter.favoriteTypes.insert(CGSSFavoriteTypes.init(rawValue: 1 << UInt(tag)))
        }
        
    }
    
    func ascendingAction(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            let descendingButton = ascendingStackView.subviews[0] as! UIButton
            descendingButton.isSelected = false
            sorter.ascending = true
        }
    }
    func descendingAction(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            let ascendingButton = ascendingStackView.subviews[1] as! UIButton
            ascendingButton.isSelected = false
            sorter.ascending = false
        }
    }
    
    func sortingButtonsAction(_ sender: UIButton) {
        if !sender.isSelected {
            for btn in sortingButtons {
                if btn.isSelected {
                    btn.isSelected = false
                }
            }
            sender.isSelected = true
            let index = sortingButtons.index(of: sender)
            sorter.property = sorterString[index!]
        }
    }
    
    func doneAction() {
        delegate?.doneAndReturn(filter, sorter: sorter)
        _ = self.navigationController?.popViewController(animated: true)
        // 使用自定义动画效果
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = kCATransitionReveal
         navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
         navigationController?.popViewControllerAnimated(false)*/
    }
    
    func resetAction() {
        filter = CGSSCharFilter.init(typeMask: 0b111, ageMask: 0b11111, bloodMask: 0b11111, cvMask: 0b11, favoriteMask: 0b11)
        sorter = CGSSSorter.init(property: "sName", ascending: true)
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 5
        } else {
            return 4
        }
    }
}

//
//  CardFilterAndSorterTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/4.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol CardFilterAndSorterTableViewControllerDelegate: class {
    func doneAndReturn(_ filter: CGSSCardFilter, sorter: CGSSSorter)
}

class CardFilterAndSorterTableViewController: UITableViewController {
    
    @IBOutlet weak var rarityStackView: UIView!
    @IBOutlet weak var cardTypeStackView: UIView!
    @IBOutlet weak var skillTypeView: UIView!
    @IBOutlet weak var skillTypeView2: UIView!
    @IBOutlet weak var attributeStackView: UIView!
    //@IBOutlet weak var gachaStackView: UIView!
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
        
        let backButton = UIBarButtonItem.init(title: NSLocalizedString("完成", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(doneAction))
        self.navigationItem.leftBarButtonItem = backButton
        
        let resetButton = UIBarButtonItem.init(title: NSLocalizedString("重置", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(resetAction))
        self.navigationItem.rightBarButtonItem = resetButton
        
        prepare()
        setup()
        
    }
    
    func setup() {
        var rarityButtons = [UIButton]()
        rarityButtons.append(contentsOf: rarityStackView.subviews as! [UIButton])
        rarityButtons.append(contentsOf: rarityStackView2.subviews as! [UIButton])
        for i in 0...7 {
            let button = rarityButtons[i]
            button.isSelected = filter.rarityTypes.contains(CGSSRarityTypes.init(rarity: 7 - i))
        }
        
        var skillTypeButtons = [UIButton]()
        skillTypeButtons.append(contentsOf: skillTypeView.subviews as! [UIButton])
        skillTypeButtons.append(contentsOf: skillTypeView2.subviews as! [UIButton])
        for i in 0...8 {
            let button = skillTypeButtons[i]
            button.isSelected = filter.skillTypes.contains(CGSSSkillTypes.init(rawValue: 1 << UInt(i)))
        }
        
        for i in 0...2 {
            let button = cardTypeStackView.subviews[i] as! UIButton
            button.isSelected = filter.cardTypes.contains(CGSSCardTypes.init(type: i))
        }
        
        for i in 0...2 {
            let button = attributeStackView.subviews[i] as! UIButton
            button.isSelected = filter.attributeTypes.contains(CGSSAttributeTypes.init(type: i))
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
            let button = attributeSortingStackView.subviews[i] as! UIButton
            let index = sorterString.index(of: sorter.property)
            button.isSelected = (index == i)
            
        }
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            let index = sorterString.index(of: sorter.property)
            button.isSelected = (index == i + 4)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func prepare() {
        var rarityButtons = [UIButton]()
        rarityButtons.append(contentsOf: rarityStackView.subviews as! [UIButton])
        rarityButtons.append(contentsOf: rarityStackView2.subviews as! [UIButton])
        for i in 0...7 {
            let button = rarityButtons[i]
            // button.layer.borderWidth = 1
            // button.layer.borderColor = color.CGColor
            button.addTarget(self, action: #selector(rarityButtonClick), for: .touchUpInside)
            // button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
        }
        
        var skillTypeButtons = [UIButton]()
        skillTypeButtons.append(contentsOf: skillTypeView.subviews as! [UIButton])
        skillTypeButtons.append(contentsOf: skillTypeView2.subviews as! [UIButton])
        for i in 0...8 {
            let button = skillTypeButtons[i]
            // button.layer.borderWidth = 1
            // button.layer.borderColor = color.CGColor
            button.addTarget(self, action: #selector(skillButtonClick), for: .touchUpInside)
            // button.setTitleColor(UIColor.redColor(), forState: .Highlighted)
            button.tag = 1000 + i
        }
        
        for i in 0...2 {
            let button = cardTypeStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(cardTypeButtonClick), for: .touchUpInside)
            button.tag = 1000 + i
        }
        
        for i in 0...2 {
            let button = attributeStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(attributeButtonClick), for: .touchUpInside)
            button.tag = 1000 + i
        }
        
        for i in 0...1 {
            let button = favoriteStackView.subviews[i] as! UIButton
            // button.layer.borderWidth = 1
            // button.layer.borderColor = UIColor.blueColor().CGColor
            // button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            button.addTarget(self, action: #selector(favoriteButtonClick), for: .touchUpInside)
            button.tag = 1000 + i
        }
        
        let ascendingbutton = ascendingStackView.subviews[1] as! UIButton
        ascendingbutton.addTarget(self, action: #selector(ascendingAction), for: .touchUpInside)
        
        let descendingButton = ascendingStackView.subviews[0] as! UIButton
        descendingButton.addTarget(self, action: #selector(descendingAction), for: .touchUpInside)
        
        sortingButtons = [UIButton]()
        for i in 0...3 {
            let button = attributeSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), for: .touchUpInside)
        }
        for i in 0...2 {
            let button = otherSortingStackView.subviews[i] as! UIButton
            sortingButtons.append(button)
            button.tag = 2000 + i
            button.addTarget(self, action: #selector(sortingButtonsAction), for: .touchUpInside)
        }
    }
    
    func rarityButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.isSelected {
            sender.isSelected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.rarityTypes.remove(CGSSRarityTypes.init(rarity: 7 - tag))
        } else {
            sender.isSelected = true
            // sender.backgroundColor = color
            filter.rarityTypes.insert(CGSSRarityTypes.init(rarity: 7 - tag))
        }
        
    }
    
    func skillButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.isSelected {
            sender.isSelected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.skillTypes.remove(CGSSSkillTypes.init(rawValue: 1 << UInt(tag)))
        } else {
            sender.isSelected = true
            // sender.backgroundColor = color
            filter.skillTypes.insert(CGSSSkillTypes.init(rawValue: 1 << UInt(tag)))
        }
        
    }
    
    func attributeButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.isSelected {
            sender.isSelected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.attributeTypes.remove(CGSSAttributeTypes.init(type: tag))
        } else {
            sender.isSelected = true
            // sender.backgroundColor = color
            filter.attributeTypes.insert(CGSSAttributeTypes.init(type: tag))
        }
        
    }
    
    func favoriteButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 1000
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
    
    func cardTypeButtonClick(_ sender: UIButton) {
        let tag = sender.tag - 1000
        if sender.isSelected {
            sender.isSelected = false
            // sender.backgroundColor = UIColor.clearColor()
            filter.cardTypes.remove(CGSSCardTypes.init(type: tag))
        } else {
            sender.isSelected = true
            // sender.backgroundColor = color
            filter.cardTypes.insert(CGSSCardTypes.init(type: tag))
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
//        if delegate is CardTableViewController {
//            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11110000, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
//            sorter = CGSSSorter.init(property: "update_id")
//        } else if delegate is TeamCardSelectTableViewController {
//            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b10100000, skillMask: 0b000000111, gachaMask: 0b1111, favoriteMask: nil)
//            sorter = CGSSSorter.init(property: "update_id")
//        } else {
//            filter = CGSSCardFilter.init(cardMask: 0b1111, attributeMask: 0b1111, rarityMask: 0b11111111, skillMask: 0b111111111, gachaMask: 0b1111, favoriteMask: nil)
//            sorter = CGSSSorter.init(property: "sRarity")
//        }
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
            return 7
        } else {
            return 3
        }
    }
}

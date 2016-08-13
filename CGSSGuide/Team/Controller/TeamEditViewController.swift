//
//  TeamEditViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol TeamEditViewControllerDelegate: class {
    func save(team: CGSSTeam)
}

class TeamEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: TeamEditViewControllerDelegate?
    var leader: CGSSTeamMember?
    // 因为设置时可能存在不按1234的顺序设置的情况 故此处设置队员为int下标的字典
    var subs = [Int: CGSSTeamMember]()
    var friendLeader: CGSSTeamMember?
    var backValue: Int?
    let tv = UITableView()
    var hv = UIView()
    var lastIndex = 0
    var lastScrollViewOffset: CGPoint?
    var keyBoardHeigt: CGFloat = 258
    var cells = [TeamMemberTableViewCell]()
    /*override func viewWillAppear(animated: Bool) {
     super.viewWillAppear(animated)
     NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setKeyboardHeight), name: UIKeyboardWillShowNotification, object: nil)
     }

     override func viewDidDisappear(animated: Bool) {
     super.viewWillDisappear(animated)
     NSNotificationCenter.defaultCenter().removeObserver(self)
     }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Save, target: self, action: #selector(saveTeam))
        
        hv.frame = CGRectMake(0, 0, CGSSTool.width, 100)
        for i in 0...5 {
            let cell = TeamMemberTableViewCell()
            if i == 0 {
                cell.title.text = "队长"
                if let leader = self.leader {
                    cell.initWith(leader, type: .Leader)
                }
            } else if i < 5 {
                cell.title.text = "队员\(i)"
                if let sub = subs[i - 1] {
                    cell.initWith(sub, type: .Sub)
                }
            } else {
                cell.title.text = "好友"
                if let fLeader = self.friendLeader {
                    cell.initWith(fLeader, type: .Friend)
                }
            }
            cell.tag = 100 + i
            cell.delegate = self
            cells.append(cell)
        }
        
        // 暂时去除header
        // tv.tableHeaderView = hv
        tv.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tv.frame = CGRectMake(0, 64, CGSSTool.width, CGSSTool.height - 64)
        tv.delegate = self
        tv.dataSource = self
        // tv.registerClass(TeamMemberTableViewCell.self, forCellReuseIdentifier: "TeamMemberCell")
        tv.tableFooterView = UIView.init(frame: CGRectZero)
        // tv.estimatedRowHeight = 100
        // tv.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tv)
        
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(cancel))
        swipe.direction = .Right
        self.view.addGestureRecognizer(swipe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initWith(team: CGSSTeam) {
        self.leader = team.leader
        self.friendLeader = team.friendLeader
        for i in 0...3 {
            self.subs[i] = team.subs[i]
        }
        self.backValue = team.backSupportValue
    }
    
    func getMemberByIndex(index: Int) -> CGSSTeamMember? {
        if index == 0 {
            return leader
        } else if index < 5 {
            return subs[index - 1]
        } else {
            return friendLeader
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return max(cells[indexPath.row].contentView.fheight, 96)
    }
    
    func saveTeam() {
        if let leader = self.leader, friendLeader = self.friendLeader where subs.count == 4 {
            let team = CGSSTeam.init(leader: leader, subs: [CGSSTeamMember].init(subs.values), backSupportValue: backValue ?? 100000, friendLeader: friendLeader)
            delegate?.save(team)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        return cell
    }
    
    var teamCardVC: TeamCardSelectTableViewController?
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndex = indexPath.row
        if teamCardVC == nil {
            teamCardVC = TeamCardSelectTableViewController()
            teamCardVC!.delegate = self
        }
        // self.navigationController?.pushViewController(teamCardVC!, animated: true)
        
        // 使用自定义动画效果
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        // transition.subtype = kCATransitionFromRight
        navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
        navigationController?.pushViewController(teamCardVC!, animated: false)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tv.separatorInset = UIEdgeInsetsZero
        tv.layoutMargins = UIEdgeInsetsZero
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
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
extension TeamEditViewController: TeamMemberTableViewCellDelegate {
    
    func skillLevelDidChange(cell: TeamMemberTableViewCell, lv: String) {
        UIView.animateWithDuration(0.25, animations: {
            self.tv.contentOffset = self.lastScrollViewOffset ?? CGPointMake(0, 0)
        })
        let member = getMemberByIndex(cell.tag - 100)
        var newLevel = Int(lv) ?? 10
        if newLevel > 10 || newLevel < 1 {
            newLevel = 10
        }
        member?.skillLevel = newLevel
        cell.initSkillViewWith((getMemberByIndex(cell.tag - 100)?.cardRef?.skill)!, skillLevel: getMemberByIndex(cell.tag - 100)?.skillLevel)
    }
    
    func skillLevelDidBeginEditing(cell: TeamMemberTableViewCell) {
        lastScrollViewOffset = tv.contentOffset
        if cell.tag - 100 >= 2 {
            var height: CGFloat = 0
            for i in 0...cell.tag - 100 {
                height += cells[i].contentView.fheight
            }
            UIView.animateWithDuration(0.25, animations: {
                self.tv.contentOffset = CGPointMake(0, -min(CGSSTool.height - 64 - self.keyBoardHeigt - height, 0))
            })
            
        }
    }
}

extension TeamEditViewController: BaseCardTableViewControllerDelegate {
    func selectCard(card: CGSSCard) {
        let cell = cells[lastIndex]
        if lastIndex == 0 {
            self.leader = CGSSTeamMember.init(id: card.id!, skillLevel: 10)
            cell.initWith(leader!, type: .Leader)
            if self.friendLeader == nil {
                self.friendLeader = CGSSTeamMember.init(id: card.id!, skillLevel: 10)
                cells.last!.initWith(friendLeader!, type: .Friend)
            }
        } else if lastIndex < 5 {
            self.subs[lastIndex - 1] = CGSSTeamMember.init(id: card.id!, skillLevel: 10)
            cell.initWith(subs[lastIndex - 1]!, type: .Sub)
        } else {
            self.friendLeader = CGSSTeamMember.init(id: card.id!, skillLevel: 10)
            cell.initWith(friendLeader!, type: .Friend)
            
        }
        tv.reloadData()
    }
}

//MARK: UIScrollView代理方法
extension TeamEditViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        tv.endEditing(true)
    }
}

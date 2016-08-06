//
//  TeamDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/6.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol TeamDetailViewDelegate: class {
    func editTeam()
    func skillShowOrHide()
    func startCalc()
    func cardIconClick(id:Int)
}

class TeamDetailView: UIView {
    var leftSpace:CGFloat = 10
    var topSpace:CGFloat = 10
    weak var delegate: TeamDetailViewDelegate?
    var selfLeaderLabel: UILabel!
    var icons:[CGSSCardIconView]!
    var editTeamButton: UIButton!
    var friendLeaderLabel: UILabel!
    
    var leaderSkillGrid : CGSSGridView!
    
    var backSupportLabel: UILabel!
    var backSupportTF :UITextField! {
        didSet {
            backSupportTF.text = "100000"
        }
    }
    
    var presentValueGrid: CGSSGridView!
    var selectSongLabel: UILabel! {
        didSet {
            selectSongLabel.text = "请选择歌曲和难度"
        }
    }
    
    var songNameLabel: UILabel!
    var songDiffLabel: UILabel!
    var songLengthLabel: UILabel!
    var skillListDescLabel: UILabel! {
        didSet {
            skillListDescLabel.text = "技能列表: "
        }
    }
    var skillShowOrHideButton: UIButton!
    var skillListGrid: CGSSGridView!
    
    var bottomView: UIView!
    var startCalcButton:UIButton!
    var skillProcGrid: CGSSGridView!
    var scoreGrid: CGSSGridView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var originY:CGFloat = topSpace
        let width = CGSSTool.width - 2 * leftSpace
        selfLeaderLabel = UILabel.init(frame: CGRectMake(leftSpace, topSpace, width, 55))
        selfLeaderLabel.numberOfLines = 3
        selfLeaderLabel.font = UIFont.systemFontOfSize(14)
        selfLeaderLabel.textColor = UIColor.darkGrayColor()
        originY += 55 + topSpace
        
        let btnW = (width - 30 - 5 * leftSpace) / 6
        icons = [CGSSCardIconView]()
        for i in 0...5 {
            let icon = CGSSCardIconView.init(frame: CGRectMake(leftSpace + (btnW + leftSpace) * CGFloat(i), originY, btnW, btnW))
            addSubview(icon)
            icons.append(icon)
        }
        editTeamButton = UIButton.init(frame: CGRectMake(CGSSTool.width - 30, originY + 5, 30, 30))
        editTeamButton.setTitle(">", forState: .Normal)
        editTeamButton.titleLabel?.textAlignment = .Right
        editTeamButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        editTeamButton.addTarget(self, action: #selector(editTeam), forControlEvents: .TouchUpInside)
        originY += btnW + topSpace
        
        friendLeaderLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, width, 55))
        friendLeaderLabel.numberOfLines = 3
        friendLeaderLabel.font = UIFont.systemFontOfSize(14)
        friendLeaderLabel.textColor = UIColor.darkGrayColor()
        friendLeaderLabel.textAlignment = .Right
        originY += 55 + topSpace

        
        leaderSkillGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, originY, width, 56), rows: 4, columns: 6)
        
        originY += 56 + topSpace
        
        backSupportLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 21))
        backSupportLabel.font = UIFont.systemFontOfSize(14)
        //backSupportLabel.textColor = UIColor.lightGrayColor()
        backSupportLabel.text = "后援数值: "
        backSupportLabel.textColor = UIColor.darkGrayColor()
        backSupportTF = UITextField.init(frame: CGRectMake(CGSSTool.width / 2 + leftSpace, originY, CGSSTool.width / 2 - 2 * leftSpace, 21))
        backSupportTF.autocorrectionType = .No
        backSupportTF.autocapitalizationType = .None
        backSupportTF.borderStyle = .RoundedRect
        backSupportTF.textAlignment = .Right
        backSupportTF.addTarget(self, action: #selector(endEditing), forControlEvents: .EditingDidEnd)
        backSupportTF.addTarget(self, action: #selector(endEditing), forControlEvents: .EditingDidEndOnExit)
        backSupportTF.keyboardType = .NumbersAndPunctuation
        backSupportTF.font = UIFont.systemFontOfSize(14)
        
        originY += 21 + topSpace
        
        presentValueGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, originY, width, 112), rows: 8, columns: 6)
        originY += 112 + topSpace
        
        selectSongLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, 150, 21))
        selectSongLabel.textColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        originY += 21 + topSpace
        
        songNameLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, width, 21))
        originY += 21 + topSpace
        
        songDiffLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, width / 2, 18))
        songDiffLabel.textColor = UIColor.grayColor()
        songDiffLabel.textAlignment = .Left
        songDiffLabel.font = UIFont.systemFontOfSize(12)
        
        songLengthLabel = UILabel.init(frame: CGRectMake(CGSSTool.width / 2 + leftSpace , originY, width / 2, 18))
        songLengthLabel.textColor = UIColor.grayColor()
        songLengthLabel.textAlignment = .Left
        songLengthLabel.font = UIFont.systemFontOfSize(12)
        originY += 18 + topSpace
        
        skillListDescLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 21))
        originY += 21 + topSpace
        
        skillListGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, originY, width, 140), rows: 10, columns: 1)
        
        bottomView = UIView.init(frame: CGRectMake(0, originY, CGSSTool.width, 0))
        
        startCalcButton = UIButton.init(frame: CGRectMake(leftSpace, 0, width, 25))
        startCalcButton.setTitle("开始计算", forState: .Normal)

        scoreGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, 35, width, 70), rows: 5, columns: 3)
    
        
        bottomView.addSubview(startCalcButton)
        bottomView.addSubview(scoreGrid)
        
        
        
        addSubview(selfLeaderLabel)
        addSubview(editTeamButton)
        addSubview(friendLeaderLabel)
        addSubview(leaderSkillGrid)
        addSubview(backSupportTF)
        addSubview(backSupportLabel)
        addSubview(presentValueGrid)
        addSubview(selectSongLabel)
        addSubview(songNameLabel)
        addSubview(songDiffLabel)
        addSubview(songLengthLabel)
        addSubview(skillListDescLabel)
        addSubview(skillListGrid)
        addSubview(bottomView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func editTeam() {
        delegate?.editTeam()
    }
    func startCalc() {
        delegate?.startCalc()
    }
    var skillListIsShow = false
    func skillShowOrHide() {
        skillListIsShow = !skillListIsShow
        UIView.animateWithDuration(0.25) { 
            self.updateBottomView()
        }
        delegate?.skillShowOrHide()
    }
    func updateBottomView() {
        if skillListIsShow {
            bottomView.frame.origin.y = skillListGrid.frame.size.height + skillListGrid.frame.origin.y
        } else {
            bottomView.frame.origin.y = skillListGrid.frame.origin.y
        }
    }
    
    func cardIconClick(icon:CGSSCardIconView) {
        delegate?.cardIconClick(icon.cardId!)
    }
    
    
    func initWith(team:CGSSTeam) {
        
        for i in 0...5 {
            icons[i].setWithCardId((team[i]?.cardRef?.id)!, target: self, action: #selector(cardIconClick))
        }
        if let selfLeaderRef = team.leader.cardRef {
            selfLeaderLabel.text = "队长技能: \(selfLeaderRef.leader_skill?.name ?? "无")\n\(selfLeaderRef.leader_skill?.explain_en ?? "")"
        }
        if let friendLeaderRef = team.friendLeader.cardRef {
            friendLeaderLabel.text = "好友技能: \(friendLeaderRef.leader_skill?.name ?? "无")\n\(friendLeaderRef.leader_skill?.explain_en ?? "")"
        }
        
            
        var upValueStrings = [[String]]()

        let contents = team.getUpContent()
        upValueStrings.append(["  ","Vocal","Dance","Visual","技能触发","HP"])
        
        var upCuteString = [String]()
        upCuteString.append("Cu")
        upCuteString.append(contents[.Cute]?[.Vocal] != nil ? "+\(String(contents[.Cute]![.Vocal]!))%" : "")
        upCuteString.append(contents[.Cute]?[.Dance] != nil ? "+\(String(contents[.Cute]![.Dance]!))%" : "")
        upCuteString.append(contents[.Cute]?[.Visual] != nil ? "+\(String(contents[.Cute]![.Visual]!))%" : "")
        upCuteString.append(contents[.Cute]?[.Proc] != nil ? "+\(String(contents[.Cute]![.Proc]!))%" : "")
        upCuteString.append(contents[.Cute]?[.Life] != nil ? "+\(String(contents[.Cute]![.Life]!))%" : "")
        
        var upCoolString = [String]()
        upCoolString.append("Co")
        upCoolString.append(contents[.Cool]?[.Vocal] != nil ? "+\(String(contents[.Cool]![.Vocal]!))%" : "")
        upCoolString.append(contents[.Cool]?[.Dance] != nil ? "+\(String(contents[.Cool]![.Dance]!))%" : "")
        upCoolString.append(contents[.Cool]?[.Visual] != nil ? "+\(String(contents[.Cool]![.Visual]!))%" : "")
        upCoolString.append(contents[.Cool]?[.Proc] != nil ? "+\(String(contents[.Cool]![.Proc]!))%" : "")
        upCoolString.append(contents[.Cool]?[.Life] != nil ? "+\(String(contents[.Cool]![.Life]!))%" : "")
        
        
        var upPassionString = [String]()
        upPassionString.append("Pa")
        upPassionString.append(contents[.Passion]?[.Vocal] != nil ? "+\(String(contents[.Passion]![.Vocal]!))%" : "")
        upPassionString.append(contents[.Passion]?[.Dance] != nil ? "+\(String(contents[.Passion]![.Dance]!))%" : "")
        upPassionString.append(contents[.Passion]?[.Visual] != nil ? "+\(String(contents[.Passion]![.Visual]!))%" : "")
        upPassionString.append(contents[.Passion]?[.Proc] != nil ? "+\(String(contents[.Passion]![.Proc]!))%" : "")
        upPassionString.append(contents[.Passion]?[.Life] != nil ? "+\(String(contents[.Passion]![.Life]!))%" : "")
        
        upValueStrings.append(upCuteString)
        upValueStrings.append(upCoolString)
        upValueStrings.append(upPassionString)


        var upValueColors = [[UIColor]]()
        let colorArray = [UIColor.blackColor(),CGSSTool.vocalColor,CGSSTool.danceColor,CGSSTool.visualColor, UIColor.blackColor().colorWithAlphaComponent(0.5), CGSSTool.lifeColor]
        upValueColors.appendContentsOf(Array.init(count: 4, repeatedValue: colorArray))
        upValueColors[1][0] = CGSSTool.cuteColor
        upValueColors[2][0] = CGSSTool.coolColor
        upValueColors[3][0] = CGSSTool.passionColor
       
        leaderSkillGrid.setGridContent(upValueStrings)
        leaderSkillGrid.setGridColor(upValueColors)
     
        
        var presentValueString = [[String]]()
        var presentColor = [[UIColor]]()
        
        presentValueString.append([" ", "HP", "Vocal","Dance","Visual","Total"])
        var presentSub1 = ["彩色曲"]
        presentSub1.appendContentsOf(team.getPresentValue(.Office).toStringArray())
        var presentSub2 = ["Cu曲"]
        presentSub2.appendContentsOf(team.getPresentValue(.Cute).toStringArray())
        var presentSub3 = ["Co曲"]
        presentSub3.appendContentsOf(team.getPresentValue(.Cool).toStringArray())
        var presentSub4 = ["Pa曲"]
        presentSub4.appendContentsOf(team.getPresentValue(.Passion).toStringArray())
        var presentSub5 = ["Cu(G)"]
        presentSub5.appendContentsOf(team.getPresentValueInGroove(.Cute).toStringArray())
        var presentSub6 = ["Co(G)"]
        presentSub6.appendContentsOf(team.getPresentValueInGroove(.Cool).toStringArray())
        var presentSub7 = ["Pa(G)"]
        presentSub7.appendContentsOf(team.getPresentValueInGroove(.Passion).toStringArray())
        presentValueString.append(presentSub1)
        presentValueString.append(presentSub2)
        presentValueString.append(presentSub3)
        presentValueString.append(presentSub4)
        presentValueString.append(presentSub5)
        presentValueString.append(presentSub6)
        presentValueString.append(presentSub7)

        
        let colorArray2 = [UIColor.blackColor(), CGSSTool.lifeColor, CGSSTool.vocalColor,CGSSTool.danceColor,CGSSTool.visualColor, UIColor.blackColor().colorWithAlphaComponent(0.5)]
        presentColor.appendContentsOf(Array.init(count: 8, repeatedValue: colorArray2))
        presentValueGrid.setGridContent(presentValueString)
        presentValueGrid.setGridColor(presentColor)
        
        backSupportTF.text = String(team.teamBackSupportValue ?? 100000)

        
        
        //skillProcGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, scoreGrid.frame.size.height + scoreGrid.frame.origin.y + topSpace, CGSSTool.width - 2 * leftSpace, CGFloat(skillKind) * 14 + 1), rows: skillKind, columns: 3)
        bottomView.frame.size.height = skillListGrid.frame.size.height + skillListGrid.frame.origin.y
        frame.size = CGSizeMake(CGSSTool.width, bottomView.frame.size.height + bottomView.frame.origin.y)
    }

    

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

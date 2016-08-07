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
    func backValueChanged(value:Int)
    func selectSong()
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
    var backSupportTF :UITextField!
    
    var presentValueGrid: CGSSGridView!
    
    var skillListDescLabel: UILabel!
    var skillShowOrHideButton: UIButton!
    var skillListGrid: CGSSGridView!
    
    var selectSongLabel: UILabel!
    var selectSongButton: UIButton!
    var songJacket: UIImageView!
    var songNameLabel: UILabel!
    var songDiffLabel: UILabel!
    var songLengthLabel: UILabel!
 
    
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
        
        let btnW = (width - 30 - 6 * leftSpace) / 6
        icons = [CGSSCardIconView]()
        for i in 0...5 {
            let icon = CGSSCardIconView.init(frame: CGRectMake(leftSpace + (btnW + leftSpace) * CGFloat(i), originY, btnW, btnW))
            addSubview(icon)
            icons.append(icon)
        }
        
        
        
        editTeamButton = UIButton.init(frame: CGRectMake(CGSSTool.width - 40, originY + 7, 30, 30))
        editTeamButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        editTeamButton.tintColor = UIColor.lightGrayColor()
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
        backSupportTF.addTarget(self, action: #selector(backValueChanged), forControlEvents: .EditingDidEnd)
        backSupportTF.addTarget(self, action: #selector(backValueChanged), forControlEvents: .EditingDidEndOnExit)
        backSupportTF.keyboardType = .NumbersAndPunctuation
        backSupportTF.returnKeyType = .Done
        backSupportTF.font = UIFont.systemFontOfSize(14)
        
        originY += 21 + topSpace
        
        presentValueGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, originY, width, 112), rows: 8, columns: 5)
        originY += 112 + topSpace
        
        
        skillListDescLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 22))
        skillListDescLabel.text = "技能列表: "
        skillListDescLabel.font = UIFont.systemFontOfSize(14)
        skillListDescLabel.textColor = UIColor.darkGrayColor()
        
        skillShowOrHideButton = UIButton.init(frame: CGRectMake(CGSSTool.width - 40, originY, 22, 22))
        //让图片总是可以被染色影响
        let image = UIImage.init(named: "764-arrow-down-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate)
        skillShowOrHideButton.setImage(image, forState: .Normal)
        skillShowOrHideButton.tintColor = UIColor.lightGrayColor()
        skillShowOrHideButton.addTarget(self, action: #selector(skillShowOrHide), forControlEvents: .TouchUpInside)
        originY += 22 + topSpace
        
        skillListGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, originY, width, 225), rows: 5, columns: 1, textAligment: .Left)
        
        bottomView = UIView.init(frame: CGRectMake(0, originY, CGSSTool.width, 0))
        bottomView.backgroundColor = UIColor.whiteColor()
        
        originY = topSpace
        selectSongLabel = UILabel.init(frame: CGRectMake(CGSSTool.width / 2 - 75, originY + 9, 150, 30))
        selectSongLabel.textColor = UIColor.lightGrayColor()
        selectSongLabel.text = "请选择歌曲"
        selectSongLabel.textAlignment = .Center
        selectSongLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectSong))
        selectSongLabel.addGestureRecognizer(tap)
        selectSongLabel.font = UIFont.systemFontOfSize(18)
        selectSongButton = UIButton.init(frame: CGRectMake(CGSSTool.width - 40, originY + 7, 30, 30))
        selectSongButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        selectSongButton.tintColor = UIColor.lightGrayColor()
        selectSongButton.addTarget(self, action: #selector(selectSong), forControlEvents: .TouchUpInside)
        //originY += 30 + topSpace
        
        songJacket = UIImageView.init(frame: CGRectMake(leftSpace, originY, 48, 48))
        
        songNameLabel = UILabel.init(frame: CGRectMake(48 + 2 * leftSpace, originY, width, 21))
        originY += 21 + topSpace
        
        songDiffLabel = UILabel.init(frame: CGRectMake(48 + 2 * leftSpace, originY, width, 18))
        songDiffLabel.textColor = UIColor.grayColor()
        songDiffLabel.textAlignment = .Left
        songDiffLabel.font = UIFont.systemFontOfSize(12)
        
        songLengthLabel = UILabel.init(frame: CGRectMake(CGSSTool.width / 2 + leftSpace , originY, width / 2, 18))
        songLengthLabel.textColor = UIColor.grayColor()
        songLengthLabel.textAlignment = .Left
        songLengthLabel.font = UIFont.systemFontOfSize(12)
        originY += 18 + topSpace
        
        startCalcButton = UIButton.init(frame: CGRectMake(leftSpace, originY, width, 25))
        startCalcButton.setTitle("开始计算", forState: .Normal)

        originY += 25 + topSpace
        scoreGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, originY, width, 70), rows: 5, columns: 3)
    
        bottomView.addSubview(selectSongLabel)
        bottomView.addSubview(selectSongButton)
        bottomView.addSubview(songNameLabel)
        bottomView.addSubview(songDiffLabel)
        bottomView.addSubview(songLengthLabel)
        bottomView.addSubview(songJacket)
        bottomView.addSubview(startCalcButton)
        bottomView.addSubview(scoreGrid)
        
        
    
        addSubview(selfLeaderLabel)
        addSubview(editTeamButton)
        addSubview(friendLeaderLabel)
        addSubview(leaderSkillGrid)
        addSubview(backSupportTF)
        addSubview(backSupportLabel)
        addSubview(presentValueGrid)
        addSubview(skillListDescLabel)
        addSubview(skillShowOrHideButton)
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
        if skillListIsShow {
            let image = UIImage.init(named: "763-arrow-up-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate)
            skillShowOrHideButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage.init(named: "764-arrow-down-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate)
            skillShowOrHideButton.setImage(image, forState: .Normal)

        }
        UIView.animateWithDuration(0.25) {
            self.updateBottomView()
        }
        delegate?.skillShowOrHide()
    }

    func updateBottomView() {
        if skillListIsShow {
            bottomView.frame.origin.y = skillListGrid.frame.size.height + skillListGrid.frame.origin.y + topSpace
        } else {
            bottomView.frame.origin.y = skillListGrid.frame.origin.y
        }
        frame.size = CGSizeMake(CGSSTool.width, bottomView.frame.size.height + bottomView.frame.origin.y)
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
        let colorArray = [UIColor.blackColor(),CGSSTool.vocalColor,CGSSTool.danceColor,CGSSTool.visualColor, UIColor.darkGrayColor(), CGSSTool.lifeColor]
        upValueColors.appendContentsOf(Array.init(count: 4, repeatedValue: colorArray))
        upValueColors[1][0] = CGSSTool.cuteColor
        upValueColors[2][0] = CGSSTool.coolColor
        upValueColors[3][0] = CGSSTool.passionColor
       
        leaderSkillGrid.setGridContent(upValueStrings)
        leaderSkillGrid.setGridColor(upValueColors)
     
        
        updatePresentValueGrid(team)
        backSupportTF.text = String(team.backSupportValue ?? 100000)

     
        
        var skillListStrings = [[String]]()
        let skillListColor = [[UIColor]].init(count: 5, repeatedValue: [UIColor.darkGrayColor()])
        for i in 0...4 {
            if let skill = team[i]?.cardRef?.skill {
                skillListStrings.append([skill.skill_name! + ": Lv.\(team[i]!.skillLevel!)\n" + skill.getExplainByLevel(team[i]!.skillLevel!)])
            } else {
                skillListStrings.append([""])
            }
        }
        
        skillListGrid.setGridContent(skillListStrings)
        skillListGrid.setGridColor(skillListColor)
        
        //skillProcGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, scoreGrid.frame.size.height + scoreGrid.frame.origin.y + topSpace, CGSSTool.width - 2 * leftSpace, CGFloat(skillKind) * 14 + 1), rows: skillKind, columns: 3)
        bottomView.frame.size.height = skillListGrid.frame.size.height + skillListGrid.frame.origin.y
        frame.size = CGSizeMake(CGSSTool.width, bottomView.frame.size.height + bottomView.frame.origin.y)
    }

    func updatePresentValueGrid(team:CGSSTeam) {
        var presentValueString = [[String]]()
        var presentColor = [[UIColor]]()
        
        presentValueString.append([" ", "Vocal","Dance","Visual","Total"])
        var presentSub1 = ["彩色曲"]
        presentSub1.appendContentsOf(team.getPresentValue(.Office).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub2 = ["Cu曲"]
        presentSub2.appendContentsOf(team.getPresentValue(.Cute).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub3 = ["Co曲"]
        presentSub3.appendContentsOf(team.getPresentValue(.Cool).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub4 = ["Pa曲"]
        presentSub4.appendContentsOf(team.getPresentValue(.Passion).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub5 = ["Vo(G)"]
        presentSub5.appendContentsOf(team.getPresentValueInGroove(team.leader.cardRef!.cardFilterType, burstType: .Vocal).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub6 = ["Da(G)"]
        presentSub6.appendContentsOf(team.getPresentValueInGroove(team.leader.cardRef!.cardFilterType, burstType: .Dance).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub7 = ["Vi(G)"]
        presentSub7.appendContentsOf(team.getPresentValueInGroove(team.leader.cardRef!.cardFilterType, burstType: .Visual).toStringArrayWithBackValue(team.backSupportValue))
        presentValueString.append(presentSub1)
        presentValueString.append(presentSub2)
        presentValueString.append(presentSub3)
        presentValueString.append(presentSub4)
        presentValueString.append(presentSub5)
        presentValueString.append(presentSub6)
        presentValueString.append(presentSub7)
        
        
        let colorArray2 = [UIColor.blackColor(), CGSSTool.vocalColor,CGSSTool.danceColor,CGSSTool.visualColor, UIColor.darkGrayColor()]
        presentColor.appendContentsOf(Array.init(count: 8, repeatedValue: colorArray2))
        presentValueGrid.setGridContent(presentValueString)
        presentValueGrid.setGridColor(presentColor)

    }

    func backValueChanged() {
        delegate?.backValueChanged(Int(backSupportTF.text!) ?? 100000)
    }
    
    func selectSong() {
        delegate?.selectSong()
    }
    
    func updateSongInfo(live:CGSSLive, beatmaps:[CGSSBeatmap], diff:Int) {
        selectSongLabel.hidden = true
        let song = live.musicRef!
        songDiffLabel.text = "\(live.getStarsForDiff(diff))☆ \(CGSSTool.diffStringFromInt(diff)) bpm: \(song.bpm!) notes: \(beatmaps[diff-1].numberOfNotes) 时长:\(Int(beatmaps[diff - 1].totalSeconds))秒"
        
        //songDiffLabel.text = CGSSTool.diffStringFromInt(diff)
        songNameLabel.text = live.musicRef?.title
        songNameLabel.textColor = live.getLiveColor()
        //songLengthLabel.text = String(Int(beatmaps[diff - 1].totalSeconds)) + "秒"
        songJacket.sd_setImageWithURL(NSURL.init(string: live.musicRef!.imageURLString)!)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

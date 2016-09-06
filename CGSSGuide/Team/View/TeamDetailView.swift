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
    func cardIconClick(id: Int)
    func backValueChanged(value: Int)
    func selectSong()
    func liveTypeButtonClick()
    func grooveTypeButtonClick()
}

class TeamDetailView: UIView {
    var leftSpace: CGFloat = 10
    var topSpace: CGFloat = 10
    weak var delegate: TeamDetailViewDelegate?
    var selfLeaderLabel: UILabel!
    var icons: [CGSSCardIconView]!
    var editTeamButton: UIButton!
    var friendLeaderLabel: UILabel!
    
    var leaderSkillGrid: CGSSGridLabel!
    
    var backSupportLabel: UILabel!
    var backSupportTF: UITextField!
    
    var presentValueGrid: CGSSGridLabel!
    
    var skillListDescLabel: UILabel!
    var skillShowOrHideButton: UIButton!
    var skillListGrid: CGSSGridLabel!
    
    var selectSongLabel: UILabel!
    var selectSongButton: UIButton!
    var songJacket: UIImageView!
    var songNameLabel: UILabel!
    var songDiffLabel: UILabel!
    var songLengthLabel: UILabel!
    var liveTypeButton: UIButton!
    var liveTypeDescLable: UILabel!
    var grooveTypeButton: UIButton!
    var grooveTypeDescLable: UILabel!
    
    var bottomView: UIView!
    var startCalcButton: UIButton!
    var skillProcGrid: CGSSGridLabel!
    var scoreGrid: CGSSGridLabel!
    var scoreDescLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var originY: CGFloat = topSpace
        let width = CGSSGlobal.width - 2 * leftSpace
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
        
        editTeamButton = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 40, originY, 30, btnW))
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
        
        let descLabel1 = UILabel.init(frame: CGRectMake(leftSpace, originY, width - 2 * leftSpace, 17))
        descLabel1.text = "队长加成: "
        descLabel1.font = UIFont.systemFontOfSize(14)
        descLabel1.textAlignment = .Left
        
        originY += 17 + topSpace
        
        leaderSkillGrid = CGSSGridLabel.init(frame: CGRectMake(leftSpace, originY, width, 56), rows: 4, columns: 6)
        
        originY += 56 + topSpace
        drawSectionLine(originY)
        originY += topSpace
        
        let descLabel2 = UILabel.init(frame: CGRectMake(leftSpace, originY, width - 2 * leftSpace, 17))
        descLabel2.text = "表现值: "
        descLabel2.font = UIFont.systemFontOfSize(14)
        descLabel2.textAlignment = .Left
        
        originY += 17 + topSpace
        
        backSupportLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 17))
        backSupportLabel.font = UIFont.systemFontOfSize(14)
        // backSupportLabel.textColor = UIColor.lightGrayColor()
        backSupportLabel.text = "后援数值: "
        backSupportLabel.textColor = UIColor.darkGrayColor()
        backSupportTF = UITextField.init(frame: CGRectMake(CGSSGlobal.width - 150, originY - 5, 140, 27))
        backSupportTF.autocorrectionType = .No
        backSupportTF.autocapitalizationType = .None
        backSupportTF.borderStyle = .RoundedRect
        backSupportTF.textAlignment = .Right
        backSupportTF.addTarget(self, action: #selector(backValueChanged), forControlEvents: .EditingDidEnd)
        backSupportTF.addTarget(self, action: #selector(backValueChanged), forControlEvents: .EditingDidEndOnExit)
        backSupportTF.keyboardType = .NumbersAndPunctuation
        backSupportTF.returnKeyType = .Done
        backSupportTF.font = UIFont.systemFontOfSize(14)
        
        originY += 17 + topSpace
        
        presentValueGrid = CGSSGridLabel.init(frame: CGRectMake(leftSpace, originY, width, 70), rows: 5, columns: 5)
        
        originY += 70 + topSpace
        drawSectionLine(originY)
        originY += topSpace
        
        skillListDescLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 22))
        skillListDescLabel.text = "特技列表: "
        skillListDescLabel.font = UIFont.systemFontOfSize(14)
        skillListDescLabel.textColor = UIColor.blackColor()
        
        skillShowOrHideButton = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 40, originY - 4, 30, 30))
        // 让图片总是可以被染色影响
        let image = UIImage.init(named: "764-arrow-down-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate)
        skillShowOrHideButton.setImage(image, forState: .Normal)
        skillShowOrHideButton.tintColor = UIColor.lightGrayColor()
        skillShowOrHideButton.addTarget(self, action: #selector(skillShowOrHide), forControlEvents: .TouchUpInside)
        originY += 22 + topSpace
        
        skillListGrid = CGSSGridLabel.init(frame: CGRectMake(leftSpace, originY, width, 225), rows: 5, columns: 1, textAligment: .Left)
        
        bottomView = UIView.init(frame: CGRectMake(0, originY, CGSSGlobal.width, 0))
        bottomView.backgroundColor = UIColor.whiteColor()
        
        originY = 0
        let view = UIView.init(frame: CGRectMake(0, originY, CGSSGlobal.width, 1 / UIScreen.mainScreen().scale))
        view.layer.borderWidth = 1 / UIScreen.mainScreen().scale
        view.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.25).CGColor
        bottomView.addSubview(view)
        originY = topSpace
        
        let descLabel3 = UILabel.init(frame: CGRectMake(leftSpace, originY, width - 2 * leftSpace, 17))
        descLabel3.text = "得分计算: "
        descLabel3.font = UIFont.systemFontOfSize(14)
        descLabel3.textAlignment = .Left
        
        originY += topSpace + 17
        
        selectSongLabel = UILabel.init(frame: CGRectMake(40, originY + 9, CGSSGlobal.width - 80, 30))
        selectSongLabel.textColor = UIColor.lightGrayColor()
        selectSongLabel.text = "请选择歌曲"
        selectSongLabel.textAlignment = .Center
        selectSongLabel.userInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectSong))
        selectSongLabel.addGestureRecognizer(tap)
        selectSongLabel.font = UIFont.systemFontOfSize(18)
        selectSongButton = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 40, originY + 7, 30, 30))
        selectSongButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        selectSongButton.tintColor = UIColor.lightGrayColor()
        selectSongButton.addTarget(self, action: #selector(selectSong), forControlEvents: .TouchUpInside)
        // originY += 30 + topSpace
        
        songJacket = UIImageView.init(frame: CGRectMake(leftSpace, originY, 48, 48))
        
        songNameLabel = UILabel.init(frame: CGRectMake(48 + 2 * leftSpace, originY, width - 48 - 40, 21))
        songNameLabel.adjustsFontSizeToFitWidth = true
        originY += 21 + topSpace
        
        songDiffLabel = UILabel.init(frame: CGRectMake(48 + 2 * leftSpace, originY, width - 48 - 40, 18))
        songDiffLabel.textColor = UIColor.darkGrayColor()
        songDiffLabel.textAlignment = .Left
        songDiffLabel.font = UIFont.systemFontOfSize(12)
        songDiffLabel.adjustsFontSizeToFitWidth = true
        
//        songLengthLabel = UILabel.init(frame: CGRectMake(CGSSGlobal.width / 2 + leftSpace, originY, width / 2, 18))
//        songLengthLabel.textColor = UIColor.darkGrayColor()
//        songLengthLabel.textAlignment = .Left
//        songLengthLabel.font = UIFont.systemFontOfSize(12)
        originY += 18 + topSpace
        
        liveTypeDescLable = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 21))
        liveTypeDescLable.text = "歌曲模式: "
        liveTypeDescLable.font = UIFont.systemFontOfSize(14)
        liveTypeDescLable.textColor = UIColor.darkGrayColor()
        
        liveTypeButton = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 150, originY, 140, 21))
        liveTypeButton.setTitle("< 常规模式 >", forState: .Normal)
        liveTypeButton.contentHorizontalAlignment = .Right
        liveTypeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        liveTypeButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        liveTypeButton.addTarget(self, action: #selector(liveTypeButtonClick), forControlEvents: .TouchUpInside)
        
        originY += 21 + topSpace
        
        grooveTypeDescLable = UILabel.init(frame: CGRectMake(leftSpace, originY, 100, 0))
        grooveTypeDescLable.text = "Groove类别: "
        grooveTypeDescLable.font = UIFont.systemFontOfSize(14)
        grooveTypeDescLable.textColor = UIColor.darkGrayColor()
        
        grooveTypeButton = UIButton.init(frame: CGRectMake(CGSSGlobal.width - 150, originY, 140, 0))
        grooveTypeButton.setTitle("", forState: .Normal)
        grooveTypeButton.contentHorizontalAlignment = .Right
        grooveTypeButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        grooveTypeButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        grooveTypeButton.addTarget(self, action: #selector(grooveTypeButtonClick), forControlEvents: .TouchUpInside)
        
        originY += topSpace
        
        startCalcButton = UIButton.init(frame: CGRectMake(leftSpace, originY, width, 25))
        startCalcButton.setTitle("开始计算", forState: .Normal)
        startCalcButton.backgroundColor = CGSSGlobal.danceColor
        startCalcButton.titleLabel?.font = UIFont.systemFontOfSize(18)
        startCalcButton.addTarget(self, action: #selector(startCalc), forControlEvents: .TouchUpInside)
        
        originY += 25 + topSpace
        scoreGrid = CGSSGridLabel.init(frame: CGRectMake(leftSpace, originY, width, 28), rows: 2, columns: 3)
        scoreGrid.hidden = true
        
        originY += 28 + topSpace
        
        scoreDescLabel = UILabel.init(frame: CGRectMake(leftSpace, originY, width, 80))
        scoreDescLabel.font = UIFont.systemFontOfSize(14)
        scoreDescLabel.textColor = UIColor.darkGrayColor()
        scoreDescLabel.numberOfLines = 0
        scoreDescLabel.text = "* 极限和平均分数中所有点为Perfect评价\n* 极限分数中所有技能100%触发\n* 平均分数采用100次真实模拟后求平均值的方法，每次计算会略有不同\n* 平均分数没有计算技能触发率提升的队长技能带来的影响"
        scoreDescLabel.sizeToFit()
        scoreDescLabel.hidden = true
        originY += topSpace + scoreDescLabel.fheight + topSpace
        
        bottomView.frame.size.height = originY
        
        bottomView.addSubview(descLabel3)
        bottomView.addSubview(selectSongLabel)
        bottomView.addSubview(selectSongButton)
        bottomView.addSubview(songNameLabel)
        bottomView.addSubview(songDiffLabel)
        // bottomView.addSubview(songLengthLabel)
        bottomView.addSubview(songJacket)
        bottomView.addSubview(liveTypeDescLable)
        bottomView.addSubview(liveTypeButton)
        bottomView.addSubview(grooveTypeButton)
        bottomView.addSubview(grooveTypeDescLable)
        bottomView.addSubview(startCalcButton)
        bottomView.addSubview(scoreGrid)
        bottomView.addSubview(scoreDescLabel)
        
        addSubview(selfLeaderLabel)
        addSubview(editTeamButton)
        addSubview(friendLeaderLabel)
        addSubview(descLabel1)
        addSubview(descLabel2)
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
        startCalcButton.setTitle("计算中...", forState: .Normal)
        startCalcButton.userInteractionEnabled = false
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
        frame.size = CGSizeMake(CGSSGlobal.width, bottomView.frame.size.height + bottomView.frame.origin.y + topSpace * 2)
    }
    
    func cardIconClick(icon: CGSSCardIconView) {
        delegate?.cardIconClick(icon.cardId!)
    }
    
    func initWith(team: CGSSTeam) {
        
        for i in 0...5 {
            if let card = team[i]?.cardRef {
                icons[i].setWithCardId(card.id, target: self, action: #selector(cardIconClick))
            }
        }
        if let selfLeaderRef = team.leader.cardRef {
            selfLeaderLabel.text = "队长技能: \(selfLeaderRef.leaderSkill?.name ?? "无")\n\(selfLeaderRef.leaderSkill?.explainEn ?? "")"
        }
        if let friendLeaderRef = team.friendLeader.cardRef {
            friendLeaderLabel.text = "好友技能: \(friendLeaderRef.leaderSkill?.name ?? "无")\n\(friendLeaderRef.leaderSkill?.explainEn ?? "")"
        }
        
        var upValueStrings = [[String]]()
        
        let contents = team.getUpContent()
        upValueStrings.append(["  ", "Vocal", "Dance", "Visual", "技能触发", "HP"])
        
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
        let colorArray = [UIColor.blackColor(), CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor, UIColor.darkGrayColor(), CGSSGlobal.lifeColor]
        upValueColors.appendContentsOf(Array.init(count: 4, repeatedValue: colorArray))
        upValueColors[1][0] = CGSSGlobal.cuteColor
        upValueColors[2][0] = CGSSGlobal.coolColor
        upValueColors[3][0] = CGSSGlobal.passionColor
        
        leaderSkillGrid.setGridContent(upValueStrings)
        leaderSkillGrid.setGridColor(upValueColors)
        
        for i in 0..<6 {
            leaderSkillGrid[0, i].font = CGSSGlobal.alphabetFont
        }
        for i in 0..<4 {
            leaderSkillGrid[i, 0].font = CGSSGlobal.alphabetFont
        }
        
        updatePresentValueGrid(team)
        backSupportTF.text = String(team.backSupportValue!)
        
        var skillListStrings = [[String]]()
        let skillListColor = [[UIColor]].init(count: 5, repeatedValue: [UIColor.darkGrayColor()])
        for i in 0...4 {
            if let skill = team[i]?.cardRef?.skill {
                skillListStrings.append([skill.skillName! + ": Lv.\(team[i]!.skillLevel!)\n" + skill.getExplainByLevel(team[i]!.skillLevel!)])
            } else {
                skillListStrings.append([""])
            }
        }
        
        skillListGrid.setGridContent(skillListStrings)
        skillListGrid.setGridColor(skillListColor)
        
        // skillProcGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, scoreGrid.frame.size.height + scoreGrid.frame.origin.y + topSpace, CGSSGlobal.width - 2 * leftSpace, CGFloat(skillKind) * 14 + 1), rows: skillKind, columns: 3)
        // bottomView.frame.origin.y = skillListGrid.frame.size.height + skillListGrid.frame.origin.y
        frame.size = CGSizeMake(CGSSGlobal.width, bottomView.frame.size.height + bottomView.frame.origin.y + 2 * topSpace)
    }
    
    func updatePresentValueGrid(team: CGSSTeam) {
        var presentValueString = [[String]]()
        var presentColor = [[UIColor]]()
        
        presentValueString.append([" ", "Total", "Vocal", "Dance", "Visual"])
        var presentSub1 = ["彩色曲"]
        presentSub1.appendContentsOf(team.getPresentValue(.Office).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub2 = ["Cu曲"]
        presentSub2.appendContentsOf(team.getPresentValue(.Cute).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub3 = ["Co曲"]
        presentSub3.appendContentsOf(team.getPresentValue(.Cool).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub4 = ["Pa曲"]
        presentSub4.appendContentsOf(team.getPresentValue(.Passion).toStringArrayWithBackValue(team.backSupportValue))
        
        presentValueString.append(presentSub1)
        presentValueString.append(presentSub2)
        presentValueString.append(presentSub3)
        presentValueString.append(presentSub4)
        
        let colorArray2 = [UIColor.darkGrayColor(), CGSSGlobal.allTypeColor, CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor]
        presentColor.appendContentsOf(Array.init(count: 5, repeatedValue: colorArray2))
        presentColor[2][0] = CGSSGlobal.cuteColor
        presentColor[3][0] = CGSSGlobal.coolColor
        presentColor[4][0] = CGSSGlobal.passionColor
        
        presentValueGrid.setGridContent(presentValueString)
        presentValueGrid.setGridColor(presentColor)
        
        for i in 0..<5 {
            presentValueGrid[0, i].font = CGSSGlobal.alphabetFont
        }
        for i in 0..<5 {
            presentValueGrid[i, 0].font = CGSSGlobal.alphabetFont
        }
        
    }
    
    func showGrooveSelectButton() {
        grooveTypeButton.fheight = 21
        grooveTypeDescLable.fheight = 21
        updateGrooveSelectButton()
        
    }
    func hideGrooveSelectButton() {
        grooveTypeButton.fheight = 0
        grooveTypeDescLable.fheight = 0
        updateGrooveSelectButton()
    }
    
    func updateGrooveSelectButton() {
        if grooveTypeButton.fheight == 0 {
            startCalcButton.fy = grooveTypeDescLable.fy + grooveTypeDescLable.fheight
        } else {
            startCalcButton.fy = grooveTypeDescLable.fy + grooveTypeDescLable.fheight + topSpace
        }
        scoreGrid.fy = startCalcButton.fy + startCalcButton.fheight + topSpace
        scoreDescLabel.fy = scoreGrid.fy + scoreGrid.fheight + topSpace
        bottomView.fheight = topSpace + scoreDescLabel.fheight + scoreDescLabel.fy + topSpace
        frame.size = CGSizeMake(CGSSGlobal.width, bottomView.fheight + bottomView.fy + topSpace * 2)
    }
    
    func resetCalcButton() {
        startCalcButton.setTitle("开始计算", forState: .Normal)
        startCalcButton.userInteractionEnabled = true
    }
    
    func updateScoreGridMaxScore(score: Int) {
        if scoreGrid.hidden {
            setupScoreGrid()
        }
        scoreGrid[1, 1].text = String(score)
    }
    func updateScoreGridAvgScore(score: Int) {
        if scoreGrid.hidden {
            setupScoreGrid()
        }
        scoreGrid[1, 2].text = String(score)
        resetCalcButton()
    }
    
    func updateSimulatorPresentValue(value: Int) {
        if scoreGrid.hidden {
            setupScoreGrid()
        }
        scoreGrid[1, 0].text = String(value)
    }
    
    func setupScoreGrid() {
        scoreGrid.hidden = false
        scoreDescLabel.hidden = false
        var scoreString = [[String]]()
        scoreString.append(["表现值", "极限分数", "平均分数(模拟)"])
        scoreString.append(["", "", ""])
        scoreGrid.setGridContent(scoreString)
    }
    func backValueChanged() {
        let value = Int(backSupportTF.text!) ?? CGSSGlobal.presetBackValue
        backSupportTF.text = String(value)
        delegate?.backValueChanged(value)
    }
    var currentLiveType: CGSSLiveType = .Normal {
        didSet {
            self.liveTypeButton.setTitle("< \(currentLiveType.rawValue) >", forState: .Normal)
            self.liveTypeButton.setTitleColor(currentLiveType.typeColor(), forState: .Normal)
        }
    }
    var currentGrooveType: CGSSGrooveType? {
        didSet {
            if let type = currentGrooveType {
                self.grooveTypeButton.setTitle("< \(type.rawValue) >", forState: .Normal)
                self.grooveTypeButton.setTitleColor(type.typeColor(), forState: .Normal)
            } else {
                self.grooveTypeButton.setTitle("", forState: .Normal)
            }
        }
    }
    func liveTypeButtonClick() {
        delegate?.liveTypeButtonClick()
    }
    func grooveTypeButtonClick() {
        delegate?.grooveTypeButtonClick()
    }
    func selectSong() {
        delegate?.selectSong()
    }
    
    func updateSongInfo(live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        // selectSongLabel.hidden = true
        selectSongLabel.text = ""
        let song = live.musicRef!
        songDiffLabel.text = "\(live.getStarsForDiff(diff))☆ \(CGSSGlobal.diffStringFromInt(diff)) bpm: \(song.bpm!) notes: \(beatmaps[diff-1].numberOfNotes) 时长: \(Int(beatmaps[diff - 1].totalSeconds))秒"
        
        // songDiffLabel.text = CGSSGlobal.diffStringFromInt(diff)
        songNameLabel.text = live.musicRef?.title
        songNameLabel.textColor = live.getLiveColor()
        // songLengthLabel.text = String(Int(beatmaps[diff - 1].totalSeconds)) + "秒"
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
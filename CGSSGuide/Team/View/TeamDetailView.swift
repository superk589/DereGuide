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
    func cardIconClick(_ id: Int)
    func backValueChanged(_ value: Int)
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
        selfLeaderLabel = UILabel.init(frame: CGRect(x: leftSpace, y: topSpace, width: width, height: 55))
        selfLeaderLabel.numberOfLines = 3
        selfLeaderLabel.font = UIFont.systemFont(ofSize: 14)
        selfLeaderLabel.textColor = UIColor.darkGray
        originY += 55 + topSpace
        
        let btnW = (width - 30 - 6 * leftSpace) / 6
        icons = [CGSSCardIconView]()
        for i in 0...5 {
            let icon = CGSSCardIconView.init(frame: CGRect(x: leftSpace + (btnW + leftSpace) * CGFloat(i), y: originY, width: btnW, height: btnW))
            addSubview(icon)
            icons.append(icon)
        }
        
        editTeamButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 40, y: originY, width: 30, height: btnW))
        editTeamButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        editTeamButton.tintColor = UIColor.lightGray
        editTeamButton.addTarget(self, action: #selector(editTeam), for: .touchUpInside)
        originY += btnW + topSpace
        
        friendLeaderLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 55))
        friendLeaderLabel.numberOfLines = 3
        friendLeaderLabel.font = UIFont.systemFont(ofSize: 14)
        friendLeaderLabel.textColor = UIColor.darkGray
        friendLeaderLabel.textAlignment = .right
        originY += 55 + topSpace
        
        let descLabel1 = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width - 2 * leftSpace, height: 17))
        descLabel1.text = "队长加成: "
        descLabel1.font = UIFont.systemFont(ofSize: 14)
        descLabel1.textAlignment = .left
        
        originY += 17 + topSpace
        
        leaderSkillGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 56), rows: 4, columns: 6)
        
        originY += 56 + topSpace
        drawSectionLine(originY)
        originY += topSpace
        
        let descLabel2 = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width - 2 * leftSpace, height: 17))
        descLabel2.text = "表现值: "
        descLabel2.font = UIFont.systemFont(ofSize: 14)
        descLabel2.textAlignment = .left
        
        originY += 17 + topSpace
        
        backSupportLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: 100, height: 17))
        backSupportLabel.font = UIFont.systemFont(ofSize: 14)
        // backSupportLabel.textColor = UIColor.lightGrayColor()
        backSupportLabel.text = "后援数值: "
        backSupportLabel.textColor = UIColor.darkGray
        backSupportTF = UITextField.init(frame: CGRect(x: CGSSGlobal.width - 150, y: originY - 5, width: 140, height: 27))
        backSupportTF.autocorrectionType = .no
        backSupportTF.autocapitalizationType = .none
        backSupportTF.borderStyle = .roundedRect
        backSupportTF.textAlignment = .right
        backSupportTF.addTarget(self, action: #selector(backValueChanged), for: .editingDidEnd)
        backSupportTF.addTarget(self, action: #selector(backValueChanged), for: .editingDidEndOnExit)
        backSupportTF.keyboardType = .numbersAndPunctuation
        backSupportTF.returnKeyType = .done
        backSupportTF.font = UIFont.systemFont(ofSize: 14)
        
        originY += 17 + topSpace
        
        presentValueGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 70), rows: 5, columns: 5)
        
        originY += 70 + topSpace
        drawSectionLine(originY)
        originY += topSpace
        
        skillListDescLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: 100, height: 22))
        skillListDescLabel.text = "特技列表: "
        skillListDescLabel.font = UIFont.systemFont(ofSize: 14)
        skillListDescLabel.textColor = UIColor.black
        
        skillShowOrHideButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 40, y: originY - 4, width: 30, height: 30))
        // 让图片总是可以被染色影响
        let image = UIImage.init(named: "764-arrow-down-toolbar-selected")!.withRenderingMode(.alwaysTemplate)
        skillShowOrHideButton.setImage(image, for: UIControlState())
        skillShowOrHideButton.tintColor = UIColor.lightGray
        skillShowOrHideButton.addTarget(self, action: #selector(skillShowOrHide), for: .touchUpInside)
        originY += 22 + topSpace
        
        skillListGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 225), rows: 5, columns: 1, textAligment: .left)
        
        bottomView = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 0))
        bottomView.backgroundColor = UIColor.white
        
        originY = 0
        let view = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 1 / UIScreen.main.scale))
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        bottomView.addSubview(view)
        originY = topSpace
        
        let descLabel3 = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width - 2 * leftSpace, height: 17))
        descLabel3.text = "得分计算: "
        descLabel3.font = UIFont.systemFont(ofSize: 14)
        descLabel3.textAlignment = .left
        
        originY += topSpace + 17
        
        selectSongLabel = UILabel.init(frame: CGRect(x: 40, y: originY + 9, width: CGSSGlobal.width - 80, height: 30))
        selectSongLabel.textColor = UIColor.lightGray
        selectSongLabel.text = "请选择歌曲"
        selectSongLabel.textAlignment = .center
        selectSongLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectSong))
        selectSongLabel.addGestureRecognizer(tap)
        selectSongLabel.font = UIFont.systemFont(ofSize: 18)
        selectSongButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 40, y: originY + 7, width: 30, height: 30))
        selectSongButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        selectSongButton.tintColor = UIColor.lightGray
        selectSongButton.addTarget(self, action: #selector(selectSong), for: .touchUpInside)
        // originY += 30 + topSpace
        
        songJacket = UIImageView.init(frame: CGRect(x: leftSpace, y: originY, width: 48, height: 48))
        
        songNameLabel = UILabel.init(frame: CGRect(x: 48 + 2 * leftSpace, y: originY, width: width - 48 - 40, height: 21))
        songNameLabel.adjustsFontSizeToFitWidth = true
        originY += 21 + topSpace
        
        songDiffLabel = UILabel.init(frame: CGRect(x: 48 + 2 * leftSpace, y: originY, width: width - 48 - 40, height: 18))
        songDiffLabel.textColor = UIColor.darkGray
        songDiffLabel.textAlignment = .left
        songDiffLabel.font = UIFont.systemFont(ofSize: 12)
        songDiffLabel.adjustsFontSizeToFitWidth = true
        
//        songLengthLabel = UILabel.init(frame: CGRectMake(CGSSGlobal.width / 2 + leftSpace, originY, width / 2, 18))
//        songLengthLabel.textColor = UIColor.darkGrayColor()
//        songLengthLabel.textAlignment = .Left
//        songLengthLabel.font = UIFont.systemFontOfSize(12)
        originY += 18 + topSpace
        
        liveTypeDescLable = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: 100, height: 21))
        liveTypeDescLable.text = "歌曲模式: "
        liveTypeDescLable.font = UIFont.systemFont(ofSize: 14)
        liveTypeDescLable.textColor = UIColor.darkGray
        
        liveTypeButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 150, y: originY, width: 140, height: 21))
        liveTypeButton.setTitle("< 常规模式 >", for: UIControlState())
        liveTypeButton.contentHorizontalAlignment = .right
        liveTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        liveTypeButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        liveTypeButton.addTarget(self, action: #selector(liveTypeButtonClick), for: .touchUpInside)
        
        originY += 21 + topSpace
        
        grooveTypeDescLable = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: 100, height: 0))
        grooveTypeDescLable.text = "Groove类别: "
        grooveTypeDescLable.font = UIFont.systemFont(ofSize: 14)
        grooveTypeDescLable.textColor = UIColor.darkGray
        
        grooveTypeButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 150, y: originY, width: 140, height: 0))
        grooveTypeButton.setTitle("", for: UIControlState())
        grooveTypeButton.contentHorizontalAlignment = .right
        grooveTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        grooveTypeButton.setTitleColor(UIColor.darkGray, for: UIControlState())
        grooveTypeButton.addTarget(self, action: #selector(grooveTypeButtonClick), for: .touchUpInside)
        
//        originY += topSpace
        
        startCalcButton = UIButton.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 25))
        startCalcButton.setTitle("开始计算", for: UIControlState())
        startCalcButton.backgroundColor = CGSSGlobal.danceColor
        startCalcButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        startCalcButton.addTarget(self, action: #selector(startCalc), for: .touchUpInside)
        
        originY += 25 + topSpace
        scoreGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 28), rows: 2, columns: 3)
        scoreGrid.isHidden = true
        
        originY += 28 + topSpace
        
        scoreDescLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 80))
        scoreDescLabel.font = UIFont.systemFont(ofSize: 14)
        scoreDescLabel.textColor = UIColor.darkGray
        scoreDescLabel.numberOfLines = 0
        scoreDescLabel.text = "* 极限和平均分数中所有点为Perfect评价\n* 极限分数中所有技能100%触发\n* 平均分数采用100次真实模拟后求平均值的方法，每次计算会略有不同\n* 平均分数没有计算技能触发率提升的队长技能带来的影响"
        scoreDescLabel.sizeToFit()
        scoreDescLabel.isHidden = true
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
        startCalcButton.setTitle("计算中...", for: UIControlState())
        startCalcButton.isUserInteractionEnabled = false
        delegate?.startCalc()
    }
    var skillListIsShow = false
    func skillShowOrHide() {
        skillListIsShow = !skillListIsShow
        if skillListIsShow {
            let image = UIImage.init(named: "763-arrow-up-toolbar-selected")!.withRenderingMode(.alwaysTemplate)
            skillShowOrHideButton.setImage(image, for: UIControlState())
        } else {
            let image = UIImage.init(named: "764-arrow-down-toolbar-selected")!.withRenderingMode(.alwaysTemplate)
            skillShowOrHideButton.setImage(image, for: UIControlState())
            
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.updateBottomView()
        }) 
        delegate?.skillShowOrHide()
    }
    
    func updateBottomView() {
        if skillListIsShow {
            bottomView.frame.origin.y = skillListGrid.frame.size.height + skillListGrid.frame.origin.y + topSpace
        } else {
            bottomView.frame.origin.y = skillListGrid.frame.origin.y
        }
        frame.size = CGSize(width: CGSSGlobal.width, height: bottomView.frame.size.height + bottomView.frame.origin.y + topSpace * 2)
    }
    
    func cardIconClick(_ icon: CGSSCardIconView) {
        delegate?.cardIconClick(icon.cardId!)
    }
    
    func initWith(_ team: CGSSTeam) {
        
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
        upCuteString.append(contents[.cute]?[.vocal] != nil ? "+\(String(contents[.cute]![.vocal]!))%" : "")
        upCuteString.append(contents[.cute]?[.dance] != nil ? "+\(String(contents[.cute]![.dance]!))%" : "")
        upCuteString.append(contents[.cute]?[.visual] != nil ? "+\(String(contents[.cute]![.visual]!))%" : "")
        upCuteString.append(contents[.cute]?[.proc] != nil ? "+\(String(contents[.cute]![.proc]!))%" : "")
        upCuteString.append(contents[.cute]?[.life] != nil ? "+\(String(contents[.cute]![.life]!))%" : "")
        
        var upCoolString = [String]()
        upCoolString.append("Co")
        upCoolString.append(contents[.cool]?[.vocal] != nil ? "+\(String(contents[.cool]![.vocal]!))%" : "")
        upCoolString.append(contents[.cool]?[.dance] != nil ? "+\(String(contents[.cool]![.dance]!))%" : "")
        upCoolString.append(contents[.cool]?[.visual] != nil ? "+\(String(contents[.cool]![.visual]!))%" : "")
        upCoolString.append(contents[.cool]?[.proc] != nil ? "+\(String(contents[.cool]![.proc]!))%" : "")
        upCoolString.append(contents[.cool]?[.life] != nil ? "+\(String(contents[.cool]![.life]!))%" : "")
        
        var upPassionString = [String]()
        upPassionString.append("Pa")
        upPassionString.append(contents[.passion]?[.vocal] != nil ? "+\(String(contents[.passion]![.vocal]!))%" : "")
        upPassionString.append(contents[.passion]?[.dance] != nil ? "+\(String(contents[.passion]![.dance]!))%" : "")
        upPassionString.append(contents[.passion]?[.visual] != nil ? "+\(String(contents[.passion]![.visual]!))%" : "")
        upPassionString.append(contents[.passion]?[.proc] != nil ? "+\(String(contents[.passion]![.proc]!))%" : "")
        upPassionString.append(contents[.passion]?[.life] != nil ? "+\(String(contents[.passion]![.life]!))%" : "")
        
        upValueStrings.append(upCuteString)
        upValueStrings.append(upCoolString)
        upValueStrings.append(upPassionString)
        
        var upValueColors = [[UIColor]]()
        let colorArray = [UIColor.black, CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor, UIColor.darkGray, CGSSGlobal.lifeColor]
        upValueColors.append(contentsOf: Array.init(repeating: colorArray, count: 4))
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
        let skillListColor = [[UIColor]].init(repeating: [UIColor.darkGray], count: 5)
        for i in 0...4 {
            if let skill = team[i]?.cardRef?.skill {
                let str = "\(skill.skillName!): Lv.\(team[i]!.skillLevel!)\n\(skill.getExplainByLevel(team[i]!.skillLevel!))"
                let arr = [str]
                skillListStrings.append(arr)
            } else {
                skillListStrings.append([""])
            }
        }
        
        skillListGrid.setGridContent(skillListStrings)
        skillListGrid.setGridColor(skillListColor)
        
        // skillProcGrid = CGSSGridView.init(frame: CGRectMake(leftSpace, scoreGrid.frame.size.height + scoreGrid.frame.origin.y + topSpace, CGSSGlobal.width - 2 * leftSpace, CGFloat(skillKind) * 14 + 1), rows: skillKind, columns: 3)
        // bottomView.frame.origin.y = skillListGrid.frame.size.height + skillListGrid.frame.origin.y
        frame.size = CGSize(width: CGSSGlobal.width, height: bottomView.frame.size.height + bottomView.frame.origin.y + 2 * topSpace)
    }
    
    func updatePresentValueGrid(_ team: CGSSTeam) {
        var presentValueString = [[String]]()
        var presentColor = [[UIColor]]()
        
        presentValueString.append([" ", "Total", "Vocal", "Dance", "Visual"])
        var presentSub1 = ["彩色曲"]
        presentSub1.append(contentsOf: team.getPresentValue(.office).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub2 = ["Cu曲"]
        presentSub2.append(contentsOf: team.getPresentValue(.cute).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub3 = ["Co曲"]
        presentSub3.append(contentsOf: team.getPresentValue(.cool).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub4 = ["Pa曲"]
        presentSub4.append(contentsOf: team.getPresentValue(.passion).toStringArrayWithBackValue(team.backSupportValue))
        
        presentValueString.append(presentSub1)
        presentValueString.append(presentSub2)
        presentValueString.append(presentSub3)
        presentValueString.append(presentSub4)
        
        let colorArray2 = [UIColor.darkGray, CGSSGlobal.allTypeColor, CGSSGlobal.vocalColor, CGSSGlobal.danceColor, CGSSGlobal.visualColor]
        presentColor.append(contentsOf: Array.init(repeating: colorArray2, count: 5))
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
        frame.size = CGSize(width: CGSSGlobal.width, height: bottomView.fheight + bottomView.fy + topSpace * 2)
    }
    
    func resetCalcButton() {
        startCalcButton.setTitle("开始计算", for: UIControlState())
        startCalcButton.isUserInteractionEnabled = true
    }
    
    func updateScoreGridMaxScore(_ score: Int) {
        if scoreGrid.isHidden {
            setupScoreGrid()
        }
        scoreGrid[1, 1].text = String(score)
    }
    func updateScoreGridAvgScore(_ score: Int) {
        if scoreGrid.isHidden {
            setupScoreGrid()
        }
        scoreGrid[1, 2].text = String(score)
        resetCalcButton()
    }
    
    func updateSimulatorPresentValue(_ value: Int) {
        if scoreGrid.isHidden {
            setupScoreGrid()
        }
        scoreGrid[1, 0].text = String(value)
    }
    
    func setupScoreGrid() {
        scoreGrid.isHidden = false
        scoreDescLabel.isHidden = false
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
            self.liveTypeButton.setTitle("< \(currentLiveType.rawValue) >", for: UIControlState())
            self.liveTypeButton.setTitleColor(currentLiveType.typeColor(), for: UIControlState())
        }
    }
    var currentGrooveType: CGSSGrooveType? {
        didSet {
            if let type = currentGrooveType {
                self.grooveTypeButton.setTitle("< \(type.rawValue) >", for: UIControlState())
                self.grooveTypeButton.setTitleColor(type.typeColor(), for: UIControlState())
            } else {
                self.grooveTypeButton.setTitle("", for: UIControlState())
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
    
    func updateSongInfo(_ live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        // selectSongLabel.hidden = true
        selectSongLabel.text = ""
        let song = live.musicRef!
        songDiffLabel.text = "\(live.getStarsForDiff(diff))☆ \(CGSSGlobal.diffStringFromInt(i: diff)) bpm: \(song.bpm!) notes: \(beatmaps[diff-1].numberOfNotes) 时长: \(Int(beatmaps[diff - 1].totalSeconds))秒"
        
        // songDiffLabel.text = CGSSGlobal.diffStringFromInt(diff)
        songNameLabel.text = live.musicRef?.title
        songNameLabel.textColor = live.getLiveColor()
        // songLengthLabel.text = String(Int(beatmaps[diff - 1].totalSeconds)) + "秒"
        songJacket.sd_setImage(with: URL.init(string: live.musicRef!.imageURLString)!)
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}

//
//  TeamDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/6.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit


private class LeaderSkillLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let inset = UIEdgeInsetsMake(0, 10, 0, 10)
        super.drawText(in:UIEdgeInsetsInsetRect(rect, inset))
    }
}
protocol TeamDetailViewDelegate: class {
    func editTeam()
    func skillShowOrHide()
    func startCalc()
    func cardIconClick(_ id: Int)
    func backFieldBegin()
    func backFieldDone(_ value: Int)
    func selectSong()
    func liveTypeButtonClick()
    func grooveTypeButtonClick()
    func usingManualValue(using:Bool)
    func manualFieldBegin()
    func manualFieldDone(_ value: Int)
}

class TeamDetailView: UIView {
    var leftSpace: CGFloat = 10
    var topSpace: CGFloat = 10
    weak var delegate: TeamDetailViewDelegate?
    private var selfLeaderLabel: LeaderSkillLabel!
    var icons: [CGSSCardIconView]!
    var editTeamButton: UIButton!
    private var friendLeaderLabel: LeaderSkillLabel!
    
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
    var manualValueTF: UITextField!
    var manualValueBox: CGSSCheckBox!
    
    var liveTypeButton: UIButton!
    var liveTypeDescLable: UILabel!
    var grooveTypeButton: UIButton!
    var grooveTypeDescLable: UILabel!
    var grooveTypeContentView: UIView!
    
    var bottomView: UIView!
    var startCalcButton: UIButton!
    var skillProcGrid: CGSSGridLabel!
    var scoreGrid: CGSSGridLabel!
    var scoreDescLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var originY: CGFloat = topSpace
        let width = CGSSGlobal.width - 2 * leftSpace
        selfLeaderLabel = LeaderSkillLabel.init(frame: CGRect(x: leftSpace, y: topSpace, width: width, height: 55))
        selfLeaderLabel.numberOfLines = 3
        selfLeaderLabel.font = UIFont.systemFont(ofSize: 14)
        selfLeaderLabel.textColor = UIColor.black
        selfLeaderLabel.layer.cornerRadius = 8
        selfLeaderLabel.layer.masksToBounds = true
        originY += 55 + topSpace
        
        let btnW = (width - 30 - 3.5 * leftSpace) / 6
        icons = [CGSSCardIconView]()
        for i in 0...5 {
            let icon = CGSSCardIconView.init(frame: CGRect(x: leftSpace + (btnW + leftSpace / 2) * CGFloat(i), y: originY, width: btnW, height: btnW))
            addSubview(icon)
            icons.append(icon)
        }
        
        editTeamButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 50, y: originY, width: 50, height: btnW))
        editTeamButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        editTeamButton.tintColor = UIColor.lightGray
        editTeamButton.addTarget(self, action: #selector(editTeam), for: .touchUpInside)
        originY += btnW + topSpace
        
        friendLeaderLabel = LeaderSkillLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 55))
        friendLeaderLabel.numberOfLines = 3
        friendLeaderLabel.font = UIFont.systemFont(ofSize: 14)
        friendLeaderLabel.textColor = UIColor.black
        friendLeaderLabel.textAlignment = .right
        friendLeaderLabel.layer.cornerRadius = 8
        friendLeaderLabel.layer.masksToBounds = true
        originY += 55 + topSpace
        
        let descLabel1 = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width - 2 * leftSpace, height: 17))
        descLabel1.text = NSLocalizedString("队长加成", comment: "队伍详情页面") + ": "
        descLabel1.font = UIFont.systemFont(ofSize: 16)
        descLabel1.textAlignment = .left
        
        originY += 17 + topSpace
        
        leaderSkillGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 72), rows: 4, columns: 6)
        
        originY += 72 + topSpace
        drawSectionLine(originY)
        originY += topSpace
        
        let descLabel2 = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width - 2 * leftSpace, height: 17))
        descLabel2.text = NSLocalizedString("表现值", comment: "队伍详情页面") + ": "
        descLabel2.font = UIFont.systemFont(ofSize: 16)
        descLabel2.textAlignment = .left
        
        originY += 17 + topSpace
        
        backSupportLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: 100, height: 17))
        backSupportLabel.font = UIFont.systemFont(ofSize: 16)
        // backSupportLabel.textColor = UIColor.lightGrayColor()
        backSupportLabel.text = NSLocalizedString("后援数值", comment: "队伍详情页面") + ": "
        backSupportLabel.textColor = UIColor.darkGray
        backSupportTF = UITextField.init(frame: CGRect(x: CGSSGlobal.width - 150, y: originY - 5, width: 140, height: 27))
        backSupportTF.autocorrectionType = .no
        backSupportTF.autocapitalizationType = .none
        backSupportTF.borderStyle = .roundedRect
        backSupportTF.textAlignment = .right
        backSupportTF.addTarget(self, action: #selector(backFieldBegin), for: .editingDidBegin)
        backSupportTF.addTarget(self, action: #selector(backFieldDone), for: .editingDidEnd)
        backSupportTF.addTarget(self, action: #selector(backFieldDone), for: .editingDidEndOnExit)
        backSupportTF.keyboardType = .numbersAndPunctuation
        backSupportTF.returnKeyType = .done
        backSupportTF.font = UIFont.systemFont(ofSize: 14)
        
        originY += 17 + topSpace
        
        presentValueGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 90), rows: 5, columns: 5)
        
        originY += 90 + topSpace
        let skillListContentView = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 42))
        skillListContentView.drawSectionLine(0)
        
        skillListDescLabel = UILabel.init(frame: CGRect(x: leftSpace, y: 10, width: 100, height: 22))
        skillListDescLabel.text = NSLocalizedString("特技列表", comment: "队伍详情页面") + ": "
        skillListDescLabel.font = UIFont.systemFont(ofSize: 16)
        skillListDescLabel.textColor = UIColor.black
        
        skillShowOrHideButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 40, y: 6, width: 30, height: 30))
        // 让图片总是可以被染色影响
        let image = UIImage.init(named: "764-arrow-down-toolbar-selected")!.withRenderingMode(.alwaysTemplate)
        skillShowOrHideButton.setImage(image, for: UIControlState())
        skillShowOrHideButton.tintColor = UIColor.lightGray
        skillShowOrHideButton.isUserInteractionEnabled = false
        
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(skillShowOrHide))
        skillListContentView.addGestureRecognizer(tap2)
        skillListContentView.addSubview(skillListDescLabel)
        skillListContentView.addSubview(skillShowOrHideButton)
        
        originY += 42
        
        skillListGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 245), rows: 5, columns: 1, textAligment: .left)
        
        bottomView = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 0))
        bottomView.backgroundColor = UIColor.white
        
        originY = 0
        let view = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 1 / UIScreen.main.scale))
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        bottomView.addSubview(view)
        originY = topSpace
        
        let descLabel3 = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width - 2 * leftSpace, height: 17))
        descLabel3.text = NSLocalizedString("得分计算", comment: "队伍详情页面") + ": "
        descLabel3.font = UIFont.systemFont(ofSize: 16)
        descLabel3.textAlignment = .left
        
        originY += topSpace + 17
        
        let selectSongContentView = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 0))
        
        selectSongLabel = UILabel.init(frame: CGRect(x: 40, y: 7, width: CGSSGlobal.width - 80, height: 30))
        selectSongLabel.textColor = UIColor.lightGray
        selectSongLabel.text = NSLocalizedString("请选择歌曲", comment: "队伍详情页面")
        selectSongLabel.textAlignment = .center
        selectSongLabel.isUserInteractionEnabled = true
        selectSongLabel.font = UIFont.systemFont(ofSize: 18)
        selectSongButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 40, y: 7, width: 30, height: 30))
        selectSongButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        selectSongButton.tintColor = UIColor.lightGray
        selectSongButton.isUserInteractionEnabled = false
        // selectSongButton.addTarget(self, action: #selector(selectSong), for: .touchUpInside)
        // originY += 30 + topSpace
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectSong))
        selectSongContentView.addGestureRecognizer(tap)
        
        songJacket = UIImageView.init(frame: CGRect(x: leftSpace, y: 0, width: 48, height: 48))
        
        songNameLabel = UILabel.init(frame: CGRect(x: 48 + 2 * leftSpace, y: topSpace * 0.25, width: width - 48 - 40, height: 21))
        songNameLabel.adjustsFontSizeToFitWidth = true
        
        songDiffLabel = UILabel.init(frame: CGRect(x: 48 + 2 * leftSpace, y: 21 + topSpace * 0.75, width: width - 48 - 40, height: 18))
        songDiffLabel.textColor = UIColor.darkGray
        songDiffLabel.textAlignment = .left
        songDiffLabel.font = UIFont.systemFont(ofSize: 12)
        songDiffLabel.adjustsFontSizeToFitWidth = true
        
        selectSongContentView.fheight = songDiffLabel.fy + songDiffLabel.fheight
        selectSongContentView.addSubview(selectSongLabel)
        selectSongContentView.addSubview(selectSongButton)
        selectSongContentView.addSubview(songJacket)
        selectSongContentView.addSubview(songNameLabel)
        selectSongContentView.addSubview(songDiffLabel)
        
        originY += selectSongContentView.fheight + topSpace * 1.5
        
        manualValueBox = CGSSCheckBox.init(frame: CGRect.init(x: leftSpace, y: originY, width: 120, height: 21))
        manualValueBox.text = NSLocalizedString("使用固定值", comment: "队伍详情页面") + ": "
        manualValueBox.descLabel.font = UIFont.systemFont(ofSize: 16)
        manualValueBox.tintColor = CGSSGlobal.coolColor
        manualValueBox.descLabel.textColor = UIColor.darkGray
        manualValueBox.isChecked = false
        let tap4 = UITapGestureRecognizer.init(target: self, action: #selector(manualValueCheckBoxClick))
        manualValueBox.addGestureRecognizer(tap4)
        manualValueTF = UITextField.init(frame: CGRect(x: CGSSGlobal.width - 150, y: originY - 3, width: 140, height: 27))
        manualValueTF.autocorrectionType = .no
        manualValueTF.autocapitalizationType = .none
        manualValueTF.borderStyle = .roundedRect
        manualValueTF.textAlignment = .right
        manualValueTF.keyboardType = .numbersAndPunctuation
        manualValueTF.returnKeyType = .done
        manualValueTF.font = UIFont.systemFont(ofSize: 14)
        manualValueTF.isEnabled = false
        manualValueTF.addTarget(self, action: #selector(manualFieldBegin), for: .editingDidBegin)
        manualValueTF.addTarget(self, action: #selector(manualFieldDone), for: .editingDidEndOnExit)
        manualValueTF.addTarget(self, action: #selector(manualFieldDone), for: .editingDidEnd)
        bottomView.addSubview(manualValueBox)
        bottomView.addSubview(manualValueTF)
        
        originY += 21 + topSpace / 2 + 3
        
        let liveTypeContentView = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 31))
        liveTypeDescLable = UILabel.init(frame: CGRect(x: leftSpace, y: 5, width: 100, height: 21))
        liveTypeDescLable.text = NSLocalizedString("歌曲模式", comment: "队伍详情页面") + ": "
        liveTypeDescLable.font = UIFont.systemFont(ofSize: 16)
        liveTypeDescLable.textColor = UIColor.darkGray
        
        liveTypeButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 150, y: 5, width: 140, height: 21))
        liveTypeButton.setTitle("< " + NSLocalizedString("常规模式", comment: "队伍详情页面") + " >", for: .normal)
        liveTypeButton.contentHorizontalAlignment = .right
        liveTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        liveTypeButton.setTitleColor(UIColor.darkGray, for: .normal)
        liveTypeButton.isUserInteractionEnabled = false

        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(liveTypeButtonClick))
        liveTypeContentView.addGestureRecognizer(tap1)
        liveTypeContentView.addSubview(liveTypeDescLable)
        liveTypeContentView.addSubview(liveTypeButton)
        
        originY += 31
        
        grooveTypeContentView = UIView.init(frame: CGRect(x: 0, y: originY, width: CGSSGlobal.width, height: 0))
        
        grooveTypeDescLable = UILabel.init(frame: CGRect(x: leftSpace, y: 5, width: 100, height: 21))
        grooveTypeDescLable.text = NSLocalizedString("Groove类别", comment: "队伍详情页面") + ": "
        grooveTypeDescLable.font = UIFont.systemFont(ofSize: 16)
        grooveTypeDescLable.textColor = UIColor.darkGray
        
        grooveTypeButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 170, y: 5, width: 160, height: 21))
        grooveTypeButton.setTitle("", for: .normal)
        grooveTypeButton.contentHorizontalAlignment = .right
        grooveTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        grooveTypeButton.setTitleColor(UIColor.darkGray, for: .normal)
        grooveTypeButton.isUserInteractionEnabled = false
    
        let tap3 = UITapGestureRecognizer.init(target: self, action: #selector(grooveTypeButtonClick))
        grooveTypeContentView.addGestureRecognizer(tap3)
        grooveTypeContentView.addSubview(grooveTypeDescLable)
        grooveTypeContentView.addSubview(grooveTypeButton)
        grooveTypeContentView.clipsToBounds = true
        
        originY += topSpace / 2 + 3
        
        startCalcButton = UIButton.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 30))
        startCalcButton.setTitle(NSLocalizedString("开始计算", comment: "队伍详情页面"), for: .normal)
        startCalcButton.backgroundColor = CGSSGlobal.danceColor
        startCalcButton.addTarget(self, action: #selector(startCalc), for: .touchUpInside)
        
        originY += 30 + topSpace
        scoreGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 36), rows: 2, columns: 3)
        scoreGrid.isHidden = true
        
        originY += 36 + topSpace
        
        scoreDescLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 80))
        scoreDescLabel.font = UIFont.systemFont(ofSize: 14)
        scoreDescLabel.textColor = UIColor.darkGray
        scoreDescLabel.numberOfLines = 0
        scoreDescLabel.text = NSLocalizedString("* 极限和平均分数中所有点为Perfect评价\n* 极限分数中所有技能100%触发\n* 平均分数采用100次真实模拟后求平均值的方法，每次计算会略有不同\n* 平均分数没有计算技能触发率提升的队长技能带来的影响", comment: "队伍详情页面")
        scoreDescLabel.sizeToFit()
        scoreDescLabel.isHidden = true
        originY += topSpace + scoreDescLabel.fheight + topSpace
        
        bottomView.frame.size.height = originY
        
        bottomView.addSubview(descLabel3)
        bottomView.addSubview(selectSongContentView)
        bottomView.addSubview(liveTypeContentView)
        bottomView.addSubview(grooveTypeContentView)
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
        addSubview(skillListContentView)
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
        startCalcButton.setTitle(NSLocalizedString("计算中...", comment: "队伍详情页面"), for: .normal)
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
            selfLeaderLabel.text = "\(NSLocalizedString("队长技能", comment: "队伍详情页面")): \(selfLeaderRef.leaderSkill?.name ?? NSLocalizedString("无", comment: ""))\n\(selfLeaderRef.leaderSkill?.explainEn ?? "")"
            selfLeaderLabel.backgroundColor = selfLeaderRef.attColor.withAlphaComponent(0.5)
        } else {
            selfLeaderLabel.backgroundColor = CGSSGlobal.allTypeColor.withAlphaComponent(0.5)
        }
        if let friendLeaderRef = team.friendLeader.cardRef {
            friendLeaderLabel.text = "\(NSLocalizedString("好友技能", comment: "队伍详情页面")): \(friendLeaderRef.leaderSkill?.name ?? "无")\n\(friendLeaderRef.leaderSkill?.explainEn ?? "")"
            friendLeaderLabel.backgroundColor = friendLeaderRef.attColor.withAlphaComponent(0.5)
        } else {
            friendLeaderLabel.backgroundColor = CGSSGlobal.allTypeColor.withAlphaComponent(0.5)
        }
        
        var upValueStrings = [[String]]()
        
        let contents = team.getUpContent()
        upValueStrings.append(["  ", "Vocal", "Dance", "Visual", NSLocalizedString("技能触发", comment: "队伍详情页面"), "HP"])
        
        var upCuteString = [String]()
        upCuteString.append("Cu")
        if let cute = contents[.cute] {
            if let vocal = cute[.vocal] {
                upCuteString.append("+\(vocal)%")
            } else {
                upCuteString.append("")
            }
            if let dance = cute[.dance] {
                upCuteString.append("+\(dance)%")
            } else {
                upCuteString.append("")
            }
            if let visual = cute[.visual] {
                upCuteString.append("+\(visual)%")
            } else {
                upCuteString.append("")
            }
            if let proc = cute[.proc] {
                upCuteString.append("+\(proc)%")
            } else {
                upCuteString.append("")
            }
            if let life = cute[.life] {
                upCuteString.append("+\(life)%")
            } else {
                upCuteString.append("")
            }
        } else {
            upCuteString.append(contentsOf: [String].init(repeating: "", count: 5))
        }
        
        var upCoolString = [String]()
        upCoolString.append("Co")
        if let cool = contents[.cool] {
            if let vocal = cool[.vocal] {
                upCoolString.append("+\(vocal)%")
            } else {
                upCoolString.append("")
            }
            if let dance = cool[.dance] {
                upCoolString.append("+\(dance)%")
            } else {
                upCoolString.append("")
            }
            if let visual = cool[.visual] {
                upCoolString.append("+\(visual)%")
            } else {
                upCoolString.append("")
            }
            if let proc = cool[.proc] {
                upCoolString.append("+\(proc)%")
            } else {
                upCoolString.append("")
            }
            if let life = cool[.life] {
                upCoolString.append("+\(life)%")
            } else {
                upCoolString.append("")
            }
        } else {
            upCoolString.append(contentsOf: [String].init(repeating: "", count: 5))
        }

        
        var upPassionString = [String]()
        upPassionString.append("Pa")
        if let passion = contents[.passion] {
            if let vocal = passion[.vocal] {
                upPassionString.append("+\(vocal)%")
            } else {
                upPassionString.append("")
            }
            if let dance = passion[.dance] {
                upPassionString.append("+\(dance)%")
            } else {
                upPassionString.append("")
            }
            if let visual = passion[.visual] {
                upPassionString.append("+\(visual)%")
            } else {
                upPassionString.append("")
            }
            if let proc = passion[.proc] {
                upPassionString.append("+\(proc)%")
            } else {
                upPassionString.append("")
            }
            if let life = passion[.life] {
                upPassionString.append("+\(life)%")
            } else {
                upPassionString.append("")
            }
        } else {
            upPassionString.append(contentsOf: [String].init(repeating: "", count: 5))
        }

        
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
        manualValueTF.text = String(team.manualValue!)
        
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
        var presentSub1 = [NSLocalizedString("彩色曲", comment: "队伍详情页面")]
        presentSub1.append(contentsOf: team.getPresentValue(.office).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub2 = [NSLocalizedString("Cu曲", comment: "队伍详情页面")]
        presentSub2.append(contentsOf: team.getPresentValue(.cute).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub3 = [NSLocalizedString("Co曲", comment: "队伍详情页面")]
        presentSub3.append(contentsOf: team.getPresentValue(.cool).toStringArrayWithBackValue(team.backSupportValue))
        var presentSub4 = [NSLocalizedString("Pa曲", comment: "队伍详情页面")]
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
        grooveTypeContentView.fheight = 31
        updateGrooveSelectButton()
        
    }
    func hideGrooveSelectButton() {
        grooveTypeContentView.fheight = 0
        updateGrooveSelectButton()
    }
    
    func updateGrooveSelectButton() {
        startCalcButton.fy = grooveTypeContentView.fy + grooveTypeContentView.fheight + topSpace / 2 + 3
        scoreGrid.fy = startCalcButton.fy + startCalcButton.fheight + topSpace
        scoreDescLabel.fy = scoreGrid.fy + scoreGrid.fheight + topSpace
        bottomView.fheight = topSpace + scoreDescLabel.fheight + scoreDescLabel.fy + topSpace
        frame.size = CGSize(width: CGSSGlobal.width, height: bottomView.fheight + bottomView.fy + topSpace * 2)
    }
    
    func resetCalcButton() {
        startCalcButton.setTitle(NSLocalizedString("开始计算", comment: ""), for: .normal)
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
    
    func clearScoreGrid() {
        scoreGrid[1, 2].text = ""
    }
    
    func setupScoreGrid() {
        scoreGrid.isHidden = false
        scoreDescLabel.isHidden = false
        var scoreString = [[String]]()
        scoreString.append([NSLocalizedString("表现值", comment: "队伍详情页面"), NSLocalizedString("极限分数", comment: "队伍详情页面"), NSLocalizedString("平均分数(模拟)", comment: "队伍详情页面")])
        scoreString.append(["", "", ""])
        scoreGrid.setGridContent(scoreString)
    }
    func backFieldBegin() {
        delegate?.backFieldBegin()
    }
    func backFieldDone() {
        let value = Int(backSupportTF.text!) ?? CGSSGlobal.presetBackValue
        backSupportTF.text = String(value)
        delegate?.backFieldDone(value)
    }
    var currentLiveType: CGSSLiveType = .normal {
        didSet {
            self.liveTypeButton.setTitle("< \(currentLiveType.toString()) >", for: .normal)
            self.liveTypeButton.setTitleColor(currentLiveType.typeColor(), for: .normal)
        }
    }
    var currentGrooveType: CGSSGrooveType? {
        didSet {
            if let type = currentGrooveType {
                self.grooveTypeButton.setTitle("< \(type.rawValue) >", for: .normal)
                self.grooveTypeButton.setTitleColor(type.typeColor(), for: .normal)
            } else {
                self.grooveTypeButton.setTitle("", for: .normal)
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
        songDiffLabel.text = "\(live.getStarsForDiff(diff))☆ \(CGSSGlobal.diffStringFromInt(i: diff)) bpm: \(song.bpm!) notes: \(beatmaps[diff-1].numberOfNotes) \(NSLocalizedString("时长", comment: "队伍详情页面")): \(Int(beatmaps[diff - 1].totalSeconds))\(NSLocalizedString("秒", comment: "队伍详情页面"))"
        
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
    func manualValueCheckBoxClick() {
        manualValueBox.isChecked = !manualValueBox.isChecked
        delegate?.usingManualValue(using: manualValueBox.isChecked)
        if manualValueBox.isChecked {
            manualValueTF.isEnabled = true
        } else {
            manualValueTF.isEnabled = false
        }
    }
    
    func manualFieldBegin() {
        delegate?.manualFieldBegin()
    }
    
    func manualFieldDone() {
        let value = Int(manualValueTF.text!) ?? 0
        manualValueTF.text = String(value)
        delegate?.manualFieldDone(value)
    }
}

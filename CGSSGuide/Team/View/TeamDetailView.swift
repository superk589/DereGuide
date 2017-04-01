//
//  TeamDetailView.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/6.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

//
//private class LeaderSkillLabel: UILabel {
//    override func drawText(in rect: CGRect) {
//        let inset = UIEdgeInsetsMake(0, 10, 0, 10)
//        super.drawText(in:UIEdgeInsetsInsetRect(rect, inset))
//    }
//}
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
    func advanceCalc()
    func viewScoreChart(_ teamDetailView: TeamDetailView)
}

class TeamDetailView: UIView {
    var leftSpace: CGFloat = 10
    var topSpace: CGFloat = 10
    weak var delegate: TeamDetailViewDelegate?
    var icons: [CGSSCardIconView]!
    var editTeamButton: UIButton!
    
    var selfLeaderSkillView: TeamLeaderSkillView!
    var friendLeaderSkillView: TeamLeaderSkillView!

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
    
    var advanceCalculateButton: UIButton!
    var advanceScoreGrid: CGSSGridLabel!
    
    var advanceProgress: UIProgressView!
    
    var viewScoreChartButton: UIButton!
    
    var scoreDescLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var originY: CGFloat = topSpace
        let width = CGSSGlobal.width - 2 * leftSpace
        selfLeaderSkillView = TeamLeaderSkillView.init(frame: CGRect(x: leftSpace, y: topSpace, width: width, height: 65))
        selfLeaderSkillView.arrowDirection = .down
        
        originY += 68
        
        let btnW = (width - 30 - 3.5 * leftSpace) / 6
        icons = [CGSSCardIconView]()
        for i in 0...5 {
            let icon = CGSSCardIconView.init(frame: CGRect(x: leftSpace + (btnW + leftSpace / 2) * CGFloat(i), y: originY, width: btnW, height: btnW))
            addSubview(icon)
            icons.append(icon)
        }
        
        selfLeaderSkillView.arrowOffset = CGPoint.init(x: btnW / 2, y: 0)
        
        
        editTeamButton = UIButton.init(frame: CGRect(x: CGSSGlobal.width - 50, y: originY, width: 50, height: btnW))
        editTeamButton.setImage(UIImage.init(named: "766-arrow-right-toolbar-selected")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        editTeamButton.tintColor = UIColor.lightGray
        editTeamButton.addTarget(self, action: #selector(editTeam), for: .touchUpInside)
        originY += btnW + 3
        
        friendLeaderSkillView = TeamLeaderSkillView.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 65))
        friendLeaderSkillView.arrowDirection = .up
        friendLeaderSkillView.arrowOffset = CGPoint.init(x: btnW * 5.5 + 2.5 * leftSpace, y: 0)
        originY += 65 + topSpace
        
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
        
        backSupportLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: 140, height: 17))
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
        
        manualValueBox = CGSSCheckBox.init(frame: CGRect.init(x: leftSpace, y: originY, width: 150, height: 21))
        manualValueBox.text = NSLocalizedString("使用固定值", comment: "队伍详情页面") + ": "
        manualValueBox.descLabel.font = UIFont.systemFont(ofSize: 16)
        manualValueBox.tintColor = Color.cool
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
        liveTypeDescLable.text = NSLocalizedString("歌曲模式", comment: "队伍详情页面") + ":"
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
        
        grooveTypeDescLable = UILabel.init(frame: CGRect(x: leftSpace, y: 5, width: 120, height: 21))
        grooveTypeDescLable.text = NSLocalizedString("Groove类别", comment: "队伍详情页面") + ":"
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
        startCalcButton.setTitle(NSLocalizedString("一般计算", comment: "队伍详情页面"), for: .normal)
        startCalcButton.backgroundColor = Color.dance
        startCalcButton.addTarget(self, action: #selector(startCalc), for: .touchUpInside)
        
        originY += 30 + topSpace
        scoreGrid = CGSSGridLabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 36), rows: 2, columns: 4)
        
        originY += 36 + topSpace
        
        advanceCalculateButton = UIButton.init(frame: CGRect.init(x: leftSpace, y: originY, width: width, height: 30))
        advanceCalculateButton.setTitle(NSLocalizedString("模拟计算", comment: "队伍详情页面"), for: .normal)
        advanceCalculateButton.backgroundColor = Color.vocal
        advanceCalculateButton.addTarget(self, action: #selector(advanceCalc), for: .touchUpInside)
        
        advanceProgress = UIProgressView.init(frame: CGRect.init(x: 0, y: 30 - 2, width: width, height: 2))
        advanceCalculateButton.addSubview(advanceProgress)
        advanceProgress.trackTintColor = UIColor.clear
        advanceProgress.progressTintColor = Color.parade
        
        originY += 30 + topSpace
        
        advanceScoreGrid = CGSSGridLabel.init(frame: CGRect.init(x: leftSpace, y: originY, width: width, height: 36), rows: 2, columns: 4)
        
        originY += 36 + topSpace
        
        viewScoreChartButton = UIButton.init(frame: CGRect.init(x: leftSpace, y: originY, width: width, height: 30))
        viewScoreChartButton.setTitle("  " + NSLocalizedString("得分详情", comment: "") + " >", for: .normal)
        viewScoreChartButton.backgroundColor = Color.visual
        viewScoreChartButton.addTarget(self, action: #selector(viewScoreChart(sender:)), for: .touchUpInside)
        
        originY += 30 + topSpace
        
        scoreDescLabel = UILabel.init(frame: CGRect(x: leftSpace, y: originY, width: width, height: 80))
        scoreDescLabel.font = UIFont.systemFont(ofSize: 14)
        scoreDescLabel.textColor = UIColor.darkGray
        scoreDescLabel.numberOfLines = 0
        scoreDescLabel.text = NSLocalizedString("* 全部note为Perfect评价，小屋加成为10%\n* 极限分数中所有技能100%触发\n* 极限分数1中note取Perfect判定±0.06秒中的最优值，极限分数2和其他分数都不考虑此项因素\n* 模拟计算结果是10000次模拟后取前x%内的最低分数得出，每次结果会略有不同\n* 选取Groove模式或LIVE Parade模式时会自动忽略好友队长的影响", comment: "队伍详情页面")
        scoreDescLabel.sizeToFit()
        scoreDescLabel.backgroundColor = UIColor.white
        originY += topSpace + scoreDescLabel.fheight + topSpace
        setupScoreGrid()
        
        bottomView.frame.size.height = originY
        
        bottomView.addSubview(descLabel3)
        bottomView.addSubview(selectSongContentView)
        bottomView.addSubview(liveTypeContentView)
        bottomView.addSubview(grooveTypeContentView)
        bottomView.addSubview(startCalcButton)
        bottomView.addSubview(scoreGrid)
        bottomView.addSubview(advanceScoreGrid)
        bottomView.addSubview(advanceCalculateButton)
        bottomView.addSubview(viewScoreChartButton)
        bottomView.addSubview(scoreDescLabel)
        
        addSubview(selfLeaderSkillView)
        addSubview(editTeamButton)
        addSubview(friendLeaderSkillView)
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
    
    func advanceCalc() {
        advanceCalculateButton.setTitle(NSLocalizedString("计算中...", comment: ""), for: .normal)
        advanceCalculateButton.isUserInteractionEnabled = false
        delegate?.advanceCalc()
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
            selfLeaderSkillView.setupWith(text: "\(NSLocalizedString("队长技能", comment: "队伍详情页面")): \(selfLeaderRef.leaderSkill?.name ?? NSLocalizedString("无", comment: ""))\n\(selfLeaderRef.leaderSkill?.getLocalizedExplain(languageType: CGSSGlobal.languageType) ?? "")", backgroundColor: selfLeaderRef.attColor.withAlphaComponent(0.5))
        } else {
            selfLeaderSkillView.setupWith(text: "", backgroundColor: Color.allType.withAlphaComponent(0.5))
        }
        if let friendLeaderRef = team.friendLeader.cardRef {
            friendLeaderSkillView.setupWith(text: "\(NSLocalizedString("好友技能", comment: "队伍详情页面")): \(friendLeaderRef.leaderSkill?.name ?? "无")\n\(friendLeaderRef.leaderSkill?.getLocalizedExplain(languageType: CGSSGlobal.languageType) ?? "")", backgroundColor: friendLeaderRef.attColor.withAlphaComponent(0.5))
        } else {
            friendLeaderSkillView.setupWith(text: "", backgroundColor: Color.allType.withAlphaComponent(0.5))
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
        let colorArray = [UIColor.black, Color.vocal, Color.dance, Color.visual, UIColor.darkGray, Color.life]
        upValueColors.append(contentsOf: Array.init(repeating: colorArray, count: 4))
        upValueColors[1][0] = Color.cute
        upValueColors[2][0] = Color.cool
        upValueColors[3][0] = Color.passion
        
        leaderSkillGrid.setGridContent(upValueStrings)
        leaderSkillGrid.setGridColor(upValueColors)
        
        for i in 0..<6 {
            leaderSkillGrid[0, i].font = CGSSGlobal.alphabetFont
        }
        for i in 0..<4 {
            leaderSkillGrid[i, 0].font = CGSSGlobal.alphabetFont
        }
        
        updatePresentValueGrid(team)
        backSupportTF.text = String(team.supportAppeal!)
        manualValueTF.text = String(team.customAppeal!)
        
        var skillListStrings = [[String]]()
        let skillListColor = [[UIColor]].init(repeating: [UIColor.darkGray], count: 5)
        for i in 0...4 {
            if let skill = team[i]?.cardRef?.skill {
                let str = "\(skill.skillName!): Lv.\(team[i]!.skillLevel!)\n\(skill.getExplainByLevel(team[i]!.skillLevel!, languageType: CGSSGlobal.languageType))"
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
        var appealStrings = [[String]]()
        var presentColor = [[UIColor]]()
        
        appealStrings.append([" ", "Total", "Vocal", "Dance", "Visual"])
        var presentSub1 = [NSLocalizedString("彩色曲", comment: "队伍详情页面")]
        presentSub1.append(contentsOf: team.getAppeal(.office).toStringArrayWithBackValue(team.supportAppeal))
        var presentSub2 = [NSLocalizedString("Cu曲", comment: "队伍详情页面")]
        presentSub2.append(contentsOf: team.getAppeal(.cute).toStringArrayWithBackValue(team.supportAppeal))
        var presentSub3 = [NSLocalizedString("Co曲", comment: "队伍详情页面")]
        presentSub3.append(contentsOf: team.getAppeal(.cool).toStringArrayWithBackValue(team.supportAppeal))
        var presentSub4 = [NSLocalizedString("Pa曲", comment: "队伍详情页面")]
        presentSub4.append(contentsOf: team.getAppeal(.passion).toStringArrayWithBackValue(team.supportAppeal))
        
        appealStrings.append(presentSub1)
        appealStrings.append(presentSub2)
        appealStrings.append(presentSub3)
        appealStrings.append(presentSub4)
        
        let colorArray2 = [UIColor.darkGray, Color.allType, Color.vocal, Color.dance, Color.visual]
        presentColor.append(contentsOf: Array.init(repeating: colorArray2, count: 5))
        presentColor[2][0] = Color.cute
        presentColor[3][0] = Color.cool
        presentColor[4][0] = Color.passion
        
        presentValueGrid.setGridContent(appealStrings)
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
        advanceCalculateButton.fy = scoreGrid.fy + scoreGrid.fheight + topSpace
        advanceScoreGrid.fy = advanceCalculateButton.fbottom + topSpace
        viewScoreChartButton.fy = advanceScoreGrid.fbottom + topSpace
        scoreDescLabel.fy = viewScoreChartButton.fbottom + topSpace
        bottomView.fheight = topSpace + scoreDescLabel.fheight + scoreDescLabel.fy + topSpace
        frame.size = CGSize(width: CGSSGlobal.width, height: bottomView.fheight + bottomView.fy + topSpace * 2)
    }
    
    func resetCalcButton() {
        startCalcButton.setTitle(NSLocalizedString("一般计算", comment: ""), for: .normal)
        startCalcButton.isUserInteractionEnabled = true
    }
    
    func resetAdCalcButton() {
        advanceCalculateButton.setTitle(NSLocalizedString("模拟计算", comment: ""), for: .normal)
        advanceCalculateButton.isUserInteractionEnabled = true
    }
    
    
    func updateScoreGrid(value1: Int, value2: Int, value3: Int, value4: Int) {
        scoreGrid[1, 0].text = String(value1)
        scoreGrid[1, 1].text = String(value2)
        scoreGrid[1, 2].text = String(value3)
        scoreGrid[1, 3].text = String(value4)
    }

    func updateScoreGridSimulateResulte(result1: Int, result2: Int, result3: Int, result4: Int) {
        advanceScoreGrid[1, 0].text = String(result1)
        advanceScoreGrid[1, 1].text = String(result2)
        advanceScoreGrid[1, 2].text = String(result3)
        advanceScoreGrid[1, 3].text = String(result4)
    }
    
    func updateSimulatorPresentValue(_ value: Int) {
        scoreGrid[1, 0].text = String(value)
    }
    
    func clearScoreGrid() {
        scoreGrid[1, 2].text = ""
        scoreGrid[1, 1].text = ""
        scoreGrid[1, 0].text = ""
        scoreGrid[1, 3].text = ""
    }
    
    func clearAdScoreGrid() {
        advanceScoreGrid[1, 0].text = ""
        advanceScoreGrid[1, 1].text = ""
        advanceScoreGrid[1, 2].text = ""
        advanceScoreGrid[1, 3].text = ""
    }
    
    func setupScoreGrid() {
        scoreGrid.isHidden = false
        scoreDescLabel.isHidden = false
        var scoreString = [[String]]()
        scoreString.append([NSLocalizedString("表现值", comment: "队伍详情页面"), NSLocalizedString("极限分数", comment: "队伍详情页面") + "1", NSLocalizedString("极限分数", comment: "队伍详情页面") + "2", NSLocalizedString("平均分数", comment: "队伍详情页面")])
        scoreString.append(["", "", "", ""])
        scoreGrid.setGridContent(scoreString)
        
        advanceScoreGrid.isHidden = false
        var adStrings = [[String]]()
        adStrings.append(["1%", "5%", "20%", "50%"])
        adStrings.append(["", "", "", ""])
        advanceScoreGrid.setGridContent(adStrings)
        
    }
    func backFieldBegin() {
        delegate?.backFieldBegin()
    }
    
    func backFieldDone() {
        let value = Int(backSupportTF.text!) ?? CGSSGlobal.defaultSupportAppeal
        backSupportTF.text = String(value)
        delegate?.backFieldDone(value)
    }
    
    var simulatorType: CGSSLiveSimulatorType = .normal {
        didSet {
            self.liveTypeButton.setTitle("< \(simulatorType.toString()) >", for: .normal)
            self.liveTypeButton.setTitleColor(simulatorType.typeColor(), for: .normal)
            if simulatorType != oldValue {
                self.clearScoreGrid()
                self.clearAdScoreGrid()
            }
        }
    }
    
    var grooveType: CGSSGrooveType? {
        didSet {
            if let type = grooveType {
                self.grooveTypeButton.setTitle("< \(type.rawValue) >", for: .normal)
                self.grooveTypeButton.setTitleColor(type.typeColor(), for: .normal)
            } else {
                self.grooveTypeButton.setTitle("", for: .normal)
            }
            if grooveType != oldValue {
                self.clearScoreGrid()
                self.clearAdScoreGrid()
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
    
    func updateSongInfo(_ live: CGSSLive, beatmap: CGSSBeatmap, diff: Int) {
        // selectSongLabel.hidden = true
        selectSongLabel.text = ""
        songDiffLabel.text = "\(live.getStarsForDiff(diff))☆ \(CGSSGlobal.diffStringFromInt(i: diff)) bpm: \(live.bpm) notes: \(beatmap.numberOfNotes) \(NSLocalizedString("时长", comment: "队伍详情页面")): \(Int(beatmap.totalSeconds))\(NSLocalizedString("秒", comment: "队伍详情页面"))"
        
        // songDiffLabel.text = CGSSGlobal.diffStringFromInt(diff)
        songNameLabel.text = live.musicTitle
        songNameLabel.textColor = live.getLiveColor()
        // songLengthLabel.text = String(Int(beatmaps[diff - 1].totalSeconds)) + "秒"
        if let url = live.jacketURL {
            songJacket.sd_setImage(with: url)
        }
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

    func viewScoreChart(sender: UIButton) {
        delegate?.viewScoreChart(self)
    }
}

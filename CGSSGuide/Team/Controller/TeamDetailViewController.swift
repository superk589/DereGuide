//
//  TeamDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController {
    
    var team: CGSSTeam!
    var teamDV: TeamDetailView!
    var sv: UIScrollView!
    
    var live: CGSSLive?
    var beatmaps: [CGSSBeatmap]?
    var diff: Int?
    var usingManualValue: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        sv = UIScrollView.init(frame: CGRect(x: 0, y: 64, width: CGSSGlobal.width, height: CGSSGlobal.height - 64))
        teamDV = TeamDetailView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 0))
        // teamDV.initWith(team)
        teamDV.delegate = self
        sv.addSubview(teamDV)
        
        view.addSubview(sv)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        teamDV.initWith(team)
        sv.contentSize = teamDV.frame.size
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

//MARK: TeamEditViewControllerDelegate协议方法
extension TeamDetailViewController: TeamEditViewControllerDelegate {
    func save(_ team: CGSSTeam) {
        CGSSTeamManager.defaultManager.removeATeam(self.team)
        self.team = team
        CGSSTeamManager.defaultManager.addATeam(team)
    }
}

//MARK: TeamDetailViewDelegate 协议方法
extension TeamDetailViewController: TeamDetailViewDelegate {
  
    func manualFieldBegin() {
        var offset = teamDV.bottomView.fy + teamDV.manualValueTF.fy + teamDV.manualValueTF.fheight - sv.contentOffset.y + 258 - sv.fheight
        offset += UIApplication.shared.statusBarFrame.size.height - 20
        if offset > 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.sv.contentOffset.y += offset
            })
        }
    }

    func manualFieldDone(_ value: Int) {
        team.manualValue = value
        CGSSTeamManager.defaultManager.writeToFile(nil)
    }

    
    func usingManualValue(using: Bool) {
        usingManualValue = using
    }

    func skillShowOrHide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.sv.contentSize = self.teamDV.frame.size
        })
//        if sv.contentSize.height < teamDV.frame.size.height {
//            UIView.animateWithDuration(0.25, animations: {
//                self.sv.contentSize = self.teamDV.frame.size
//            })
//        } else {
//            // 当收起时 不做任何动作 不改变scrollview的contentsize
//            let offset = sv.contentOffset
//            sv.contentSize = teamDV.frame.size
//            sv.contentOffset = offset
//        }
    }
    
    func selectSong() {
        let songSelectVC = TeamSongSelectViewController()
        songSelectVC.delegate = self
        navigationController?.pushViewController(songSelectVC, animated: true)
    }
    
    func backFieldDone(_ value: Int) {
        team.backSupportValue = value
        teamDV.updatePresentValueGrid(team)
        CGSSTeamManager.defaultManager.writeToFile(nil)
    }
    
    func backFieldBegin() {
        var offset = teamDV.backSupportTF.fy + teamDV.backSupportTF.fheight - sv.contentOffset.y + 258 - sv.fheight
        offset += UIApplication.shared.statusBarFrame.size.height - 20
        if offset > 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.sv.contentOffset.y += offset
            })
        }
    }
    
    func editTeam() {
        let teamEditDVC = TeamEditViewController()
        teamEditDVC.delegate = self
        teamEditDVC.initWith(team)
        
        navigationController?.pushViewController(teamEditDVC, animated: true)
        
    }
    func startCalc() {
        if let live = self.live, let diff = self.diff {
            self.teamDV.clearScoreGrid()
            let simulator = CGSSLiveSimulator.init(team: team, live: live, liveType: teamDV.currentLiveType, grooveType: teamDV.currentGrooveType, diff: diff)
            if usingManualValue {
                self.teamDV.updateSimulatorPresentValue(team.manualValue)
                simulator.simulateOnce(true, manualValue: team.manualValue, callBack: { [weak self](score) in
                    self?.teamDV.updateScoreGridMaxScore(score)
                    })
                simulator.simulate(100, manualValue: team.manualValue, callBack: { [weak self](scores, avg) in
                    self?.teamDV.updateScoreGridAvgScore(avg)
                    })
            } else {
                self.teamDV.updateSimulatorPresentValue(simulator.presentTotal)
                simulator.simulateOnce(true, manualValue: nil, callBack: { [weak self](score) in
                    self?.teamDV.updateScoreGridMaxScore(score)
                })
                simulator.simulate(100, manualValue: nil, callBack: { [weak self](scores, avg) in
                    self?.teamDV.updateScoreGridAvgScore(avg)
                })
            }
            
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("提示", comment: "弹出框标题"), message: NSLocalizedString("请先选择歌曲", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            teamDV.resetCalcButton()
        }
    }
    
    func cardIconClick(_ id: Int) {
        if let card = CGSSDAO.sharedDAO.findCardById(id) {
            let cardDVC = CardDetailViewController()
            cardDVC.card = card
            navigationController?.pushViewController(cardDVC, animated: true)
        }
    }
    func liveTypeButtonClick() {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择歌曲模式", comment: "弹出框标题"), message: nil, preferredStyle: .actionSheet)
        alvc.popoverPresentationController?.sourceView = teamDV.liveTypeButton
        alvc.popoverPresentationController?.sourceRect = CGRect(x: 0, y: teamDV.liveTypeButton.fheight / 2, width: 0, height: 0)
        alvc.popoverPresentationController?.permittedArrowDirections = .right
        for liveType in CGSSLiveType.getAll() {
            alvc.addAction(UIAlertAction.init(title: liveType.toString(), style: .default, handler: { (a) in
                self.teamDV.currentLiveType = liveType
                if liveType != .normal {
                    self.teamDV.showGrooveSelectButton()
                    if self.teamDV.currentGrooveType == nil {
                        self.teamDV.currentGrooveType = CGSSGrooveType.init(cardType: (self.team.leader.cardRef?.cardType)!)!
                    }
                } else {
                    self.teamDV.currentGrooveType = nil
                    self.teamDV.hideGrooveSelectButton()
                }
                self.sv.contentSize = self.teamDV.frame.size
                }))
        }
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
    }
    
    func grooveTypeButtonClick() {
        let alvc = UIAlertController.init(title: NSLocalizedString("选择Groove类别", comment: "弹出框标题"), message: nil, preferredStyle: .actionSheet)
        alvc.popoverPresentationController?.sourceView = teamDV.grooveTypeButton
        alvc.popoverPresentationController?.sourceRect = CGRect(x: 0, y: teamDV.grooveTypeButton.fheight / 2, width: 0, height: 0)
        alvc.popoverPresentationController?.permittedArrowDirections = .right
        for grooveType in CGSSGrooveType.getAll() {
            alvc.addAction(UIAlertAction.init(title: grooveType.rawValue, style: .default, handler: { (a) in
                self.teamDV.currentGrooveType = grooveType
                }))
        }
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "弹出框按钮"), style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
        
    }
    
}

//MARK: BaseSongTableViewControllerDelegate的协议方法
extension TeamDetailViewController: BaseSongTableViewControllerDelegate {
    func selectSong(_ live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        teamDV.updateSongInfo(live, beatmaps: beatmaps, diff: diff)
        self.live = live
        self.beatmaps = beatmaps
        self.diff = diff
    }
}

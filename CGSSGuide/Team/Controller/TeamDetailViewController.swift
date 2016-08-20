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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        sv = UIScrollView.init(frame: CGRectMake(0, 64, CGSSGlobal.width, CGSSGlobal.height - 64))
        teamDV = TeamDetailView.init(frame: CGRectMake(0, 0, CGSSGlobal.width, 0))
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
    
    override func viewWillAppear(animated: Bool) {
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
    func save(team: CGSSTeam) {
        CGSSTeamManager.defaultManager.removeATeam(self.team)
        self.team = team
        CGSSTeamManager.defaultManager.addATeam(team)
    }
}

//MARK: TeamDetailViewDelegate 协议方法
extension TeamDetailViewController: TeamDetailViewDelegate {
    func skillShowOrHide() {
        UIView.animateWithDuration(0.25, animations: {
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
    
    func backValueChanged(value: Int) {
        team.backSupportValue = value
        teamDV.updatePresentValueGrid(team)
        CGSSTeamManager.defaultManager.writeToFile(nil)
    }
    
    func editTeam() {
        let teamEditDVC = TeamEditViewController()
        teamEditDVC.delegate = self
        teamEditDVC.initWith(team)
        
        navigationController?.pushViewController(teamEditDVC, animated: true)
        
    }
    func startCalc() {
        if let live = self.live, diff = self.diff {
            let simulator = CGSSLiveSimulator.init(team: team, live: live, liveType: teamDV.currentLiveType, diff: diff)
            self.teamDV.updateSimulatorPresentValue(simulator.presentTotal)
            simulator.simulateOnce(true, callBack: { [weak self](score) in
                self?.teamDV.updateScoreGridMaxScore(score)
            })
            simulator.simulate(100, callBack: { [weak self](scores, avg) in
                self?.teamDV.updateScoreGridAvgScore(avg)
            })
            
        } else {
            let alert = UIAlertController.init(title: "提示", message: "请先选择歌曲", preferredStyle: .Alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            teamDV.resetCalcButton()
        }
    }
    
    func cardIconClick(id: Int) {
        let cardDVC = CardDetailViewController()
        cardDVC.card = CGSSDAO.sharedDAO.findCardById(id)
        navigationController?.pushViewController(cardDVC, animated: true)
    }
    func liveTypeButtonClick() {
        let alvc = UIAlertController.init(title: "选择歌曲模式", message: nil, preferredStyle: .ActionSheet)
        alvc.popoverPresentationController?.sourceView = teamDV.liveTypeButton
        alvc.popoverPresentationController?.sourceRect = CGRectMake(0, teamDV.liveTypeButton.fheight / 2, 0, 0)
        alvc.popoverPresentationController?.permittedArrowDirections = .Right
        for liveType in CGSSLiveType.getAll() {
            alvc.addAction(UIAlertAction.init(title: liveType.rawValue, style: .Default, handler: { (a) in
                self.teamDV.currentLiveType = liveType
                }))
        }
        alvc.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: nil))
        self.presentViewController(alvc, animated: true, completion: nil)
    }
    
}

//MARK: BaseSongTableViewControllerDelegate的协议方法
extension TeamDetailViewController: BaseSongTableViewControllerDelegate {
    func selectSong(live: CGSSLive, beatmaps: [CGSSBeatmap], diff: Int) {
        teamDV.updateSongInfo(live, beatmaps: beatmaps, diff: diff)
        self.live = live
        self.beatmaps = beatmaps
        self.diff = diff
    }
}
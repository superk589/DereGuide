//
//  TeamDetailViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/30.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController {
    
    var team:CGSSTeam!
    var teamDV:TeamDetailView!
    var sv :UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        sv = UIScrollView.init(frame: CGRectMake(0, 64, CGSSTool.width, CGSSTool.height - 64))
        teamDV = TeamDetailView.init(frame: CGRectMake(0, 0, CGSSTool.width, 0))
        //teamDV.initWith(team)
        teamDV.delegate = self
        sv.contentSize = teamDV.frame.size
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
extension TeamDetailViewController :TeamDetailViewDelegate {
    func skillShowOrHide() {
        
    }
    
    func editTeam(){
        let teamEditDVC = TeamEditViewController()
        teamEditDVC.initWith(team)
        teamEditDVC.delegate = self
        navigationController?.pushViewController(teamEditDVC, animated: true)
        
    }
    func startCalc() {
        
    }
    
    func cardIconClick(id: Int) {
        let cardDVC = CardDetailViewController()
        cardDVC.card = CGSSDAO.sharedDAO.findCardById(id)
        navigationController?.pushViewController(cardDVC, animated: true)
    }
    
}
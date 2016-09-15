//
//  TeamTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamTableViewController: BaseTableViewController, UIPopoverPresentationControllerDelegate, TeamEditViewControllerDelegate {
    
    var teams: [CGSSTeam] {
        let manager = CGSSTeamManager.defaultManager
        return manager.teams
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = TeamTableViewCell.btnW + 55
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTeam))
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addTeam() {
        let vc = TeamEditViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.initWith(teams[(indexPath as NSIndexPath).row])
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CGSSTeamManager.defaultManager.removeATeamAtIndex((indexPath as NSIndexPath).row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 检查队伍数据的完整性, 用户删除数据后, 可能导致队伍中队员的数据缺失, 导致程序崩溃
        let team = teams[(indexPath as NSIndexPath).row]
        if team.validateCardRef() {
            let teamDVC = TeamDetailViewController()
            teamDVC.team = team
            teamDVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(teamDVC, animated: true)
        } else {
            let alert = UIAlertController.init(title: "数据缺失", message: "因数据更新导致队伍数据不完整，建议等待当前更新完成，或尝试在卡片页面下拉更新数据。", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
            // 这种情况下 cell不会自动去除选中状态 故手动置为非选中状态
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    // MARK: TeamEditViewController的协议方法
    
    func save(_ team: CGSSTeam) {
        CGSSTeamManager.defaultManager.addATeam(team)
    }
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

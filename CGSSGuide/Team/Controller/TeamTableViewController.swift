//
//  TeamTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class TeamTableViewController: BaseTableViewController, UIPopoverPresentationControllerDelegate, TeamEditViewControllerDelegate {
    
    var addItem: UIBarButtonItem!
    var deleteItem: UIBarButtonItem!
    var selectItem: UIBarButtonItem!
    var copyItem: UIBarButtonItem!
    
    var teams: [CGSSTeam] {
        let manager = CGSSTeamManager.defaultManager
        return manager.teams
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = TeamTableViewCell.btnW + 55
        addItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTeam))
        deleteItem = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(commitDeletion))
        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        selectItem = UIBarButtonItem.init(title: "全选", style: .plain, target: self, action: #selector(selectAllAction))
        copyItem = UIBarButtonItem.init(title: "复制", style: .plain, target: self, action: #selector(copyAction))
        // toolbarItems = [selectItem, copyItem]
     
        // navigationController?.setToolbarHidden(true, animated: true)
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
    
    func commitDeletion() {
        // 采用倒序删除法
        for indexPath in (tableView.indexPathsForSelectedRows ?? [IndexPath]()).sorted(by: { $0.row > $1.row }) {
        // for indexPath in (tableView.indexPathsForSelectedRows?.reversed() ?? [IndexPath]()) {
            CGSSTeamManager.defaultManager.removeATeamAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEditing(false, animated: true)
        self.tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectAllAction() {
        if isEditing {
            for i in 0..<teams.count {
                tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    func copyAction() {
        if isEditing {
            for indexPath in tableView.indexPathsForSelectedRows ?? [IndexPath]() {
                CGSSTeamManager.defaultManager.teams.append(teams[indexPath.row])
                
            }
            CGSSTeamManager.defaultManager.writeToFile(nil)
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            navigationItem.rightBarButtonItem = deleteItem
            navigationController?.setToolbarHidden(false, animated: true)
            toolbarItems = [selectItem, copyItem]
        } else {
            navigationItem.rightBarButtonItem = addItem
            navigationController?.setToolbarHidden(true, animated: true)
            setToolbarItems(nil, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.initWith(teams[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if isEditing {
            // 编辑状态时 为多选删除模式
            return UITableViewCellEditingStyle.init(rawValue: 0b11)!
        } else {
            // 非编辑状态时 为左滑删除模式
            return .delete
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CGSSTeamManager.defaultManager.removeATeamAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { return }
        // 检查队伍数据的完整性, 用户删除数据后, 可能导致队伍中队员的数据缺失, 导致程序崩溃
        let team = teams[indexPath.row]
        if team.validateCardRef() {
            let teamDVC = TeamDetailViewController()
            teamDVC.team = team
            teamDVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(teamDVC, animated: true)
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("因数据更新导致队伍数据不完整，建议等待当前更新完成，或尝试在卡片页面下拉更新数据。", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
            // 这种情况下 cell不会自动去除选中状态 故手动置为非选中状态
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    // MARK: TeamEditViewController的协议方法
    
    func save(_ team: CGSSTeam) {
        CGSSTeamManager.defaultManager.addATeam(team)
    }
}

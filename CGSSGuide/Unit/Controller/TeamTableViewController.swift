//
//  TeamTableViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import CoreData

class TeamTableViewController: BaseTableViewController, UIPopoverPresentationControllerDelegate {
    
    var addItem: UIBarButtonItem!
    var deleteItem: UIBarButtonItem!
    var selectItem: UIBarButtonItem!
    var deselectItem: UIBarButtonItem!
    var copyItem: UIBarButtonItem!
    var spaceItem: UIBarButtonItem!
    
    var fetchedResultsController: NSFetchedResultsController<Unit>?
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    var units: [Unit] {
        get {
            return fetchedResultsController?.fetchedObjects ?? [Unit]()
        }
    }
    
    var hintLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        tableView.tableFooterView = UIView()
        
        hintLabel = UILabel()
        hintLabel.textColor = UIColor.darkGray
        hintLabel.text = NSLocalizedString("还没有队伍，点击右上＋创建一个吧", comment: "")
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-64)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTeamModifiedNotification), name: .teamModified, object: nil)
        
        prepareToolbar()
        
        prepareFetchRequest()
        
        hintLabel.isHidden = units.count != 0
    }
    
    private func prepareToolbar() {
        addItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addTeam))
        deleteItem = UIBarButtonItem.init(barButtonSystemItem: .trash, target: self, action: #selector(commitDeletion))
        self.navigationItem.rightBarButtonItem = addItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        selectItem = UIBarButtonItem.init(title: NSLocalizedString("全选", comment: ""), style: .plain, target: self, action: #selector(selectAllAction))
        deselectItem = UIBarButtonItem.init(title: NSLocalizedString("全部取消", comment: ""), style: .plain, target: self, action: #selector(deselectAllAction))
        copyItem = UIBarButtonItem.init(title: NSLocalizedString("复制", comment: ""), style: .plain, target: self, action: #selector(copyAction))
        
        spaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Unit> = Unit.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        fetchedResultsController =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    func handleTeamModifiedNotification() {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addTeam() {
        let vc = TeamEditingController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func commitDeletion() {
        // 采用倒序删除法
        for indexPath in (tableView.indexPathsForSelectedRows ?? [IndexPath]()).sorted(by: { $0.row > $1.row }) {
        // for indexPath in (tableView.indexPathsForSelectedRows?.reversed() ?? [IndexPath]()) {
            context.delete(units[indexPath.row])
            // Delete the row from the data source
        }
        _ = context.saveOrRollback()
        setEditing(false, animated: true)
    }
    
    func selectAllAction() {
        if isEditing {
            for i in 0..<units.count {
                tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    func deselectAllAction() {
        if isEditing {
            for i in 0..<units.count {
                tableView.deselectRow(at: IndexPath.init(row: i, section: 0), animated: false)
            }
        }
    }
    
    func copyAction() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, isEditing {
            for indexPath in selectedIndexPaths {
                _ = Unit.insert(into: context, anotherUnit: units[indexPath.row])
            }
            _ = context.saveOrRollback()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            navigationItem.rightBarButtonItem = deleteItem
            navigationController?.setToolbarHidden(false, animated: true)
            toolbarItems = [selectItem, spaceItem, deselectItem, spaceItem, copyItem]
        } else {
            navigationItem.rightBarButtonItem = addItem
            navigationController?.setToolbarHidden(true, animated: true)
            setToolbarItems(nil, animated: true)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // 实现了这两个方法 delete 手势才不会调用 setediting
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    }
   
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    func doneAction() {
        self.tableView.setEditing(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamTableViewCell
        cell.setup(with: units[indexPath.row])
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
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceUnit = units[sourceIndexPath.row]
        let destinationUnit = units[destinationIndexPath.row]
        (sourceUnit.updatedAt, destinationUnit.updatedAt) = (destinationUnit.updatedAt, sourceUnit.updatedAt)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(units[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing { return }
        // 检查队伍数据的完整性, 用户删除数据后, 可能导致队伍中队员的数据缺失, 导致程序崩溃
        let unit = units[indexPath.row]
        if unit.validateMembers() {
            let vc = TeamDetailController()
            vc.unit = unit
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("因数据更新导致队伍数据不完整，建议等待当前更新完成，或尝试在卡片页面下拉更新数据。", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
            // 这种情况下 cell不会自动去除选中状态 故手动置为非选中状态
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        if units.count != 0 {
            hintLabel?.isHidden = true
        } else {
            hintLabel?.isHidden = false
        }
    }
}

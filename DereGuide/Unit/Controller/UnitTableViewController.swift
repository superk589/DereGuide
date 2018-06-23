//
//  UnitTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/28.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import CoreData

class UnitTableViewController: BaseViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    private(set) lazy var addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUnit))
    private(set) lazy var  deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(commitDeletion))
    private(set) lazy var selectItem = UIBarButtonItem(title: NSLocalizedString("全选", comment: ""), style: .plain, target: self, action: #selector(selectAllAction))
    private(set) lazy var deselectItem = UIBarButtonItem(title: NSLocalizedString("全部取消", comment: ""), style: .plain, target: self, action: #selector(deselectAllAction))
    private(set) lazy var copyItem = UIBarButtonItem(title: NSLocalizedString("复制", comment: ""), style: .plain, target: self, action: #selector(copyAction))
    private(set) lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    var fetchedResultsController: NSFetchedResultsController<Unit>?
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    var units: [Unit] {
        get {
            return fetchedResultsController?.fetchedObjects ?? [Unit]()
        }
    }
    
    let hintLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.register(UnitTableViewCell.self, forCellReuseIdentifier: UnitTableViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.keyboardDismissMode = .onDrag

        hintLabel.textColor = .darkGray
        hintLabel.text = NSLocalizedString("还没有队伍，点击右上＋创建一个吧", comment: "")
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleUnitModifiedNotification), name: .unitModified, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateEnd), name: .updateEnd, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleUbiquityIdentityChange), name: .NSUbiquityIdentityDidChange, object: nil)
        
        prepareToolbar()
        
        prepareFetchRequest()
        
        hintLabel.isHidden = units.count != 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    private func prepareToolbar() {
        navigationItem.rightBarButtonItem = addItem
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Unit> = Unit.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        fetchedResultsController =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    @objc func handleUnitModifiedNotification() {
        tableView.reloadData()
    }
    
    @objc func handleUpdateEnd() {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func addUnit() {
        if units.count >= Config.maxNumberOfStoredUnits {
            showTooManyUnitsAlert()
        } else {
            let vc = UnitEditingController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func commitDeletion() {
        // 采用倒序删除法
        for indexPath in (tableView.indexPathsForSelectedRows ?? [IndexPath]()).sorted(by: { $0.row > $1.row }) {
        // for indexPath in (tableView.indexPathsForSelectedRows?.reversed() ?? [IndexPath]()) {
            units[indexPath.row].markForRemoteDeletion()
            // Delete the row from the data source
        }
        context.saveOrRollback()
        setEditing(false, animated: true)
    }
    
    @objc func selectAllAction() {
        if isEditing {
            for i in 0..<units.count {
                tableView.selectRow(at: IndexPath.init(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    @objc func deselectAllAction() {
        if isEditing {
            for i in 0..<units.count {
                tableView.deselectRow(at: IndexPath.init(row: i, section: 0), animated: false)
            }
        }
    }
    
    private func showTooManyUnitsAlert() {
        UIAlertController.showHintMessage(String.init(format: NSLocalizedString("您无法创建超过 %d 个队伍", comment: ""), Config.maxNumberOfStoredUnits), in: nil)
    }
    
    @objc func copyAction() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, isEditing {
            if selectedIndexPaths.count + units.count > Config.maxNumberOfStoredUnits {
                showTooManyUnitsAlert()
            } else {
                for indexPath in selectedIndexPaths {
                    Unit.insert(into: context, anotherUnit: units[indexPath.row])
                }
                context.saveOrRollback()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        tableView.setEditing(editing, animated: animated)
        tableView.endUpdates()
    }
    
    // 实现了这两个方法 delete 手势才不会调用 setediting
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    }
   
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @objc func doneAction() {
        tableView.setEditing(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UnitTableViewCell.description(), for: indexPath) as! UnitTableViewCell
        cell.setup(with: units[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if isEditing {
            // 编辑状态时 为多选删除模式
            return UITableViewCellEditingStyle(rawValue: 0b11)!
        } else {
            // 非编辑状态时 为左滑删除模式
            return .delete
        }
    }
    
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        guard sourceIndexPath.row != destinationIndexPath.row else {
//            return
//        }
//        fetchedResultsController?.delegate = nil
//        let step = (destinationIndexPath.row - sourceIndexPath.row).signum()
//        stride(from: sourceIndexPath.row, to: destinationIndexPath.row, by: step).forEach({ (index) in
//            let unit1 = units[index + step]
//            let unit2 = units[index]
//            (unit1.updatedAt, unit2.updatedAt) = (unit2.updatedAt, unit1.updatedAt)
//        })
//        context.saveOrRollback()
//        fetchedResultsController?.delegate = self
//    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            units[indexPath.row].markForRemoteDeletion()
            context.saveOrRollback()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // 下面这两个方法可以让分割线左侧顶格显示 不再留15像素
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing { return }
        
        // 这种情况下 cell不会自动去除选中状态 故手动置为非选中状态
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        // 检查队伍数据的完整性, 用户删除数据后, 可能导致队伍中队员的数据缺失, 导致程序崩溃
        let unit = units[indexPath.row]
        if unit.validateMembers() {
            let vc = UDTabViewController(unit: unit)
            vc.unit = unit
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("数据缺失", comment: "弹出框标题"), message: NSLocalizedString("因数据更新导致队伍数据不完整，建议等待当前更新完成，或尝试在卡片页面下拉更新数据。", comment: "弹出框正文"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "弹出框按钮"), style: .default, handler: { alert in
                tableView.deselectRow(at: indexPath, animated: true)
            }))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
//    private var isUserDrivenMoving = false
//
//    override func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        if !isUserDrivenMoving {
//            super.controller(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
//
//        }
//    }
    
}

extension UnitTableViewController: NSFetchedResultsControllerDelegate {
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .fade)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        if units.count != 0 {
            hintLabel.isHidden = true
        } else {
            hintLabel.isHidden = false
        }
    }
}

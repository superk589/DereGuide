//
//  BirthdayNotificationViewController.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BirthdayNotificationViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var headerView: UITableView!
    var headerCells: [UITableViewCell]!
    let sectionTitles = ["今天", "明天", "七天内", "一个月内"]
    var presentChars = [[CGSSChar]].init(repeating: [CGSSChar](), count: 4)
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSettingCells()
        prepareChars()
        headerView = UITableView.init(frame: CGRect(x: 0, y: 0, width: CGSSGlobal.width, height: 132), style: .plain)
        headerView.delegate = self
        headerView.dataSource = self
        headerView.allowsSelection = false
        headerView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        tableView.tableHeaderView = headerView
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.register(BirthdayNotificationTableViewCell.self, forCellReuseIdentifier: "BirthdayNotificationCell")
        
        // 设置tableView的separatorStyle 在9.0版本之前会触发tableView的协议方法, 所以必须在这步之前注册tableView的cell
        tableView.separatorStyle = .none
        
        if #available(iOS 9.0, *) {
            headerView.cellLayoutMarginsFollowReadableWidth = false
            tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        
        
        self.popoverPresentationController?.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let cell = headerCells[0]
        (cell.accessoryView as! UILabel).text = (UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) ? "未开启" : "已开启"
    }
    
//    init() {
//        super.init(style: .Grouped)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewWillLayoutSubviews() {
        // 对齐tableview和headerview的左边界
        tableView.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 0)
    }
    func prepareChars() {
        for i in 0...3 {
            presentChars[i].removeAll()
        }
        let bc = BirthdayCenter.defaultCenter
        presentChars[0].append(contentsOf: bc.getRecent(0, endDays: 0))
        presentChars[1].append(contentsOf: bc.getRecent(1, endDays: 1))
        presentChars[2].append(contentsOf: bc.getRecent(2, endDays: 6))
        presentChars[3].append(contentsOf: bc.getRecent(7, endDays: 30))
        
    }
    func prepareSettingCells() {
        headerCells = [UITableViewCell]()
        
        let cell0 = UITableViewCell.init(style: .default, reuseIdentifier: "BirthDaySettingCell")
        cell0.textLabel?.text = "系统通知设置"
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        cell0.accessoryView = label
        label.text = (UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) ? "未开启" : "已开启"
        headerCells.append(cell0)
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "BirthDaySettingCell")
        let swich1 = UISwitch.init(frame: CGRect.zero)
        cell.accessoryView = swich1
        cell.textLabel?.text = "开启生日通知提醒"
        let birthdayNotice = UserDefaults.standard.value(forKey: "BirthdayNotice") as? Bool ?? false
        swich1.isOn = birthdayNotice
        swich1.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        headerCells.append(cell)
        
        let cell2 = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "BirthDaySettingCell")
        cell2.textLabel?.text = "时区"
        cell2.detailTextLabel?.text = UserDefaults.standard.value(forKey: "BirthdayTimeZone") as? String ?? "Asia/Tokyo"
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectTimeZone))
        cell2.addGestureRecognizer(tap)
        headerCells.append(cell2)
        
    }
    
    func valueChanged(_ sw: UISwitch) {
        UserDefaults.standard.setValue(sw.isOn, forKey: "BirthdayNotice")
        refreshData()
    }
    
    func selectTimeZone() {
        let alvc = UIAlertController.init(title: "选择提醒时区", message: nil, preferredStyle: .actionSheet)
        alvc.popoverPresentationController?.sourceView = headerCells[1].detailTextLabel
        alvc.popoverPresentationController?.sourceRect = CGRect(x: headerCells[1].detailTextLabel!.fwidth / 2, y: headerCells[1].detailTextLabel!.fheight, width: 0, height: 0)
        alvc.addAction(UIAlertAction.init(title: "System", style: .default, handler: { (a) in
            UserDefaults.standard.setValue("System", forKey: "BirthdayTimeZone")
            self.headerCells[1].detailTextLabel?.text = "System"
            self.refreshData()
            }))
        alvc.addAction(UIAlertAction.init(title: "Asia/Tokyo", style: .default, handler: { (a) in
            UserDefaults.standard.setValue("Asia/Tokyo", forKey: "BirthdayTimeZone")
            self.headerCells[1].detailTextLabel?.text = "Asia/Tokyo"
            self.refreshData()
            }))
        alvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
    }
    
    func refreshData() {
        if UserDefaults.standard.shouldPostBirthdayNotice {
            (UIApplication.shared.delegate as! AppDelegate).registerAPNS()
            /*if UIApplication.sharedApplication().currentUserNotificationSettings()?.types == nil || UIApplication.sharedApplication().currentUserNotificationSettings()?.types == UIUserNotificationType.None {
             let alert = UIAlertController.init(title: "警告", message: "CGSSGuide的通知被禁用了，请前往手机设置中打开", preferredStyle: .Alert)
             alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
             self.presentViewController(alert, animated: true, completion: nil)
             }*/
            BirthdayCenter.defaultCenter.sortInside()
            BirthdayCenter.defaultCenter.scheduleNotifications()
        } else {
            BirthdayCenter.defaultCenter.removeNotification()
        }
        
        refreshUI()
        
    }
    
    func refreshUI() {
        prepareChars()
        tableView.reloadData()
        (headerCells[0].accessoryView as! UILabel).text = (UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) ? "未开启" : "已开启"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        CGSSNotificationCenter.add(self, selector: #selector(refreshUI), name: "UPDATE_END", object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tableView == headerView {
            return 1
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == headerView {
            return 44
        } else {
            return presentChars[(indexPath as NSIndexPath).section].count > 0 ? 89 : 0
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == headerView {
            return nil
        } else {
            return sectionTitles[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == headerView {
            return headerCells.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == headerView {
            return headerCells[(indexPath as NSIndexPath).row]
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayNotificationCell", for: indexPath) as! BirthdayNotificationTableViewCell
            cell.initWith(presentChars[(indexPath as NSIndexPath).section])
            cell.cv.contentInset.left = cell.layoutMargins.left - 10
            cell.cv.reloadData()
            cell.delegate = self
            // Configure the cell...
            
            return cell
        }
    }
    
}

extension BirthdayNotificationViewController: BirthdayNotificationTableViewCellDelegate {
    func charIconClick(_ icon: CGSSCharIconView) {
        let charInfoDVC = CharDetailViewController()
        charInfoDVC.char = CGSSDAO.sharedDAO.findCharById(icon.charId!)
        self.navigationController?.pushViewController(charInfoDVC, animated: true)
    }
}

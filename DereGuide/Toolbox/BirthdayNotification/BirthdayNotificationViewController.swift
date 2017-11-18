//
//  BirthdayNotificationViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BirthdayNotificationViewController: BaseTableViewController {
    
    let sectionTitles = [NSLocalizedString("今天", comment: "生日提醒页面"), NSLocalizedString("明天", comment: "生日提醒页面"), NSLocalizedString("七天内", comment: "生日提醒页面"), NSLocalizedString("一个月内", comment: "生日提醒页面")]
    
    let ranges: [CountableClosedRange<Int>] = [0...0, 1...1, 2...6, 7...30]
    
    private struct Row {
        var title: String
        var charas: [CGSSChar]
    }
    
    private struct StaticRow {
        var title: String
        var detail: String?
        var hasDisclosure: Bool
        var accessoryView: UIView?
        var selector: Selector?
        var detailTextLabelColor: UIColor?
    }
    
    private var rows = [Row]()
    private var staticRows = [StaticRow]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStaticCellData()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(BirthdayNotificationTableViewCell.self, forCellReuseIdentifier: "BirthdayNotificationCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .updateEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSettings), name: .UIApplicationDidBecomeActive, object: nil)
        
        reloadData()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        staticRows[0].detail = isSystemNotificationSettingOn ? NSLocalizedString("已开启", comment: "生日提醒页面") : NSLocalizedString("未开启", comment: "生日提醒页面")
        tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
    }
    
    private func prepareChars() {
        rows.removeAll()
        let bc = BirthdayCenter.default
        
        for i in 0...3 {
            let charas = bc.getRecent(ranges[i].lowerBound, endDays: ranges[i].upperBound)
            if charas.count > 0 {
                rows.append(Row(title: sectionTitles[i], charas: charas))
            }
        }
    }
    
    private var isSystemNotificationSettingOn: Bool {
        return !(UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == [])
    }
    
    private var isBirthdayNotificationOn: Bool {
        return UserDefaults.standard.value(forKey: "BirthdayNotice") as? Bool ?? false
    }
    
    private var birthdayNotificationTimeZone: String {
        return UserDefaults.standard.value(forKey: "BirthdayTimeZone") as? String ?? "Asia/Tokyo"
    }
    
    private func prepareStaticCellData() {
        
        staticRows.append(StaticRow(title: NSLocalizedString("系统通知设置", comment: "生日提醒页面"), detail: isSystemNotificationSettingOn ? NSLocalizedString("已开启", comment: "生日提醒页面") : NSLocalizedString("未开启", comment: "生日提醒页面"), hasDisclosure: true, accessoryView: nil, selector: #selector(gotoSystemNotificationSettings), detailTextLabelColor: nil))
        
        let `switch` = UISwitch.init(frame: CGRect.zero)
        `switch`.isOn = isBirthdayNotificationOn
        `switch`.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        staticRows.append(StaticRow(title: NSLocalizedString("开启生日通知提醒", comment: "生日提醒页面"), detail: nil, hasDisclosure: false, accessoryView: `switch`, selector: nil, detailTextLabelColor: nil))
        
        staticRows.append(StaticRow(title: NSLocalizedString("时区", comment: "生日提醒页面"), detail: birthdayNotificationTimeZone, hasDisclosure: false, accessoryView: nil, selector: #selector(selectTimeZone), detailTextLabelColor: .parade))
    }
    
    @objc func valueChanged(_ sw: UISwitch) {
        UserDefaults.standard.setValue(sw.isOn, forKey: "BirthdayNotice")
        rescheduleBirthdayNotifications()
        reloadData()
    }
    
    @objc func gotoSystemNotificationSettings() {
        if let url = URL.init(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func selectTimeZone() {
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) {
            let alvc = UIAlertController.init(title: NSLocalizedString("选择提醒时区", comment: "生日提醒页面"), message: nil, preferredStyle: .actionSheet)
            alvc.popoverPresentationController?.sourceView = cell.detailTextLabel
            alvc.popoverPresentationController?.sourceRect = CGRect(x: cell.detailTextLabel!.fwidth / 2, y: cell.detailTextLabel!.fheight, width: 0, height: 0)
            alvc.addAction(UIAlertAction.init(title: "System", style: .default, handler: { [weak self] (a) in
                UserDefaults.standard.setValue("System", forKey: "BirthdayTimeZone")
                self?.rescheduleBirthdayNotifications()
                self?.reloadSettings()
                self?.reloadData()
            }))
            alvc.addAction(UIAlertAction.init(title: "Asia/Tokyo", style: .default, handler: { [weak self] (a) in
                UserDefaults.standard.setValue("Asia/Tokyo", forKey: "BirthdayTimeZone")
                self?.rescheduleBirthdayNotifications()
                self?.reloadSettings()
                self?.reloadData()
            }))
            alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "生日提醒页面"), style: .cancel, handler: nil))
            self.present(alvc, animated: true, completion: nil)
        }
    }
    
    func rescheduleBirthdayNotifications() {
        if UserDefaults.standard.shouldPostBirthdayNotice {
            (UIApplication.shared.delegate as! AppDelegate).registerUserNotification()
            BirthdayCenter.default.scheduleNotifications()
        } else {
            BirthdayCenter.default.removeBirthdayNotifications()
        }
    }
    
    @objc func reloadData() {
        prepareChars()
        tableView.reloadData()
    }
    
    @objc func reloadSettings() {
        staticRows[0].detail = isSystemNotificationSettingOn ? NSLocalizedString("已开启", comment: "生日提醒页面") : NSLocalizedString("未开启", comment: "生日提醒页面")
        staticRows[2].detail = birthdayNotificationTimeZone
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 2, section: 0)], with: .none)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows.count + staticRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0..<staticRows.count:
            var cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayNotificationSettingCell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "BirthdayNotificationSettingCell")
            }
            let row = staticRows[indexPath.row]
           
            cell?.textLabel?.text = row.title
            cell?.detailTextLabel?.text = row.detail
            cell?.accessoryType = row.hasDisclosure ? .disclosureIndicator : .none
            cell?.accessoryView = row.accessoryView
            cell?.selectionStyle = .none
            cell?.detailTextLabel?.textColor = row.detailTextLabelColor ?? .gray
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayNotificationCell", for: indexPath) as! BirthdayNotificationTableViewCell
            cell.setup(with: rows[indexPath.row - 3].charas, title: rows[indexPath.row - 3].title)
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0..<staticRows.count:
            let row = staticRows[indexPath.row]
            if let selector = row.selector {
                self.perform(selector)
            }
        default:
            break
        }
        
    }
}

extension BirthdayNotificationViewController: BirthdayNotificationTableViewCellDelegate {
    
    func charIconClick(_ icon: CGSSCharaIconView) {
        let vc = CharDetailViewController()
        vc.chara = CGSSDAO.shared.findCharById(icon.charaID!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

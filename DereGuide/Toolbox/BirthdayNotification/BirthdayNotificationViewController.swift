//
//  BirthdayNotificationViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BirthdayNotificationViewController: BaseTableViewController, UIPopoverPresentationControllerDelegate {
    
    var staticCells: [UITableViewCell]!
    let sectionTitles = [NSLocalizedString("今天", comment: "生日提醒页面"), NSLocalizedString("明天", comment: "生日提醒页面"), NSLocalizedString("七天内", comment: "生日提醒页面"), NSLocalizedString("一个月内", comment: "生日提醒页面")]
    
    let ranges: [CountableClosedRange<Int>] = [0...0, 1...1, 2...6, 7...30]
    
    struct Row {
        var title: String
        var charas: [CGSSChar]
    }
    
    var rows = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSettingCells()
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        tableView.register(BirthdayNotificationTableViewCell.self, forCellReuseIdentifier: "BirthdayNotificationCell")
        
        // 设置tableView的separatorStyle 在9.0版本之前会触发tableView的协议方法, 所以必须在这步之前注册tableView的cell
        popoverPresentationController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .updateEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .UIApplicationDidBecomeActive, object: nil)
        
        reloadData()
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        let cell = staticCells[0]
        (cell.accessoryView as! UILabel).text = (UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) ? NSLocalizedString("未开启", comment: "生日提醒页面") : NSLocalizedString("已开启", comment: "生日提醒页面")
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
    
    private func prepareSettingCells() {
        
        staticCells = [UITableViewCell]()
        let cell0 = UITableViewCell.init(style: .value1, reuseIdentifier: "BirthDaySettingCell")
        cell0.textLabel?.text = NSLocalizedString("系统通知设置", comment: "生日提醒页面")
        cell0.detailTextLabel?.text = (UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) ? NSLocalizedString("未开启", comment: "生日提醒页面") : NSLocalizedString("已开启", comment: "生日提醒页面")
        cell0.accessoryType = .disclosureIndicator
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(gotoSystemNotificationSettings))
        cell0.addGestureRecognizer(tap2)
        cell0.isUserInteractionEnabled = true
        staticCells.append(cell0)
        
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "BirthDaySettingCell")
        let swich1 = UISwitch.init(frame: CGRect.zero)
        cell.accessoryView = swich1
        cell.textLabel?.text = NSLocalizedString("开启生日通知提醒", comment: "生日提醒页面")
        let birthdayNotice = UserDefaults.standard.value(forKey: "BirthdayNotice") as? Bool ?? false
        swich1.isOn = birthdayNotice
        swich1.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        staticCells.append(cell)
        
        let cell2 = UITableViewCell.init(style: .value1, reuseIdentifier: "BirthDaySettingCell")
        cell2.textLabel?.text = NSLocalizedString("时区", comment: "生日提醒页面")
        cell2.detailTextLabel?.text = UserDefaults.standard.value(forKey: "BirthdayTimeZone") as? String ?? "Asia/Tokyo"
        cell2.detailTextLabel?.textColor = Color.parade

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectTimeZone))
        cell2.addGestureRecognizer(tap)
        staticCells.append(cell2)
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
        let timeZoneCell = staticCells[2]
        let alvc = UIAlertController.init(title: NSLocalizedString("选择提醒时区", comment: "生日提醒页面"), message: nil, preferredStyle: .actionSheet)
        alvc.popoverPresentationController?.sourceView = timeZoneCell.detailTextLabel
        alvc.popoverPresentationController?.sourceRect = CGRect(x: timeZoneCell.detailTextLabel!.fwidth / 2, y: timeZoneCell.detailTextLabel!.fheight, width: 0, height: 0)
        alvc.addAction(UIAlertAction.init(title: "System", style: .default, handler: { [weak self] (a) in
            UserDefaults.standard.setValue("System", forKey: "BirthdayTimeZone")
            timeZoneCell.detailTextLabel?.text = "System"
            self?.rescheduleBirthdayNotifications()
            self?.reloadData()
            }))
        alvc.addAction(UIAlertAction.init(title: "Asia/Tokyo", style: .default, handler: { [weak self] (a) in
            UserDefaults.standard.setValue("Asia/Tokyo", forKey: "BirthdayTimeZone")
            timeZoneCell.detailTextLabel?.text = "Asia/Tokyo"
            self?.rescheduleBirthdayNotifications()
            self?.reloadData()
            }))
        alvc.addAction(UIAlertAction.init(title: NSLocalizedString("取消", comment: "生日提醒页面"), style: .cancel, handler: nil))
        self.present(alvc, animated: true, completion: nil)
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
        staticCells[0].detailTextLabel?.text = (UIApplication.shared.currentUserNotificationSettings?.types == nil || UIApplication.shared.currentUserNotificationSettings?.types == UIUserNotificationType()) ? NSLocalizedString("未开启", comment: "生日提醒页面") : NSLocalizedString("已开启", comment: "生日提醒页面")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0...2:
            return 44
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rows.count + staticCells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0...2:
            return staticCells[indexPath.row]
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BirthdayNotificationCell", for: indexPath) as! BirthdayNotificationTableViewCell
            cell.setup(with: rows[indexPath.row - 3].charas, title: rows[indexPath.row - 3].title)
            cell.delegate = self
            return cell
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

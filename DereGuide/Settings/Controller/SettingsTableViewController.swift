//
//  SettingsTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/7/15.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import MessageUI
import SDWebImage
import Social

class SettingsTableViewController: UITableViewController {

    private var currentVersionCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    private var wipeCachedDataCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    
    private var sectionTitles = [NSLocalizedString("数据", comment: ""), NSLocalizedString("反馈", comment: ""), NSLocalizedString("关于", comment: "")]
    
    private struct Row {
        var title: String
        var detail: String?
        var hasDisclosure: Bool
        var accessoryView: UIView?
        var selector: Selector?
    }
    
    private var sections = [[Row]]()
    
    private func prepareCellData() {

        var dataRows = [Row]()
        var feedbackRows = [Row]()
        var aboutRows = [Row]()
        
        let downloadAtStartSwitch = UISwitch()
        let downloadAtStart = UserDefaults.standard.value(forKey: "DownloadAtStart") as? Bool ?? true
        downloadAtStartSwitch.isOn = downloadAtStart
        downloadAtStartSwitch.addTarget(self, action: #selector(downloadAtStartValueChanged), for: .valueChanged)
        dataRows.append(Row(title: NSLocalizedString("启动时自动检查更新", comment: ""), detail: nil, hasDisclosure: false, accessoryView: downloadAtStartSwitch, selector: nil))
        
        
        let fullImageCacheSwitch = UISwitch()
        let fullImageCache = UserDefaults.standard.value(forKey: "FullImageCache") as? Bool ?? true
        fullImageCacheSwitch.isOn = fullImageCache
        fullImageCacheSwitch.addTarget(self, action: #selector(fullImageCacheChanged), for: .valueChanged)
        dataRows.append(Row(title: NSLocalizedString("移动网络下加载卡片大图", comment: ""), detail: nil, hasDisclosure: false, accessoryView: fullImageCacheSwitch, selector: nil))
        
        dataRows.append(Row(title: NSLocalizedString("缓存所有图片", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(cacheImage)))
        
        dataRows.append(Row(title: NSLocalizedString("清除缓存数据", comment: ""), detail: "...", hasDisclosure: true, accessoryView: nil, selector: #selector(wipeData)))
        
        feedbackRows.append(Row(title: NSLocalizedString("发送邮件", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendEmail)))
        
        feedbackRows.append(Row(title: NSLocalizedString("评价", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(postReview)))
        
        feedbackRows.append(Row(title: NSLocalizedString("Twitter", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(sendTweet)))
        
        aboutRows.append(Row(title: NSLocalizedString("支持作者", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showDonate)))
        
        aboutRows.append(Row(title: NSLocalizedString("致谢", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showAck)))
        
        aboutRows.append(Row(title: NSLocalizedString("版权声明", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showLicense)))
       
        aboutRows.append(Row(title: NSLocalizedString("隐私政策", comment: ""), detail: nil, hasDisclosure: true, accessoryView: nil, selector: #selector(showPrivacyPolicy)))
        
        aboutRows.append(Row(title: NSLocalizedString("当前版本", comment: ""), detail: currentVersion, hasDisclosure: false, accessoryView: nil, selector: nil))
        
        sections += [dataRows, feedbackRows, aboutRows]
    }
    
    private var cacheSize: String? {
        set {
            sections[0][3].detail = newValue
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        }
        get {
            return sections[0][3].detail
        }
    }
    
    private var currentVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    @objc private func fullImageCacheChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "FullImageCache")
    }
    
    @objc private func downloadAtStartValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "DownloadAtStart")
    }
    
    @objc private func showPrivacyPolicy() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func sendTweet() {
        if let url = URL(string: "twitter://post?message=%23\(Config.appName)%0d"), UIApplication.shared.canOpenURL(url) {
            print("open twitter using url scheme")
            UIApplication.shared.openURL(url)
        } else if let url = URL(string: "https://twitter.com/intent/tweet?text=%23\(Config.appName)%0d"), UIApplication.shared.canOpenURL(url) {
            print("open twitter by openURL")
            UIApplication.shared.openURL(url)
        } else if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            print("open twitter by SLComposeViewController")
            vc.setInitialText("#\(Config.appName)\n")
            self.tabBarController?.present(vc, animated: true, completion: nil)
        } else {
            print("open twitter failed")
        }
    }
    
    @objc private func sendEmail() {
        // 首先要判断设备具不具备发送邮件功能
        if MFMailComposeViewController.canSendMail() {
            let controller = MFMailComposeViewController()
            controller.setSubject(NSLocalizedString("\(Config.appName)问题反馈", comment: "设置页面"))
            controller.mailComposeDelegate = self
            controller.setToRecipients(["superk589@vip.qq.com"])
            if CGSSGlobal.languageType == .ja {
                controller.setCcRecipients(["gaiban@poketb.com"])
            }
            controller.addAttachmentData(DeviceInformationManager.default.toString().data(using: .utf8)!, mimeType: "text/plain", fileName: "device_information.txt")
            self.present(controller, animated: true, completion: nil)
        } else {
            let alert = UIAlertController.init(title: NSLocalizedString("打开邮箱失败", comment: "设置页面"), message: NSLocalizedString("未设置邮箱账户", comment: "设置页面"), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: "设置页面"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateCacheSize() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first {
                if let files = FileManager.default.subpaths(atPath: cachePath) {
                    var size = 0
                    for file in files {
                        let path = cachePath.appendingFormat("/\(file)")
                        if let attributes = try? FileManager.default.attributesOfItem(atPath: path) {
                            size += (attributes[FileAttributeKey.size] as! NSNumber).intValue
                        }
                    }
                    DispatchQueue.main.async(execute: { [weak self] in
                        self?.cacheSize = "\(size/(1024*1024))MB"
                    })
                }
            }
        }
    }
    
    @objc private func wipeData() {
        if CGSSUpdater.default.isWorking || CGSSGameResource.shared.isProcessing {
            let alert = UIAlertController.init(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("请等待更新完成或手动取消更新后，再尝试清除数据。", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: NSLocalizedString("确定", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let wipeVC = WipeTableViewController()
            wipeVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(wipeVC, animated: true)
        }
    }
    
    @objc private func cacheImage() {
        if CGSSUpdater.default.isWorking || CGSSGameResource.shared.isProcessing {
            let alert = UIAlertController(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("请等待更新完成或手动取消更新后，再尝试缓存图片。", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let vc = DownloadImageViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func refresh() {
        updateCacheSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .updateEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .saveEnd, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.description())
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: UITableViewCell.description())
        }
        
        let row = sections[indexPath.section][indexPath.row]
        
        cell?.textLabel?.text = row.title
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.detailTextLabel?.text = row.detail
        cell?.accessoryType = row.hasDisclosure ? .disclosureIndicator : .none
        cell?.accessoryView = row.accessoryView
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = sections[indexPath.section][indexPath.row]
        if let selector = row.selector {
            self.perform(selector)
        }
    }
    
    @objc func postReview() {
        // let url = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(CGSSGlobal.appid)"
        guard let url = URL.init(string: "itms-apps://itunes.apple.com/app/id\(CGSSGlobal.appid)?action=write-review") else {
            return
        }
        UIApplication.shared.openURL(url)
    }
    
    @objc func showAck() {
        let ackVC = AcknowledgementViewController()
        ackVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ackVC, animated: true)
    }
    
    @objc func showLicense() {
        let licenseVC = LicenseViewController()
        licenseVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(licenseVC, animated: true)
    }
    
    @objc func showDonate() {
        let donationVC = DonationViewController()
        donationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(donationVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCellData()
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.title = NSLocalizedString("设置", comment: "")
    }
    
}

// MARK: MFMailComposeViewControllerDelegate
extension SettingsTableViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    // 发送邮件代理方法
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
//        switch result{
//        case MFMailComposeResultSent:
//            let alert = UIAlertController.init(title: "邮件发送成功", message: "", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        case MFMailComposeResultCancelled:
//            break // print("邮件已取消")
//        case MFMailComposeResultSaved:
//            break // print("邮件已保存")
//        case MFMailComposeResultFailed:
//            let alert = UIAlertController.init(title: "邮件发送失败", message: "", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction.init(title: "确定", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        default:
//            // print("邮件没有发送")
//            break
//        }
    }
}

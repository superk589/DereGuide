//
//  AcknowledgementViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/20.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SnapKit

typealias AcknowledgementTableViewCell = LicenseTableViewCell

class AcknowledgementViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    let path1 = Bundle.main.path(forResource: "DataSource", ofType: ".plist")
    
    let path2 = Bundle.main.path(forResource: "SpecialThanks", ofType: ".plist")
    
    var tableView: UITableView!
    
    var headerTitles = [NSLocalizedString("Data Sources", comment: ""), NSLocalizedString("Special Thanks to", comment: "")]
    
    lazy var dataSources: [[String: String]] = {
        return NSArray.init(contentsOfFile: self.path1!) as! [[String: String]]
    }()
    
    lazy var supporters: [String] = {
        return NSArray.init(contentsOfFile: self.path2!) as! [String]
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: view.fwidth, height: view.fheight), style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.register(AcknowledgementTableViewCell.self, forCellReuseIdentifier: "AckCell")
        
        if #available(iOS 9.0, *) {
            tableView.cellLayoutMarginsFollowReadableWidth = false
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataSources.count
        } else {
            return supporters.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AckCell", for: indexPath) as! AcknowledgementTableViewCell
        if indexPath.section == 0 {
            cell.setup(title: dataSources[indexPath.row]["name"]!, site: dataSources[indexPath.row]["site"]!)
        } else {
            cell.setup(title: supporters[indexPath.row], site: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath) as? LicenseTableViewCell {
            if let url = URL.init(string: cell.siteLabel.text ?? "") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

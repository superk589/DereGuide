//
//  LicenseViewController.swift
//  DereGuide
//
//  Created by zzk on 2016/9/20.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class LicenseViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    let path = Bundle.main.path(forResource: "ThirdPartyLibraries", ofType: ".plist")
    
    var tableView: UITableView!
    
    var headerTitles = [NSLocalizedString("Copyright of Game Data", comment: ""), NSLocalizedString("Copyright of \(Config.appName)", comment: "") , NSLocalizedString("Third-party Libraries", comment: "")]
    
    lazy var thirdPartyLibraries: [[String: String]] = {
        return NSArray(contentsOfFile: self.path!) as! [[String: String]]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("版权声明", comment: "")
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.fwidth, height: view.fheight), style: .grouped)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.register(LicenseTableViewCell.self, forCellReuseIdentifier: "LicenseCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return thirdPartyLibraries.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LicenseCell", for: indexPath) as! LicenseTableViewCell
        if indexPath.section == 0 {
            cell.setup(title: NSLocalizedString("本程序是非官方程序，与官方应用\"アイドルマスターシンデレラガールズ スターライトステージ\"没有任何关联。所有本程序中使用的游戏相关数据版权所属为：\nBANDAI NAMCO Entertainment Inc.\n\n本程序所使用的非官方数据来源于网络，其版权在不违反官方版权的前提下遵循数据提供者的版权声明。\n\n本程序不能保证所提供的数据真实可靠，由此带来的风险由使用者承担。", comment: ""), site: "")
        } else if indexPath.section == 1 {
            cell.setup(title: NSLocalizedString("本程序基于MIT协议，详情请访问：", comment: ""), site: "https://github.com/superk589/DereGuide")
        } else {
            cell.setup(title: thirdPartyLibraries[indexPath.row]["name"]!, site: thirdPartyLibraries[indexPath.row]["site"]!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: indexPath) as? LicenseTableViewCell {
            if let url = URL(string: cell.siteLabel.text ?? "") {
                UIApplication.shared.openURL(url)
            }
        }
    }

}

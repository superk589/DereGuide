//
//  DMComposingStepOneController.swift
//  DereGuide
//
//  Created by zzk on 01/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

class DMComposingStepOneController: BaseViewController {
    
    let idLabel = UILabel()
    
    let input = UITextField()
    
    let confirmButton = WideLoadingButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        if let profile = Profile.fetchSingleObject(in: CoreDataStack.default.viewContext, cacheKey: "MyProfile", configure: { _ in }) {
            input.text = profile.gameID
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        input.becomeFirstResponder()
    }
    
    private func prepareUI() {
        idLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(idLabel)
        idLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(160)
        }
        idLabel.text = NSLocalizedString("输入您的游戏ID", comment: "")
        
        input.font = UIFont.systemFont(ofSize: 20)
        input.autocorrectionType = .no
        input.autocapitalizationType = .none
        input.borderStyle = .none
        input.textAlignment = .center
        input.keyboardType = .numberPad
        input.returnKeyType = .done
        input.contentVerticalAlignment = .center
        view.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.top.equalTo(idLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)
        }
        
        let line = LineView()
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(input.snp.bottom)
            make.width.equalTo(input)
            make.left.equalTo(input)
        }
        
        view.addSubview(confirmButton)
        confirmButton.setup(normalTitle: NSLocalizedString("下一步", comment: ""), loadingTitle: NSLocalizedString("获取数据中...", comment: ""))
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        confirmButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-258)
        }
        confirmButton.backgroundColor = Color.dance
    }
    
    @objc func confirmAction() {
        guard input.check(pattern: "^[0-9]{9}$") else {
            UIAlertController.showHintMessage(NSLocalizedString("您输入的游戏ID不合法", comment: ""), in: self)
            return
        }
        confirmButton.setLoading(true)
        BaseRequest.default.getWith(urlString: "https://deresute.me/\(input.text!)/json") { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.confirmButton.setLoading(false)
                if error != nil {
                    UIAlertController.showHintMessage(NSLocalizedString("未能获取到正确的数据，请稍后再试", comment: ""), in: self)
                } else if response?.statusCode != 200 {
                    UIAlertController.showHintMessage(NSLocalizedString("您输入的游戏ID不存在", comment: ""), in: self)
                } else {
                    let json = JSON.init(data: data!)
                    let profile = DMProfile(fromJson: json)
                    let vc = DMComposingStepTwoController()
                    vc.setup(dmProfile: profile)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

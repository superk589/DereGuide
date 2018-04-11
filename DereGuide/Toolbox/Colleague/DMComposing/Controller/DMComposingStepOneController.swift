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
        input.delegate = self
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
            make.bottom.equalTo(-10)
        }
        confirmButton.backgroundColor = .dance
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(avoidKeyboard(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(avoidKeyboard(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func avoidKeyboard(_ notification: Notification) {
        guard
            // 结束位置
            let endFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            
            // 开始位置
            // let beginFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            
            // 持续时间
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
            
            else {
                return
        }
        
        // 时间曲线函数
        let curve = UIViewAnimationOptions.init(rawValue: (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIViewAnimationOptions.curveEaseOut.rawValue)
        lastKeyboardFrame = endFrame
        lastCurve = curve
        lastDuration = duration.doubleValue
        let frame = view.convert(endFrame, from: nil)
        let intersection = frame.intersection(view.frame)
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: [curve], animations: {
            self.confirmButton.transform = CGAffineTransform(translationX: 0, y: -intersection.height )
        }, completion: nil)
        
        view.setNeedsLayout()
    }
    
    private var lastKeyboardFrame: CGRect?
    private var lastCurve: UIViewAnimationOptions?
    private var lastDuration: TimeInterval?
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let lastFrame = lastKeyboardFrame, let curve = lastCurve, let duration = lastDuration {
            let frame = view.convert(lastFrame, from: nil)
            let intersection = frame.intersection(view.frame)
            UIView.animate(withDuration: duration, delay: 0, options: [curve, .beginFromCurrentState], animations: {
                self.confirmButton.transform = CGAffineTransform(translationX: 0, y: -intersection.height )
            }, completion: nil)
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
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
                    let json = JSON(data!)
                    let profile = DMProfile(fromJson: json)
                    let vc = DMComposingStepTwoController()
                    vc.setup(dmProfile: profile)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension DMComposingStepOneController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        confirmAction()
        return true
    }
    
}

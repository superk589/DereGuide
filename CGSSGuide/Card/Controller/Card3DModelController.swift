//
//  Card3DModelController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/22.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

enum ModelType {
    case bright
    case stars
    case special
}

extension CGSSCard {
    func get3DModelURL(modelType: ModelType) -> URL? {
        switch modelType {
        case .bright:
            return URL.init(string: "https://deresute.info/3d/901\(charaId!)")
        case .stars:
            return URL.init(string: "https://deresute.info/3d/902\(charaId!)")
        case .special:
            return URL.init(string: "https://deresute.info/3d/\(seriesId!)")
        }
    }
}

class Card3DModelController: BaseViewController {
    
    var card: CGSSCard! {
        didSet {
            if card.rarityType == .ssr || card.rarityType == .ssrp {
                currentModelType = .special
            }
        }
    }
    
    var webView: WKWebView!

    var linkView: UILabel!
    
    var progressIndicator: UIProgressView!
    
    var indicator: UIActivityIndicatorView!
    
    var currentModelType: ModelType = .bright {
        didSet {
            requestData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        webView.navigationDelegate = self
        
        progressIndicator = UIProgressView()
        view.addSubview(progressIndicator)
        progressIndicator.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.right.equalToSuperview()
        }
        
        indicator = UIActivityIndicatorView()
        indicator.activityIndicatorViewStyle = .gray
        view.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        linkView = UILabel()
        view.addSubview(linkView)
        linkView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-54)
            make.right.equalTo(-10)
        }
        
        let attributeText = NSMutableAttributedString.init(string: "powered by deresute.info", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray])
        attributeText.addAttributes([NSLinkAttributeName: URL.init(string: "https://deresute.info")!, NSForegroundColorAttributeName: Color.parade], range: NSRange.init(location: 11, length: 13))
        linkView.attributedText = attributeText
        linkView.textAlignment = .right
        linkView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(openURLAction))
        linkView.addGestureRecognizer(tap)
        
        requestData()
        
        addObserver(self, forKeyPath: "self.webView.estimatedProgress", options: [.new], context: nil)

        
        prepareToolbar()
        
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        removeObserver(self, forKeyPath: "self.webView.estimatedProgress")
    }
    
    func prepareToolbar() {
        let item1 = UIBarButtonItem.init(title: NSLocalizedString("服装", comment: "") + "1", style: .plain, target: self, action: #selector(selectDress1))
        let spaceItem1 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let item2 = UIBarButtonItem.init(title: NSLocalizedString("服装", comment: "") + "2", style: .plain, target: self, action: #selector(selectDress2))
        
        toolbarItems = [item1, spaceItem1, item2]
        
        if card.rarityType == .ssr || card.rarityType == .ssrp {
            let spaceItem2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let item3 = UIBarButtonItem.init(title: NSLocalizedString("SSR服装", comment: ""), style: .plain, target: self, action: #selector(selectDressSpecial))
            toolbarItems?.append(spaceItem2)
            toolbarItems?.append(item3)
        }

    }
    
    func openURLAction() {
        UIApplication.shared.openURL(URL.init(string: "https://deresute.info")!)
    }
    
    func selectDress1() {
        currentModelType = .bright
    }
    
    func selectDress2() {
        currentModelType = .stars
    }
    
    func selectDressSpecial() {
        currentModelType = .special
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "self.webView.estimatedProgress" {
            if let newValue = change?[.newKey] as? Double {
                DispatchQueue.main.async { [weak self] in
                    self?.progressIndicator.progress = Float(newValue)
                    if newValue == 1 {
                        self?.indicator.stopAnimating()
                        self?.progressIndicator.isHidden = true
                    } else {
                        self?.progressIndicator.isHidden = false
                    }

                }
            }
        }
    }
    func requestData() {
        if let url = card.get3DModelURL(modelType: currentModelType) {
            let request = URLRequest.init(url: url)
            indicator?.startAnimating()
            _ = webView?.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension Card3DModelController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}

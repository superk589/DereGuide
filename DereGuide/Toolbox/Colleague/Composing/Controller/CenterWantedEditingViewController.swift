//
//  CenterWantedEditingViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit


protocol CenterWantedEditingViewControllerDelegate: class {
    func didDelete(centerWantedEditingViewController: CenterWantedEditingViewController)
}

class CenterWantedEditingViewController: UIViewController {
    
    var editingView: CenterWantedEditingView!
    
    weak var delegate: CenterWantedEditingViewControllerDelegate?
    
    func setupWith(card: CGSSCard, minLevel: Int) {
        if editingView == nil {
            editingView = CenterWantedEditingView()
            view.addSubview(editingView)
            editingView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            editingView.delegate = self
        }
        
        editingView.setupWith(card: card, minLevel: minLevel)
    }
    
}

extension CenterWantedEditingViewController: CenterWantedEditingViewDelegate {
    
    func didDelete(centerWantedEditingView: CenterWantedEditingView) {
        dismiss(animated: true, completion: nil)
        delegate?.didDelete(centerWantedEditingViewController: self)
    }
    
}

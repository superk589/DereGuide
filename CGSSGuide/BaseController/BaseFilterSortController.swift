//
//  BaseFilterSortController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/12.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class BaseFilterSortController: BaseViewController {

    var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar = UIToolbar()
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(44)
        }

        let leftSpaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpaceItem.width = 0
        let doneItem = UIBarButtonItem.init(title: NSLocalizedString("完成", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(doneAction))
        let middleSpaceItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let resetItem = UIBarButtonItem.init(title: NSLocalizedString("重置", comment: "导航栏按钮"), style: .plain, target: self, action: #selector(resetAction))
        
        let rightSpaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightSpaceItem.width = 0
        
        toolbar.setItems([leftSpaceItem, resetItem, middleSpaceItem, doneItem, rightSpaceItem], animated: false)
    }

    
    func doneAction() {
        
    }
    
    func resetAction() {
        
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

//
//  GachaCardFilterSortController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/2.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class GachaCardFilterSortController: CardFilterSortController {
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sorterTitles.append(NSLocalizedString("出现率", comment: ""))
        sorterMethods.append("odds")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

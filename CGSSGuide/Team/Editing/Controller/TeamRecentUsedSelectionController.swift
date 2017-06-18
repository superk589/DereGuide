//
//  TeamRecentUsedSelectionController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/15.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol TeamRecentUsedSelectionControllerDelegate: class {
    func teamRecentUsedSelectionController(_ teamRecentUsedSelectionController: TeamRecentUsedSelectionController, didSelect teamMember: CGSSTeamMember)
}

class TeamRecentUsedSelectionController: BaseViewController {
    
    weak var delegate: TeamRecentUsedSelectionControllerDelegate?
    
    var collectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

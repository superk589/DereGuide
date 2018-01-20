//
//  GachaDetailSimulatorCell.swift
//  DereGuide
//
//  Created by zzk on 19/01/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaDetailSimulatorCell: ReadableWidthTableViewCell {

    override var maxReadableWidth: CGFloat {
        return 824
    }
    
    let simulatorView = GachaSimulatorView()
    
    weak var delegate: GachaSimulatorViewDelegate? {
        didSet {
            simulatorView.delegate = delegate
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        readableContentView.addSubview(simulatorView)
        simulatorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        selectionStyle = .none
    }
    
    func setup(cardIDs: [Int], result: GachaSimulationResult) {
        simulatorView.setup(cardIDs: cardIDs, result: result)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

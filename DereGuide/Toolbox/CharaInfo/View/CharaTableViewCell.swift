//
//  CharaTableViewCell.swift
//  DereGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class CharaTableViewCell: UITableViewCell {
    
    var charaView = CharaView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepare()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    private func prepare() {

        contentView.addSubview(charaView)
        charaView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
        }
        
    }
    
    func setupWith(char: CGSSChar, sorter: CGSSSorter) {
        charaView.setupWith(char: char, sorter: sorter)
    }

}

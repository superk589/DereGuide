//
//  CardTableViewCell.swift
//  CGSSGuide
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardName: UILabel!
 
 
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var vocal: UILabel!
    @IBOutlet weak var dance: UILabel!
    @IBOutlet weak var visual: UILabel!
    @IBOutlet weak var cardSmallImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

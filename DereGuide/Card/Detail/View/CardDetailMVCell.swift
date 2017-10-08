//
//  CardDetailMVCell.swift
//  DereGuide
//
//  Created by zzk on 29/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import TTGTagCollectionView

protocol CardDetailMVCellDelegate: class {
    func cardDetailMVCell(_ cardDetailMVCell: CardDetailMVCell, didClickAt index: Int)
}

class CardDetailMVCell: UITableViewCell {

    let leftLabel = UILabel()
    
    var tagViews = [BannerView]()
    
    let collectionView = TTGTagCollectionView()
    
    weak var delegate: CardDetailMVCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("出演MV", comment: "")
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        collectionView.contentInset = .zero
        collectionView.verticalSpacing = 5
        collectionView.horizontalSpacing = 5
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(songs: [CGSSSong]) {
        tagViews.removeAll()
        
        for song in songs {
            let tagView = BannerView()
            if let url = song.jacketURL {
                tagView.sd_setImage(with: url)
            }
            
            tagViews.append(tagView)
        }
        collectionView.reload()
    }
    
    
}

extension CardDetailMVCell: TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource {
   
    func numberOfTags(in tagCollectionView: TTGTagCollectionView!) -> UInt {
        return UInt(tagViews.count)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, tagViewFor index: UInt) -> UIView! {
        return tagViews[Int(index)]
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, sizeForTagAt index: UInt) -> CGSize {
        return CGSize(width: 66, height: 66)
    }
    
    func tagCollectionView(_ tagCollectionView: TTGTagCollectionView!, didSelectTag tagView: UIView!, at index: UInt) {
        delegate?.cardDetailMVCell(self, didClickAt: Int(index))
    }
}

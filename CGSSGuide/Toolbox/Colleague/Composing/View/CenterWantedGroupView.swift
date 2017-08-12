//
//  CenterWantedGroupView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/8/4.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol CenterWantedGroupViewDelegate: class {
    func centerWantedGroupView(_ centerWantedGroupView: CenterWantedGroupView, didLongPressAt item: CenterWantedItemView)
    func centerWantedGroupView(_ centerWantedGroupView: CenterWantedGroupView, didDoubleTap item: CenterWantedItemView)
}

class CenterWantedGroupView: UIView {
    
    weak var delegate: CenterWantedGroupViewDelegate?
    
    var descLabel: UILabel!
    
    var stackView: UIStackView!
    
    var editableItemViews: [CenterWantedItemView]!
    
    var result: [(Int, Int)] {
        return editableItemViews.map { ($0.cardID, $0.minLevel) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let types = [CGSSLiveTypes.cute, .cool, .passion, .allType]
        editableItemViews = [CenterWantedItemView]()
        for index in 0..<4 {
            let view = CenterWantedItemView()
            view.setup(with: types[index])
            editableItemViews.append(view)
            view.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture(_:)))
            doubleTap.numberOfTapsRequired = 2
            
            view.addGestureRecognizer(doubleTap)
            view.addGestureRecognizer(tap)
            view.addGestureRecognizer(longPress)
        }
        stackView = UIStackView(arrangedSubviews: editableItemViews)
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        stackView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
            // make the view as wide as possible
            make.right.equalTo(-10).priority(900)
            make.left.equalTo(10).priority(900)
            //
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualTo(104 * 5 + 30)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        //        if let view = tap.view as? TeamMemberEditableItemView {
        //            if let index = stackView.arrangedSubviews.index(of: view) {
        //                // select index
        //            }
        //        }
    }
    
    @objc func handleLongPressGesture(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            guard let view = longPress.view as? CenterWantedItemView else { return }
            delegate?.centerWantedGroupView(self, didLongPressAt: view)
        }
    }
    
    @objc func handleDoubleTapGesture(_ doubleTap: UITapGestureRecognizer) {
        guard let view = doubleTap.view as? CenterWantedItemView else { return }
        delegate?.centerWantedGroupView(self, didDoubleTap: view)
    }
    
    func setupWith(cardID: Int, minLevel: Int, at index: Int, hidesIfNeeded: Bool = false) {
        editableItemViews[index].setupWith(cardID: cardID, minLevel: minLevel)
        if cardID == 0 && hidesIfNeeded {
            editableItemViews[index].isHidden = true
        } else {
            editableItemViews[index].isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

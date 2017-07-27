//
//  TeamMemberEditableView.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

class TeamMemberEditableItemView: UIView {
    var cardView: TeamSimulationCardView!
    var overlayView: UIView!
    var placeholderImageView: UIImageView!
    var cardPlaceholder: UIView!
    
    private(set) var isSelected: Bool = false
    
    private var strokeColor: CGColor = UIColor.lightGray.cgColor {
        didSet {
            overlayView.layer.borderColor =  isSelected ? strokeColor : UIColor.lightGray.cgColor
            overlayView.layer.shadowColor = strokeColor
        }
    }
    
    private func setSelected(_ selected: Bool) {
        isSelected = selected
        if selected {
            overlayView.layer.shadowOpacity = 1
            overlayView.layer.borderColor = strokeColor
            overlayView.layer.shadowColor = strokeColor
            overlayView.layer.borderWidth = 2
        } else {
            overlayView.layer.shadowOpacity = 0
            overlayView.layer.borderColor = UIColor.lightGray.cgColor
            overlayView.layer.borderWidth = 0
        }
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        
        if animated {
            overlayView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.overlayView.transform = .identity
                self.setSelected(selected)
            }, completion: nil)
        } else {
            setSelected(selected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        overlayView = UIView()
        addSubview(overlayView)
        overlayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        overlayView.layer.shadowOffset = CGSize.zero
        setSelected(false)
        
        cardView = TeamSimulationCardView()
        cardView.icon.isUserInteractionEnabled = false
        addSubview(cardView)
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        }
        
        placeholderImageView = UIImageView(image: #imageLiteral(resourceName: "436-plus").withRenderingMode(.alwaysTemplate))
        addSubview(placeholderImageView)
        placeholderImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(self.snp.width).dividedBy(3)
        }
        placeholderImageView.tintColor = .lightGray
        
        cardPlaceholder = UIView()
        addSubview(cardPlaceholder)
        cardPlaceholder.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-8)
            make.height.equalTo(cardPlaceholder.snp.width)
            make.center.equalToSuperview()
        }
        cardPlaceholder.layer.masksToBounds = true
        cardPlaceholder.layer.cornerRadius = 4
        cardPlaceholder.layer.borderWidth = 1 / Screen.scale
        cardPlaceholder.layer.borderColor = UIColor.lightSeparator.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with member: Member) {
        placeholderImageView.isHidden = true
        cardPlaceholder.isHidden = true
        if let color = member.card?.attColor.cgColor {
            strokeColor = color
        }
        cardView.setup(with: member)
        bringSubview(toFront: cardView)
    }
}

protocol TeamMemberEditableViewDelegate: class {
    func teamMemberEditableView(_ teamMemberEditableView: TeamMemberEditableView, didLongPressAt item: TeamMemberEditableItemView)
    func teamMemberEditableView(_ teamMemberEditableView: TeamMemberEditableView, didDoubleTap item: TeamMemberEditableItemView)
}

class TeamMemberEditableView: UIView {
    
    weak var delegate: TeamMemberEditableViewDelegate?
    
    var descLabel: UILabel!
    
    var stackView: UIStackView!
    
    var editableItemViews: [TeamMemberEditableItemView]!
    
    var centerLabel: UILabel!
    
    var guestLabel: UILabel!
    
    var currentIndex: Int = 0 {
        didSet {
            if oldValue != currentIndex {
                editableItemViews[oldValue].setSelected(selected: false, animated: false)
                editableItemViews[currentIndex].setSelected(selected: true, animated: true)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        editableItemViews = [TeamMemberEditableItemView]()
        for _ in 0..<6 {
            let view = TeamMemberEditableItemView()
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
        editableItemViews[0].setSelected(selected: true, animated: false)
        stackView = UIStackView(arrangedSubviews: editableItemViews)
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        stackView.snp.remakeConstraints({ (make) in
            make.left.greaterThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-10)
            // make the view as wide as possible
            make.right.equalTo(-10).priority(900)
            make.left.equalTo(10).priority(900)
            //
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(104 * 6 + 30)
            make.centerX.equalToSuperview()
        })
        
        centerLabel = UILabel()
        centerLabel.text = NSLocalizedString("队长", comment: "")
        centerLabel.font = UIFont.systemFont(ofSize: 12)
        centerLabel.adjustsFontSizeToFitWidth = true
        addSubview(centerLabel)
        centerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.centerX.equalTo(editableItemViews[0])
            make.bottom.equalTo(stackView.snp.top).offset(-5)
            make.width.lessThanOrEqualTo(editableItemViews[0].snp.width).offset(-4)
        }
        
        guestLabel = UILabel()
        guestLabel.text = NSLocalizedString("好友", comment: "")
        guestLabel.font = UIFont.systemFont(ofSize: 12)
        guestLabel.adjustsFontSizeToFitWidth = true
        addSubview(guestLabel)
        guestLabel.snp.makeConstraints { (make) in
            make.top.equalTo(centerLabel)
            make.width.lessThanOrEqualTo(editableItemViews[5].snp.width).offset(-4)
            make.centerX.equalTo(editableItemViews[5])
        }
    }
    
    @objc func handleTapGesture(_ tap: UITapGestureRecognizer) {
        if let view = tap.view as? TeamMemberEditableItemView {
            if let index = stackView.arrangedSubviews.index(of: view) {
                currentIndex = index
            }
        }
    }
    
    @objc func handleLongPressGesture(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            guard let view = longPress.view as? TeamMemberEditableItemView else { return }
            if let index = stackView.arrangedSubviews.index(of: view) {
                currentIndex = index
            }
            delegate?.teamMemberEditableView(self, didLongPressAt: view)
        }
    }
    
    @objc func handleDoubleTapGesture(_ doubleTap: UITapGestureRecognizer) {
        guard let view = doubleTap.view as? TeamMemberEditableItemView else { return }
        delegate?.teamMemberEditableView(self, didDoubleTap: view)
    }
    
    func setup(with unit: Unit) {
        for i in 0..<6 {
            let member = unit[i]
            setup(with: member, at: i)
        }
    }
    
    func moveIndexToNext() {
        var nextIndex = currentIndex + 1
        if nextIndex == 6 {
            nextIndex = 0
        }
        currentIndex = nextIndex
    }
    
    func setup(with member: Member, at index: Int) {
        editableItemViews[index].setup(with: member)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

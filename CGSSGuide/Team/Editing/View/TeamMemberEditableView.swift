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
    
    func setup(with member: CGSSTeamMember) {
        placeholderImageView.isHidden = true
        cardPlaceholder.isHidden = true
        if let color = member.cardRef?.attColor.cgColor {
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
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-30)
        }
    }
    
    func handleTapGesture(_ tap: UITapGestureRecognizer) {
        if let view = tap.view as? TeamMemberEditableItemView {
            if let index = stackView.arrangedSubviews.index(of: view) {
                currentIndex = index
            }
        }
    }
    
    func handleLongPressGesture(_ longPress: UILongPressGestureRecognizer) {
        guard let view = longPress.view as? TeamMemberEditableItemView else { return }
        if let index = stackView.arrangedSubviews.index(of: view) {
            currentIndex = index
        }
        delegate?.teamMemberEditableView(self, didLongPressAt: view)
    }
    
    func handleDoubleTapGesture(_ doubleTap: UITapGestureRecognizer) {
        guard let view = doubleTap.view as? TeamMemberEditableItemView else { return }
        delegate?.teamMemberEditableView(self, didDoubleTap: view)
    }
    
    func setupWith(team: CGSSTeam) {
        for i in 0..<6 {
            if let member = team[i] {
                setupWithMember(member, atIndex: i)
            }
        }
    }
    
    func setupWithMember(_ member: CGSSTeamMember, atIndex index: Int) {
        editableItemViews[index].setup(with: member)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

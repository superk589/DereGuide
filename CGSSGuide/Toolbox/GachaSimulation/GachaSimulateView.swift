//
//  GachaSimulateView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol GachaSimulateViewDelegate: class {
    func singleGacha(gachaSimulateView: GachaSimulateView)
    func tenGacha(gachaSimulateView: GachaSimulateView)
    func gachaSimulateView(_ view: GachaSimulateView, didClick cardIcon:CGSSCardIconView)
}

class GachaSimulateView: UIView {
    
    let space: CGFloat = 10
    let btnW = min(96, (Screen.shortSide - 60) / 5)
    var singleButton : UIButton!
    var tenButton: UIButton!
    var resultView: UIView!
    var descLabel: UILabel!
    weak var delegate: GachaSimulateViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        singleButton = UIButton()
        singleButton.setTitle(NSLocalizedString("单抽", comment: "模拟抽卡页面"), for: .normal)
        singleButton.backgroundColor = Color.passion
        singleButton.addTarget(self, action: #selector(clickSingle), for: .touchUpInside)
        addSubview(singleButton)
        singleButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalToSuperview().dividedBy(2).offset(-15)
            make.top.equalTo(2 * btnW + 30)
            make.height.equalTo(30)
        }
        
        tenButton = UIButton()
        tenButton.setTitle(NSLocalizedString("十连", comment: "模拟抽卡页面"), for: .normal)
        tenButton.backgroundColor = Color.cute
        tenButton.addTarget(self, action: #selector(clickTen), for: .touchUpInside)
        addSubview(tenButton)
        tenButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalToSuperview().dividedBy(2).offset(-15)
            make.top.equalTo(2 * btnW + 30)
            make.height.equalTo(30)
        }
        
        resultView = UIView()
        addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
            make.width.equalTo(btnW * 5 + 40)
            make.height.equalTo(2 * btnW + 10)
        }
        
        descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.darkGray
        descLabel.numberOfLines = 0
        descLabel.text = NSLocalizedString("* 每张卡片的获取几率和官方公布数据一致", comment: "模拟抽卡页面")
        descLabel.sizeToFit()
        addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
            make.top.equalTo(singleButton.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        self.backgroundColor = Color.cool.withAlphaComponent(0.1)
    }
    
    func clickTen() {
        delegate?.tenGacha(gachaSimulateView: self)
    }
    
    func clickSingle(){
        delegate?.singleGacha(gachaSimulateView: self)
    }
    
    func wipeResultView() {
        for subview in resultView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func setupResultView(cardIds: [Int]) {
        wipeResultView()
        for i in 0..<cardIds.count {
            let x = CGFloat(i % 5) * (space + btnW)
            let y = CGFloat(i / 5) * (btnW + space)
            let btn = CGSSCardIconView.init(frame: CGRect.init(x: x, y: y, width: btnW, height: btnW))
            btn.setWithCardId(cardIds[i], target: self, action: #selector(iconClick(iv:)))
            if let card = CGSSDAO.shared.findCardById(cardIds[i]), card.rarityType == .ssr {
                let view = UIView.init(frame: btn.frame)
                view.isUserInteractionEnabled = false
                view.addGlowAnimateAlongBorder(clockwise: true, imageName: "star", count: 3, cornerRadius: btn.fheight / 8)
                resultView.addSubview(view)
                view.tintColor = card.attColor
            }
            resultView.addSubview(btn)
            resultView.sendSubview(toBack: btn)
        }
    }
    
    func iconClick(iv: CGSSCardIconView) {
        delegate?.gachaSimulateView(self, didClick: iv)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

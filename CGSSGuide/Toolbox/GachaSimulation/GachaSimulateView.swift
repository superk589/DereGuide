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
    let btnW = (CGSSGlobal.width - 60) / 5
    var singleButton : UIButton!
    var tenButton: UIButton!
    var resultView: UIView!
    var descLabel: UILabel!
    weak var delegate: GachaSimulateViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawSectionLine(0)
        singleButton = UIButton.init(frame: CGRect.init(x: space, y: 2 * btnW + space * 3, width: CGSSGlobal.width / 2 - space - space / 2, height: 30))
        singleButton.setTitle(NSLocalizedString("单抽", comment: "模拟抽卡页面"), for: .normal)
        singleButton.backgroundColor = Color.passion
        singleButton.addTarget(self, action: #selector(clickSingle), for: .touchUpInside)
        
        tenButton = UIButton.init(frame: CGRect.init(x: CGSSGlobal.width / 2 + space / 2, y: 2 * btnW + space * 3, width: CGSSGlobal.width / 2 - space - space / 2, height: 30))
        tenButton.setTitle(NSLocalizedString("十连", comment: "模拟抽卡页面"), for: .normal)
        tenButton.backgroundColor = Color.cute
        tenButton.addTarget(self, action: #selector(clickTen), for: .touchUpInside)
        
        resultView = UIView.init(frame: CGRect.init(x: space, y: 10, width: CGSSGlobal.width - 2 * space, height: 2 * btnW + space ))
        
        descLabel = UILabel.init(frame: CGRect(x: space, y: singleButton.fy + singleButton.fheight + space, width: CGSSGlobal.width - 2 * space, height: 60))
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.darkGray
        descLabel.numberOfLines = 0
        descLabel.text = NSLocalizedString("* 每张卡片的获取几率和官方公布数据一致", comment: "模拟抽卡页面")
        //descLabel.isHidden = true
        descLabel.sizeToFit()
        
        
        self.addSubview(singleButton)
        self.addSubview(tenButton)
        self.addSubview(resultView)
        self.addSubview(descLabel)
        drawSectionLine(descLabel.fy + descLabel.fheight + space - 1 / Screen.scale)
        self.fheight = descLabel.fy + descLabel.fheight + space
        //self.fheight = tenButton.fbottom + space
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

    
    func setupResultView(cardIds:[Int]) {
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
        //descLabel.isHidden = false
    }
    
    func iconClick(iv:CGSSCardIconView) {
        delegate?.gachaSimulateView(self, didClick: iv)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

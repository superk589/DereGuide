//
//  GachaSimulateView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
protocol GachaSimulateViewDelegate: class {
    func singleGacha()
    func tenGacha()
    func iconClick(iv:CGSSCardIconView)
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
        singleButton = UIButton.init(frame: CGRect.init(x: space, y: 10, width: CGSSGlobal.width / 2 - space - space / 2, height: 30))
        singleButton.setTitle("单抽", for: .normal)
        singleButton.backgroundColor = CGSSGlobal.passionColor
        singleButton.addTarget(self, action: #selector(clickSingle), for: .touchUpInside)
        
        tenButton = UIButton.init(frame: CGRect.init(x: CGSSGlobal.width / 2 + space / 2, y: 10, width: CGSSGlobal.width / 2 - space - space / 2, height: 30))
        tenButton.setTitle("十连", for: .normal)
        tenButton.backgroundColor = CGSSGlobal.cuteColor
        tenButton.addTarget(self, action: #selector(clickTen), for: .touchUpInside)
        
        resultView = UIView.init(frame: CGRect.init(x: space, y: 50, width: CGSSGlobal.width - 2 * space, height: 2 * btnW + space ))
        
        descLabel = UILabel.init(frame: CGRect(x: space, y: resultView.fy + resultView.fheight + space, width: CGSSGlobal.width - 2 * space, height: 60))
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.darkGray
        descLabel.numberOfLines = 0
        descLabel.text = "* 当期新SSR占全部SSR的40%\n* 未计算当期新SR、R的概率提高因素"
        descLabel.isHidden = true
        descLabel.sizeToFit()
        
        
        self.addSubview(singleButton)
        self.addSubview(tenButton)
        self.addSubview(resultView)
        self.addSubview(descLabel)
        self.fheight = descLabel.fy + descLabel.fheight
    }
    
    func clickTen() {
        delegate?.tenGacha()
    }
    
    func clickSingle(){
        delegate?.singleGacha()
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
            if let card = CGSSDAO.sharedDAO.findCardById(cardIds[i]), card.rarityFilterType == .ssr {
                let view = UIView.init(frame: btn.frame)
                view.isUserInteractionEnabled = false
                view.addGlowAnimateAlongBorder(clockwise: true, imageName: "star", count: 3, cornerRadius: btn.fheight / 8)
                resultView.addSubview(view)
                view.tintColor = card.attColor
            }
            resultView.addSubview(btn)
            resultView.sendSubview(toBack: btn)
        }
        descLabel.isHidden = false
    }
    
    func iconClick(iv:CGSSCardIconView) {
        delegate?.iconClick(iv: iv)
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

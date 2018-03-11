//
//  GachaSimulatorView.swift
//  DereGuide
//
//  Created by zzk on 2016/9/15.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

protocol GachaSimulatorViewDelegate: class {
    func singleGacha(gachaSimulatorView: GachaSimulatorView)
    func tenGacha(gachaSimulatorView: GachaSimulatorView)
    func gachaSimulateView(_ gachaSimulatorView: GachaSimulatorView, didClick cardIcon:CGSSCardIconView)
    func resetResult(gachaSimulatorView: GachaSimulatorView)
}

class GachaSimulatorView: UIView {
    
    let space: CGFloat = 10
    lazy var btnW = min(96, ((UIApplication.shared.keyWindow?.shortSide ?? 0) - 60) / 5)
    var leftLabel: UILabel!
    let singleButton = WideButton()
    let tenButton = WideButton()
    var resultView: UIView!
    var resultGrid: GridLabel!
    let resetButton = WideButton()

    weak var delegate: GachaSimulatorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.text = NSLocalizedString("模拟抽卡", comment: "")
        addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        singleButton.setTitle(NSLocalizedString("单抽", comment: "模拟抽卡页面"), for: .normal)
        singleButton.backgroundColor = Color.passion
        singleButton.addTarget(self, action: #selector(clickSingle), for: .touchUpInside)
        addSubview(singleButton)
        singleButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalToSuperview().dividedBy(2).offset(-15)
            make.top.equalTo(leftLabel.snp.bottom).offset(2 * btnW + 30)
        }
        
        tenButton.setTitle(NSLocalizedString("十连", comment: "模拟抽卡页面"), for: .normal)
        tenButton.backgroundColor = Color.cute
        tenButton.addTarget(self, action: #selector(clickTen), for: .touchUpInside)
        addSubview(tenButton)
        tenButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalToSuperview().dividedBy(2).offset(-15)
            make.top.equalTo(singleButton)
        }
        
        resultView = UIView()
        addSubview(resultView)
        resultView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(leftLabel.snp.bottom).offset(10)
            make.width.equalTo(btnW * 5 + 40)
            make.height.equalTo(2 * btnW + 10)
        }
        
        resultGrid = GridLabel(rows: 4, columns: 4)
        addSubview(resultGrid)
        resultGrid.snp.makeConstraints { (make) in
            make.top.equalTo(tenButton.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        resetButton.setTitle(NSLocalizedString("重置", comment: "模拟抽卡页面"), for: .normal)
        resetButton.backgroundColor = .cool
        resetButton.addTarget(self, action: #selector(clickReset), for: .touchUpInside)
        addSubview(resetButton)
        resetButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(resultGrid.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
        }
        
        resultGrid.setContents([[NSLocalizedString("抽卡次数", comment: ""), "SSR", "SR", "R"],
                                ["", "", "", ""],
                                [NSLocalizedString("星星数", comment: ""), "SSR \(NSLocalizedString("占比", comment: ""))", "SR \(NSLocalizedString("占比", comment: ""))", "R \(NSLocalizedString("占比", comment: ""))"],
                                ["", "", "", ""]])
                
        backgroundColor = Color.cool.mixed(withColor: .white, weight: 0.9)
    }
    
    @objc private func clickTen() {
        delegate?.tenGacha(gachaSimulatorView: self)
    }
    
    @objc private func clickSingle() {
        delegate?.singleGacha(gachaSimulatorView: self)
    }
    
    @objc private func clickReset() {
        delegate?.resetResult(gachaSimulatorView: self)
    }
    
    func wipeResultView() {
        for subview in resultView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func wipeResultGrid() {
        resultGrid[1, 0].text = ""
        resultGrid[1, 1].text = ""
        resultGrid[1, 2].text = ""
        resultGrid[1, 3].text = ""
        resultGrid[3, 0].text = ""
        resultGrid[3, 1].text = ""
        resultGrid[3, 2].text = ""
        resultGrid[3, 3].text = ""
    }
    
    func setup(cardIDs: [Int], result: GachaSimulationResult) {
        wipeResultView()
        guard result.times > 0 else { return }
        for i in 0..<cardIDs.count {
            let x = CGFloat(i % 5) * (space + btnW)
            let y = CGFloat(i / 5) * (btnW + space)
            let btn = CGSSCardIconView.init(frame: CGRect.init(x: x, y: y, width: btnW, height: btnW))
            btn.setWithCardId(cardIDs[i], target: self, action: #selector(iconClick(iv:)))
            if let card = CGSSDAO.shared.findCardById(cardIDs[i]), card.rarityType == .ssr {
                let view = UIView.init(frame: btn.frame)
                view.isUserInteractionEnabled = false
                view.addGlowAnimateAlongBorder(clockwise: true, imageName: "star", count: 3, cornerRadius: btn.fheight / 8)
                resultView.addSubview(view)
                view.tintColor = card.attColor
            }
            resultView.addSubview(btn)
            resultView.sendSubview(toBack: btn)
        }
        
        resultGrid[1, 0].text = "\(result.times)"
        resultGrid[1, 1].text = "\(result.ssrCount)"
        resultGrid[1, 2].text = "\(result.srCount)"
        resultGrid[1, 3].text = "\(result.rCount)"
        resultGrid[3, 0].text = "\(result.jewel)"
        resultGrid[3, 1].text = String.init(format: "%.2f%%", result.ssrRate * 100)
        resultGrid[3, 2].text = String.init(format: "%.2f%%", result.srRate * 100)
        resultGrid[3, 3].text = String.init(format: "%.2f%%", result.rRate * 100)
        
    }
    
    @objc func iconClick(iv: CGSSCardIconView) {
        delegate?.gachaSimulateView(self, didClick: iv)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//
//  TeamSimulationMainBodyCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/16.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

protocol TeamSimulationMainBodyCellDelegate: class {
    
    func startCalculate(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell)
    func startSimulate(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell)
    func checkScoreDetail(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell)
    func checkSupportSkillDetail(_ teamSimulationMainBodyCell: TeamSimulationMainBodyCell)
}

class TeamSimulationMainBodyCell: UITableViewCell {

    var leftLabel: UILabel!
    
    var calculateButton: UIButton!
    
    var calculateGrid: GridLabel!
    
    var simulateButton: UIButton!
    
    var simulateGrid: GridLabel!
    
    var scoreDetailButton: UIButton!
    
    var supportSkillDetailButton: UIButton!
    
    weak var delegate: TeamSimulationMainBodyCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftLabel = UILabel()
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        
        calculateButton = UIButton()
        calculateButton.setTitle(NSLocalizedString("一般计算", comment: "队伍详情页面"), for: .normal)
        calculateButton.backgroundColor = Color.dance
        calculateButton.addTarget(self, action: #selector(startCalculate), for: .touchUpInside)
        
        contentView.addSubview(calculateButton)
        calculateButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(leftLabel.snp.bottom)
        }
        
        calculateGrid = GridLabel.init(rows: 2, columns: 4)
        contentView.addSubview(calculateGrid)
        calculateGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(calculateButton.snp.bottom).offset(10)
        }
        
        simulateButton = UIButton()
        simulateButton.setTitle(NSLocalizedString("模拟计算", comment: "队伍详情页面"), for: .normal)
        simulateButton.backgroundColor = Color.vocal
        simulateButton.addTarget(self, action: #selector(startSimulate), for: .touchUpInside)
        
        contentView.addSubview(simulateButton)
        simulateButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(calculateGrid.snp.bottom).offset(10)
        }
        
        simulateGrid = GridLabel.init(rows: 2, columns: 4)
        
        contentView.addSubview(simulateGrid)
        simulateGrid.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(calculateButton.snp.bottom).offset(10)
        }

        scoreDetailButton = UIButton()
        scoreDetailButton.setTitle("  " + NSLocalizedString("得分详情", comment: "") + " >", for: .normal)
        scoreDetailButton.backgroundColor = Color.visual
        scoreDetailButton.addTarget(self, action: #selector(checkScoreDetail), for: .touchUpInside)
        contentView.addSubview(scoreDetailButton)
        scoreDetailButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(simulateGrid.snp.bottom).offset(10)
        }
        
        supportSkillDetailButton = UIButton()
        supportSkillDetailButton.setTitle("  " + NSLocalizedString("辅助技能详情", comment: "") + " >", for: .normal)
        supportSkillDetailButton.backgroundColor = Color.visual
        supportSkillDetailButton.addTarget(self, action: #selector(checkScoreDetail), for: .touchUpInside)
        contentView.addSubview(supportSkillDetailButton)
        supportSkillDetailButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(30)
            make.top.equalTo(scoreDetailButton.snp.bottom).offset(10)
        }

    }
    
    func startCalculate() {
        delegate?.startCalculate(self)
    }
    func startSimulate() {
        delegate?.startSimulate(self)
    }
    func checkScoreDetail() {
        delegate?.checkScoreDetail(self)
    }
    func checkSupportSkillDetail() {
        delegate?.checkSupportSkillDetail(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateGrid.frame.origin = CGPoint(x: 10, y: calculateButton.fbottom + 10)
        simulateGrid.frame.origin = CGPoint(x: 10, y: simulateButton.fbottom + 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

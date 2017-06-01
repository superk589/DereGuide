//
//  TeamInformationLeaderSkillCell.swift
//  CGSSGuide
//
//  Created by zzk on 2017/5/20.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class TeamInformationLeaderSkillCell: UITableViewCell {

    var leftLabel: UILabel!
    
    var leaderGrid: GridLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        leftLabel = UILabel()
        leftLabel.text = NSLocalizedString("队长加成", comment: "队伍详情页面") + ": "
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        leftLabel.textAlignment = .left
        
        leaderGrid = GridLabel(rows: 4, columns: 6)
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(leaderGrid)
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        leaderGrid.snp.makeConstraints { (make) in
            make.top.equalTo(leftLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with team: CGSSTeam) {
        var upValueStrings = [[String]]()
        
        let contents = team.getLeaderSkillUpContentBy(simulatorType: .normal)
        upValueStrings.append(["  ", "Vocal", "Dance", "Visual", NSLocalizedString("技能触发", comment: "队伍详情页面"), "HP"])
        
        var upCuteString = [String]()
        upCuteString.append("Cu")
        if let cute = contents[.cute] {
            if let vocal = cute[.vocal] {
                upCuteString.append("+\(vocal)%")
            } else {
                upCuteString.append("")
            }
            if let dance = cute[.dance] {
                upCuteString.append("+\(dance)%")
            } else {
                upCuteString.append("")
            }
            if let visual = cute[.visual] {
                upCuteString.append("+\(visual)%")
            } else {
                upCuteString.append("")
            }
            if let proc = cute[.proc] {
                upCuteString.append("+\(proc)%")
            } else {
                upCuteString.append("")
            }
            if let life = cute[.life] {
                upCuteString.append("+\(life)%")
            } else {
                upCuteString.append("")
            }
        } else {
            upCuteString.append(contentsOf: [String].init(repeating: "", count: 5))
        }
        
        var upCoolString = [String]()
        upCoolString.append("Co")
        if let cool = contents[.cool] {
            if let vocal = cool[.vocal] {
                upCoolString.append("+\(vocal)%")
            } else {
                upCoolString.append("")
            }
            if let dance = cool[.dance] {
                upCoolString.append("+\(dance)%")
            } else {
                upCoolString.append("")
            }
            if let visual = cool[.visual] {
                upCoolString.append("+\(visual)%")
            } else {
                upCoolString.append("")
            }
            if let proc = cool[.proc] {
                upCoolString.append("+\(proc)%")
            } else {
                upCoolString.append("")
            }
            if let life = cool[.life] {
                upCoolString.append("+\(life)%")
            } else {
                upCoolString.append("")
            }
        } else {
            upCoolString.append(contentsOf: [String].init(repeating: "", count: 5))
        }
        
        
        var upPassionString = [String]()
        upPassionString.append("Pa")
        if let passion = contents[.passion] {
            if let vocal = passion[.vocal] {
                upPassionString.append("+\(vocal)%")
            } else {
                upPassionString.append("")
            }
            if let dance = passion[.dance] {
                upPassionString.append("+\(dance)%")
            } else {
                upPassionString.append("")
            }
            if let visual = passion[.visual] {
                upPassionString.append("+\(visual)%")
            } else {
                upPassionString.append("")
            }
            if let proc = passion[.proc] {
                upPassionString.append("+\(proc)%")
            } else {
                upPassionString.append("")
            }
            if let life = passion[.life] {
                upPassionString.append("+\(life)%")
            } else {
                upPassionString.append("")
            }
        } else {
            upPassionString.append(contentsOf: [String].init(repeating: "", count: 5))
        }
        
        
        upValueStrings.append(upCuteString)
        upValueStrings.append(upCoolString)
        upValueStrings.append(upPassionString)
        
        var upValueColors = [[UIColor]]()
        let colorArray = [UIColor.black, Color.vocal, Color.dance, Color.visual, UIColor.darkGray, Color.life]
        upValueColors.append(contentsOf: Array.init(repeating: colorArray, count: 4))
        upValueColors[1][0] = Color.cute
        upValueColors[2][0] = Color.cool
        upValueColors[3][0] = Color.passion
        
        leaderGrid.setContents(upValueStrings)
        leaderGrid.setColors(upValueColors)
        
        for i in 0..<6 {
            leaderGrid[0, i].font = CGSSGlobal.alphabetFont
        }
        for i in 0..<4 {
            leaderGrid[i, 0].font = CGSSGlobal.alphabetFont
        }
    }
}

//
//  GachaPool.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/13.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Reward {
    var cardId: String!
    var rewardRecommand: Int!
}

class GachaPool {
    
    var baseId: String!
    var costNumMulti: String!
    var costNumSingle: String!
    var dicription: String!
    var drawGuaranteeNum: String!
    var drawLimitMulti: String!
    var drawLimitSingle: String!
    var drawNum: String!
    var endDate: String!
    var extendId: String!
    var firstCostNumMulti: String!
    var firstCostNumSingle: String!
    var id: String!
    var loopNum: String!
    var maxStep: String!
    var messageId: String!
    var name: String!
    var name2: String!
    var nomalRatio: String!
    var nomalRatio2: String!
    var rareRatio: String!
    var rareRatio2: String!
    var resetTime: String!
    var source: String!
    var sourceGuarantee: String!
    var srRatio: String!
    var srRatio2: String!
    var ssrRatio: String!
    var ssrRatio2: String!
    var startDate: String!
    var step: String!
    var stepId: String!
    var type: String!
    var typeDetail: String!
    
    var rewards: [Reward]!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json == nil {
            return
        }
        baseId = json["base_id"].stringValue
        costNumMulti = json["cost_num_multi"].stringValue
        costNumSingle = json["cost_num_single"].stringValue
        dicription = json["dicription"].stringValue
        drawGuaranteeNum = json["draw_guarantee_num"].stringValue
        drawLimitMulti = json["draw_limit_multi"].stringValue
        drawLimitSingle = json["draw_limit_single"].stringValue
        drawNum = json["draw_num"].stringValue
        endDate = json["end_date"].stringValue
        extendId = json["extend_id"].stringValue
        firstCostNumMulti = json["first_cost_num_multi"].stringValue
        firstCostNumSingle = json["first_cost_num_single"].stringValue
        id = json["id"].stringValue
        loopNum = json["loop_num"].stringValue
        maxStep = json["max_step"].stringValue
        messageId = json["message_id"].stringValue
        name = json["name"].stringValue
        name2 = json["name2"].stringValue
        nomalRatio = json["nomal_ratio"].stringValue
        nomalRatio2 = json["nomal_ratio2"].stringValue
        rareRatio = json["rare_ratio"].stringValue
        rareRatio2 = json["rare_ratio2"].stringValue
        resetTime = json["reset_time"].stringValue
        
        source = json["source"].stringValue
        sourceGuarantee = json["source_guarantee"].stringValue
        srRatio = json["sr_ratio"].stringValue
        srRatio2 = json["sr_ratio2"].stringValue
        ssrRatio = json["ssr_ratio"].stringValue
        ssrRatio2 = json["ssr_ratio2"].stringValue
        startDate = json["start_date"].stringValue
        step = json["step"].stringValue
        stepId = json["step_id"].stringValue
        type = json["type"].stringValue
        typeDetail = json["type_detail"].stringValue
    }
    
}

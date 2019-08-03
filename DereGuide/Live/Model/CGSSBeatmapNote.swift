//
//  CGSSBeatmapNote.swift
//  DereGuide
//
//  Created by zzk on 21/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import Foundation
import UIKit

class CGSSBeatmapNote {
    
    // 判定范围类型(用于计算得分, 并非按键类型)
    enum RangeType: Int {
        case click
        case flick
        case slide
        static let hold = RangeType.click
    }
    
    // note 类型
    enum Style {
        enum FlickDirection {
            case left
            case right
        }
        case click
        case flick(FlickDirection)
        case slide
        case hold
        case wideClick
        case wideFlick(FlickDirection)
        case wideSlide
        
        var isWide: Bool {
            switch self {
            case .click, .flick, .hold, .slide:
                return false
            default:
                return true
            }
        }
    }
    
    var width: Int {
        switch style {
        case .click, .flick, .hold, .slide:
            return 1
        default:
            return status
        }
    }
    
    var id: Int!
    var sec: Float!
    var type: Int!
    var startPos: Int!
    var finishPos: Int!
    var status: Int!
    var sync: Int!
    var groupId: Int!
    
    // 0 no press, 1 start, 2 end
    var longPressType = 0
    // used in shifting bpm
    var offset: Float = 0
    
    // from 1 to max combo
    var comboIndex: Int = 1
    
    // context free note information, so each long press slide and filck note need to know the related note
    weak var previous: CGSSBeatmapNote?
    weak var next: CGSSBeatmapNote?
    weak var along: CGSSBeatmapNote?
}

extension CGSSBeatmapNote {
    
    func append(_ anotherNote: CGSSBeatmapNote) {
        self.next = anotherNote
        anotherNote.previous = self
    }
    
    func intervalTo(_ anotherNote: CGSSBeatmapNote) -> Float {
        return anotherNote.sec - sec
    }
    
    var offsetSecond: Float {
        return sec + offset
    }
}

extension CGSSBeatmapNote {
    
    var rangeType: RangeType {
        switch (status, type) {
        case (1, _), (2, _):
            return .flick
        case (_, 3):
            return .slide
        case (_, 2):
            return .hold
        default:
            return .click
        }
    }
    
    var style: Style {
        switch (status, type) {
        case (1, 1):
            return .flick(.left)
        case (2, 1):
            return .flick(.right)
        case (_, 2):
            return .hold
        case (_, 3):
            return .slide
        case (_, 4):
            return .wideClick
        case (_, 5):
            return .wideSlide
        case (_, 6):
            return .wideFlick(.left)
        case (_, 7):
            return .wideFlick(.right)
        default:
            return .click
        }
    }
}

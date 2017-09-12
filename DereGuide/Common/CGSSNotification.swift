//
//  CGSSNotification.swift
//  DereGuide
//
//  Created by zzk on 2017/5/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let updateEnd = Notification.Name.init("CGSS_UPDATE_END")
    static let gameResoureceProcessedEnd = Notification.Name.init("CGSS_PROCESS_END")
    static let saveEnd = Notification.Name.init("CGSS_SAVE_END")
    static let favoriteCardsChanged = Notification.Name.init("CGSS_FAVORITE_CARD_CHANGED")
    static let favoriteCharasChanged = Notification.Name.init("CGSS_FAVORITE_CHARA_CHANGED")
    static let favoriteSongsChanged = Notification.Name(rawValue: "CGSS_FAVORITE_SONG_CHANGED")
    static let dataRemoved = Notification.Name.init("CGSS_DATA_REMOVED")
    static let unitModified = Notification.Name.init("CGSS_UNIT_MODIFIED")
}

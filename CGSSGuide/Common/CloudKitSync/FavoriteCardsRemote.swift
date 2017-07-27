//
//  FavoriteCardRemote.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

final class FavoriteCardsRemote: Remote {
    
    typealias R = RemoteFavoriteCard
    typealias L = FavoriteCard
    
    static var subscriptionID: String {
        return "My Favorite Cards"
    }
}

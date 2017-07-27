//
//  FavoriteCharaRemote.swift
//  CGSSGuide
//
//  Created by zzk on 2017/7/27.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

final class FavoriteCharaRemote: Remote {
    typealias R = RemoteFavoriteChara
    typealias L = FavoriteChara
    
    static var subscriptionID: String {
        return "My Favorite Charas"
    }
}

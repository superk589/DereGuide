//
//  GalleryImageItemBaseController.swift
//  DereGuide
//
//  Created by zzk on 2017/8/29.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import ImageViewer

class GalleryImageItemBaseController: ItemBaseController<UIImageView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        itemView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        itemView.addGestureRecognizer(longPress)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let size = itemView.image?.size {
            if size.width < view.bounds.width && size.height < view.bounds.height {
                itemView.contentMode = .center
            } else {
                itemView.contentMode = .scaleAspectFit
            }
        }
    }

    @objc func handleLongPressGesture(_ longPress: UILongPressGestureRecognizer) {
        guard let image = itemView.image else {
            return
        }
        switch longPress.state {
        case .began:
            let point = longPress.location(in: itemView)
            UIActivityViewController.show(images: [image], pointTo: itemView, rect: CGRect(origin: point, size: .zero), in: self)
        default:
            break
        }
    }
}

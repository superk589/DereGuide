//
//  GachaResultCardView.swift
//  DereGuide
//
//  Created by zzk on 11/03/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class GachaResultCardView: UIView {

    let icon = CGSSCardIconView()
    let glow = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.width.equalTo(icon.snp.height)
            make.width.lessThanOrEqualTo(96 + 10)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        addSubview(glow)
        glow.snp.makeConstraints { (make) in
            make.edges.equalTo(icon)
        }
        glow.isUserInteractionEnabled = false
    }
    
    func setup(card: CGSSCard?) {
        if let card = card {
            if card.rarityType == .ssr {
                addGlow(clockwise: true, imageName: "star", count: 3)
                glow.tintColor = card.attColor
            } else {
                removeGlow()
            }
            icon.cardID = card.id
        } else {
            glow.removeGlows()
            icon.cardID = nil
        }
    }
    
    private var glowLayers = [CALayer]()
    private var animating = false
    func addGlow(clockwise: Bool, imageName: String, count: Int) {
        animating = true
        let layerName = "GLOW\(count)"
        glowLayers.removeAll()
        
        for view in glow.subviews {
            if (view.layer.name?.hasPrefix("GLOW") ?? false) {
                if view.layer.name == layerName {
                    view.removeFromSuperview()
                } else {
                    glowLayers.append(view.layer)
                }
            }
        }
        let scale = min(1, sqrt(self.bounds.size.width * self.bounds.size.height / 90))
        let missing = count - glowLayers.count
        for _ in 0..<missing {
            let imageView = UIImageView.init(image: UIImage.init(named: imageName)?.withRenderingMode(.alwaysTemplate))
            glow.addSubview(imageView)
            imageView.layer.name = layerName
            glowLayers.append(imageView.layer)
        }
        
        let movePath = UIBezierPath(roundedRect: icon.bounds, cornerRadius: icon.frame.height / 8)
        if !clockwise {
            movePath.apply(CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: self.bounds.size.width, ty: 0))
        }
        let moveAni = CAKeyframeAnimation.init(keyPath: "position")
        moveAni.path = movePath.cgPath
        moveAni.duration = 8
        moveAni.repeatCount = .infinity
        moveAni.calculationMode = "cubicPaced"
        moveAni.isRemovedOnCompletion = false
        
        let opacityAni = CABasicAnimation.init(keyPath: "opacity")
        opacityAni.fromValue = 1
        opacityAni.toValue = 0.3
        opacityAni.duration = 4
        opacityAni.repeatCount = .infinity
        opacityAni.autoreverses = true
        opacityAni.isRemovedOnCompletion = false
        
        let scaleAni = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAni.fromValue = scale * 0.6
        scaleAni.toValue = scale * 0.4
        scaleAni.duration = 4
        scaleAni.repeatCount = .infinity
        scaleAni.autoreverses = true
        scaleAni.isRemovedOnCompletion = false
        
        for i in 0..<glowLayers.count {
            let glowLayer = glowLayers[i]
            glowLayer.removeAllAnimations()
            moveAni.timeOffset = moveAni.duration / Double(count) * Double(i)
            opacityAni.timeOffset = opacityAni.duration / Double(count) * Double(i)
            scaleAni.timeOffset = scaleAni.duration / Double(count) * Double(i)
            glowLayer.add(moveAni, forKey: "move")
            glowLayer.add(opacityAni, forKey: "opacity")
            glowLayer.add(scaleAni, forKey: "scale")
        }
    }
    
    func removeGlow() {
        for view in glow.subviews {
            if (view.layer.name?.hasPrefix("GLOW") ?? false) {
                view.layer.removeAllAnimations()
                view.removeFromSuperview()
            }
        }
        animating = false
    }
    
    func layoutGlow() {
        for layer in glowLayers {
            if let move = layer.animation(forKey: "move") as? CAKeyframeAnimation {
                layer.removeAnimation(forKey: "move")
                move.path = UIBezierPath(roundedRect: icon.bounds, cornerRadius: icon.frame.height / 8).cgPath
                layer.add(move, forKey: "move")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if animating {
            removeGlow()
            addGlow(clockwise: true, imageName: "star", count: 3)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

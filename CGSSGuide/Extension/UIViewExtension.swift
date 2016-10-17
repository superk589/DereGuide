//
//  UIViewExtension.swift
//  CGSSGuide
//
//  Created by zzk on 16/8/12.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

extension UIView {
	var fwidth: CGFloat {
		get {
			return self.frame.size.width
		}
		set {
			self.frame.size.width = newValue
		}
	}
	var fheight: CGFloat {
		get {
			return self.frame.size.height
		}
		set {
			self.frame.size.height = newValue
		}
	}
	var fy: CGFloat {
		get {
			return self.frame.origin.y
		}
		set {
			self.frame.origin.y = newValue
		}
	}
	var fx: CGFloat {
		get {
			return self.frame.origin.x
		}
		set {
			self.frame.origin.x = newValue
		}
	}
    
    var fbottom: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    var fright: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    func drawSectionLine(_ positionY: CGFloat) {
        let view = UIView.init(frame: CGRect(x: 0, y: positionY, width: CGSSGlobal.width, height: 1 / UIScreen.main.scale))
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.addSubview(view)
    }
    
    func removeGlows() {
        for view in self.subviews {
            if (view.layer.name?.hasPrefix("GLOW") ?? false) {
                view.layer.removeAllAnimations()
                view.removeFromSuperview()
            }
        }
    }

    
    // 边缘星星环绕效果
    func addGlowAnimateAlongBorder(clockwise:Bool, imageName:String, count:Int, cornerRadius: CGFloat) {
        let layerName = "GLOW\(count)"
        var glowLayers = [CALayer]()
        
        for view in self.subviews {
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
            let glow = UIImageView.init(image: UIImage.init(named: imageName)?.withRenderingMode(.alwaysTemplate))
            self.addSubview(glow)
            glow.layer.name = layerName
            glowLayers.append(glow.layer)
        }

        let movePath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius)
        if !clockwise {
            movePath.apply(CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: self.bounds.size.width, ty: 0))
        }
        let moveAni = CAKeyframeAnimation.init(keyPath: "position")
        moveAni.path = movePath.cgPath
        moveAni.duration = 8
        moveAni.repeatCount = 1e50
        moveAni.calculationMode = "cubicPaced"
        moveAni.isRemovedOnCompletion = false

        let opacityAni = CABasicAnimation.init(keyPath: "opacity")
        opacityAni.fromValue = 1
        opacityAni.toValue = 0.3
        opacityAni.duration = 4
        opacityAni.repeatCount = 1e50
        opacityAni.autoreverses = true
        opacityAni.isRemovedOnCompletion = false
        
        let scaleAni = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAni.fromValue = scale * 0.6
        scaleAni.toValue = scale * 0.4
        scaleAni.duration = 4
        scaleAni.repeatCount = 1e50
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
}

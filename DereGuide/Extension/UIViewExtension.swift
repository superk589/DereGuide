//
//  UIViewExtension.swift
//  DereGuide
//
//  Created by zzk on 16/8/12.
//  Copyright © 2016 zzk. All rights reserved.
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
    
    var shortSide: CGFloat {
        return frame.size.shortSide
    }
    
    var longSide: CGFloat {
        return frame.size.longSide
    }

}

extension CGSize {
    
    var shortSide: CGFloat {
        return min(height, width)
    }
    
    var longSide: CGFloat {
        return max(height, width)
    }
}

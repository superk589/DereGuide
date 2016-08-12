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
}

//
//  CGSSImageView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class CGSSImageView: UIImageView {

    var isTapped:Bool
    //为了两次点击之后能恢复到原始大小 需要保存原始frame
    var originFrame:CGRect!

    override init(frame: CGRect) {
        self.isTapped = false
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        self.contentMode = .ScaleAspectFit

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 2
        self.addGestureRecognizer(longPress)
        self.originFrame = self.frame
        //全屏时背景色为黑色
        self.backgroundColor = UIColor.blackColor()
    }
    
    
    func tapAction() {
        if !isTapped {
            //let sv = self.superview as! UIScrollView
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(fullsized), userInfo: nil, repeats: false)
             //动画过程中禁掉点击动作,3秒后开启
            self.userInteractionEnabled = false
            UIView.animateWithDuration(0.3) {
                self.transform = CGAffineTransformRotate(self.transform, CGFloat(90/180*M_PI))
                self.frame.size.width = CGSSTool.width
                self.frame.size.height = CGSSTool.height
                //self.center = CGPointMake(CGSSTool.width/2, (CGSSTool.width/self.originFrame.size.height*self.originFrame.size.width)/2)
                self.center = CGPointMake(CGSSTool.width/2, CGSSTool.height/2)
            }
            self.superview?.bringSubviewToFront(self)
            CGSSNotificationCenter.post("IMAGE_FULLSIZE_START", object: self)
           // (self.superview as! UIScrollView).scrollEnabled = false
            isTapped = true
            //self.superview.
        }
        else {
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(restored), userInfo: nil, repeats: false)
            self.userInteractionEnabled = false
            UIView.animateWithDuration(0.3) {
                self.transform = CGAffineTransformRotate(self.transform, CGFloat(-90/180*M_PI))
                self.frame = self.originFrame
            }
            CGSSNotificationCenter.post("IMAGE_RESTORE_START", object: self)
            isTapped = false
        }

    }
    
   
    //恢复完成
    func restored() {
        self.userInteractionEnabled = true
        CGSSNotificationCenter.post("IMAGE_RESTORE_END", object: self)
    }
    
    //完成全屏化
    func fullsized() {
        self.userInteractionEnabled = true
        CGSSNotificationCenter.post("IMAGE_FULLSIZE_END", object: self)
    }
    
    func longPressAction(longPress:UILongPressGestureRecognizer) {
        //长按手势会触发两次 此处判定是长按开始而非结束
        if isTapped && longPress.state == .Began {
            CGSSNotificationCenter.post("IMAGE_LONG_PRESS", object: self)
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

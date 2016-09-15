//
//  CGSSImageView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/7.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import SDWebImage
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


protocol CGSSImageViewDelegate: class {
    func beginFullSize(_ iv: CGSSImageView)
    func beginRestore(_ iv: CGSSImageView)
    func endRestore(_ iv: CGSSImageView)
    func endFullSize(_ iv: CGSSImageView)
    func longPress(_ press: UILongPressGestureRecognizer, iv: CGSSImageView)
}
//CGSSImageView可以实现点击放大至全屏 再次点击缩小为原大小并归位 全屏状态下长按可以保存到相册
class CGSSImageView: UIImageView {
    
    weak var delegate: CGSSImageViewDelegate?
    var isTapped: Bool
    // 为了两次点击之后能恢复到原始大小 需要保存原始frame
    var originFrame: CGRect!
    var progressIndicator: UIProgressView?
    var activityIndicator: UIActivityIndicatorView?
    // var retryButton:UIButton?
    var isFinishedLoading: Bool = false
    // var isFailed = false
    // var retry:(()->Void)?
    
    override init(frame: CGRect) {
        self.isTapped = false
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
        self.contentMode = .scaleAspectFit
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        longPress.minimumPressDuration = 1
        self.addGestureRecognizer(longPress)
        self.originFrame = self.frame
        // 全屏时背景色为黑色
        self.backgroundColor = UIColor.black
        setIndicator()
        hideIndicator()
    }
    
    func setIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = self.center
        activityIndicator?.hidesWhenStopped = true
        
        progressIndicator = UIProgressView()
        progressIndicator?.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 0)
        
//        retryButton = UIButton()
//        retryButton?.setTitle("加载失败 请点击重试", forState: .Normal)
//        retryButton?.frame = CGRectMake(0, 0, 120, 20)
//        retryButton?.hidden = true
//        retryButton?.addTarget(self, action: #selector(retryAction), forControlEvents: .TouchUpInside)
        
        addSubview(activityIndicator!)
        addSubview(progressIndicator!)
        // addSubview(retryButton!)
        
//        activityIndicator?.snp_makeConstraints(closure: { (make) in
//            make.centerWithinMargins.equalTo(self)
//        })
//        progressIndicator?.snp_makeConstraints(closure: { (make) in
//            make.bottomMargin.equalTo(self)
//        })
        
//        addConstraint(NSLayoutConstraint.init(item: activityIndicator!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
//        addConstraint(NSLayoutConstraint.init(item: activityIndicator!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
    }
    func hideIndicator() {
        progressIndicator?.isHidden = true
        activityIndicator?.isHidden = true
        // retryButton?.hidden = true
    }
    func showIndicator() {
        if progressIndicator?.progress < 1 && !isFinishedLoading {
            progressIndicator?.isHidden = false
        }
        if let x = activityIndicator?.isAnimating , x {
            activityIndicator?.isHidden = false
        }
//        if isFailed {
//            retryButton?.hidden = false
//        }
    }
//    func setRetryAction(callBack:(()->Void)) {
//        self.retry = callBack
//    }
//    func retryAction() {
//        retry?()
//    }
    func setCustomImageWithURL(_ url: URL) {
        if !UserDefaults.standard.shouldCacheFullImage && CGSSGlobal.isMobileNet() && !SDWebImageManager.shared().cachedImageExists(for: url) {
            return
        }
        
        self.reset()
        self.activityIndicator?.startAnimating()
        self.showIndicator()
        self.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.init(rawValue: 0b1001), progress: { [weak self](a, b) in
            // print(a, b)
            self?.progressIndicator?.progress = Float(a) / Float(b)
            }, completed: { [weak self](image, error, sdImageCache, nsurl) in
            /*if error != nil {
             // print("加载大图时出错:\(error.localizedDescription)")
             }
             else {

             }*/
            self?.progressIndicator?.progress = 1
            self?.isFinishedLoading = true
            self?.activityIndicator?.stopAnimating()
            self?.hideIndicator()
            }
        )
        
    }
    
    func reset() {
        self.isFinishedLoading = false
        self.progressIndicator?.progress = 0
    }
    
    func tapAction() {
        if !isTapped {
            // let sv = self.superview as! UIScrollView
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(fullsized), userInfo: nil, repeats: false)
            // 动画过程中禁掉点击动作,0.3秒后开启
            hideIndicator()
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = self.transform.rotated(by: CGFloat(90 / 180 * M_PI))
                self.frame.size.width = CGSSGlobal.width
                self.frame.size.height = CGSSGlobal.height
                // self.center = CGPointMake(CGSSGlobal.width/2, (CGSSGlobal.width/self.originFrame.size.height*self.originFrame.size.width)/2)
                self.center = CGPoint(x: CGSSGlobal.width / 2, y: CGSSGlobal.height / 2)
            }) 
            self.superview?.bringSubview(toFront: self)
            delegate?.beginFullSize(self)
            isTapped = true
        }
        else {
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(restored), userInfo: nil, repeats: false)
            self.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = self.transform.rotated(by: CGFloat(-90 / 180 * M_PI))
                self.frame = self.originFrame
            }) 
            delegate?.beginRestore(self)
            isTapped = false
        }
        
    }
    
    // 恢复完成
    func restored() {
        self.isUserInteractionEnabled = true
        showIndicator()
        delegate?.endRestore(self)
    }
    
    // 完成全屏化
    func fullsized() {
        self.isUserInteractionEnabled = true
        delegate?.endFullSize(self)
    }
    
    func longPressAction(_ longPress: UILongPressGestureRecognizer) {
        // 长按手势会触发两次 此处判定是长按开始而非结束
        if isTapped && longPress.state == .began {
            delegate?.longPress(longPress, iv: self)
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

//
//  TeamMemberEditingView.swift
//  CGSSGuide
//
//  Created by zzk on 2016/9/18.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit
import ASValueTrackingSlider


class CGSSSliderView: UIView, ASValueTrackingSliderDelegate {
    
    var descLabel : UILabel!
    var numLabel: UILabel!
    var slider: ASValueTrackingSlider!
    
    
    private let space:CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        descLabel = UILabel.init(frame: CGRect(x: space, y: fheight * 0.75 - fheight / 8, width: 30, height: fheight / 4))
        descLabel.font = UIFont.systemFont(ofSize: 16)
        descLabel.textAlignment = .center
    
        numLabel = UILabel.init(frame: CGRect(x: space, y: fheight * 0.75 + fheight / 8, width: 30, height: fheight / 4))
        numLabel.font = UIFont.systemFont(ofSize: 14)
        numLabel.textAlignment = .center
        
        slider = ASValueTrackingSlider.init(frame: CGRect(x: space + 35, y: fheight * 0.75 , width: fwidth - 35 - 2 * space, height: fheight / 4))
//        let nf = NumberFormatter()
//        nf.numberStyle = .none
//        slider.numberFormatter = nf
        
        self.slider.textColor = UIColor.white
        self.slider.popUpViewCornerRadius = self.fheight / 4
        self.slider.setMaxFractionDigitsDisplayed(0)
        self.slider.delegate = self
        addSubview(descLabel)
        addSubview(slider)
        addSubview(numLabel)
        
        
    }
    
    func sliderDidHidePopUpView(_ slider: ASValueTrackingSlider!) {
        self.numLabel.text = String(Int(round(self.slider.value)))
    }
    func sliderWillDisplayPopUpView(_ slider: ASValueTrackingSlider!) {
        //
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TeamMemberEditingView: UIView {

    var skillItem: CGSSSliderView!
    var vocalItem: CGSSSliderView!
    var danceItem: CGSSSliderView!
    var visualItem: CGSSSliderView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    func prepare() {
        let space:CGFloat = 10
        let height = (fheight - 6 * space) / 4
        skillItem = CGSSSliderView.init(frame: CGRect(x: 0, y: space, width: fwidth, height: height))
        skillItem.slider.maximumValue = 10
        skillItem.slider.minimumValue = 1
        skillItem.slider.value = 10
        skillItem.slider.popUpViewColor = CGSSGlobal.allTypeColor
        skillItem.descLabel.text = "SLv."
        skillItem.numLabel.textColor = CGSSGlobal.allTypeColor
        
        vocalItem = CGSSSliderView.init(frame: CGRect(x: 0, y: space * 2 + height, width: fwidth, height: height))
        vocalItem.slider.maximumValue = 10
        vocalItem.slider.minimumValue = 0
        vocalItem.slider.value = 0
        vocalItem.slider.popUpViewColor = CGSSGlobal.vocalColor
        vocalItem.descLabel.text = "Vo+"
        vocalItem.numLabel.textColor = CGSSGlobal.vocalColor
        
        danceItem = CGSSSliderView.init(frame: CGRect(x: 0, y: space * 3 + height * 2, width: self.fwidth, height: height))
        danceItem.slider.maximumValue = 10
        danceItem.slider.minimumValue = 0
        danceItem.slider.value = 0
        danceItem.slider.popUpViewColor = CGSSGlobal.danceColor
        danceItem.descLabel.text = "Da+"
        danceItem.numLabel.textColor = CGSSGlobal.danceColor
        
        visualItem = CGSSSliderView.init(frame: CGRect(x: 0, y: space * 4 + height * 3, width: self.fwidth, height: height))
        visualItem.slider.maximumValue = 10
        visualItem.slider.minimumValue = 0
        visualItem.slider.value = 0
        visualItem.slider.popUpViewColor = CGSSGlobal.visualColor
        visualItem.descLabel.text = "Vi+"
        visualItem.numLabel.textColor = CGSSGlobal.visualColor
        
        addSubview(skillItem)
        addSubview(vocalItem)
        addSubview(danceItem)
        addSubview(visualItem)
        
    }
    
    func setupWith(model:CGSSTeamMember) {
        skillItem.slider.value = Float(model.skillLevel!)
        skillItem.numLabel.text = String(model.skillLevel!)
        
        vocalItem.slider.value = Float(model.vocalLevel!)
        vocalItem.numLabel.text = String(model.vocalLevel!)
        
        danceItem.slider.value = Float(model.danceLevel!)
        danceItem.numLabel.text = String(model.danceLevel!)
        
        visualItem.slider.value = Float(model.visualLevel!)
        visualItem.numLabel.text = String(model.visualLevel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  BeatmapView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BeatmapView: UIScrollView , UIScrollViewDelegate {

    static let widthInsect:CGFloat = 60
    static let sectionHeight:CGFloat = 250
    static let heightInsect:CGFloat = 60
    
    var beatmap:CGSSBeatmap!
    var notes:[CGSSBeatmap.Note]!
    var bpm:Int!
    var interval: CGFloat {
        return (CGSSTool.width - 2 * BeatmapView.widthInsect ) / 4
    }
    
    var secScale: CGFloat {
        return BeatmapView.sectionHeight * (CGFloat(bpm) / 60 / 4)
    }
    
    
    var strokeColor:UIColor!
    
    private var lineWidth: CGFloat = 1
    func getPointX(position:Int) -> CGFloat {
        return BeatmapView.widthInsect + interval * (CGFloat(position) - 1)
    }
    
    func getPointY(sec:Float) -> CGFloat {
        return contentSize.height - CGFloat(sec - self.beatmap.preSeconds!) * secScale - BeatmapView.heightInsect
    }
    
    override func drawRect(rect: CGRect) {
        //画点
        strokeColor.set()
        for note in notes {
            if note.finishPos != 0  {
                let path = pathForPoint(note.finishPos!, sec: note.sec!)
                path.stroke()
                path.fill()

            }
        }
        
        //画小节线
        UIColor.darkGrayColor().set()
        for i in 0...Int(secScale * CGFloat(beatmap.validSeconds) / BeatmapView.sectionHeight) {
            let path = pathForSectionLine(contentSize.height - BeatmapView.heightInsect - CGFloat(i) * BeatmapView.sectionHeight)
            path.stroke()
        }
    }
    
    func initWith(beatmap:CGSSBeatmap, bpm:Int, type:Int) {
        self.beatmap = beatmap
        self.notes = beatmap.notes
        self.bpm = bpm
        switch type {
        case 1:
            self.strokeColor = CGSSTool.cuteColor
        case 2:
            self.strokeColor = CGSSTool.coolColor
        case 3:
            self.strokeColor = CGSSTool.passionColor
        case 4:
            self.strokeColor = UIColor.darkTextColor()
        default:
            break
        }
        self.backgroundColor = UIColor.clearColor()
        self.contentSize = CGSizeMake(CGSSTool.width, secScale * CGFloat(beatmap.validSeconds) + 2 * BeatmapView.heightInsect)
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height)
        self.delegate = self
    }

    private func pathForPoint(position:Int, sec:Float) -> UIBezierPath
    {
        let radius: CGFloat = 8
        let center = CGPointMake(getPointX(position), getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    
    private func pathForSectionLine(positionY:CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: positionY))
        path.addLineToPoint(CGPoint(x: CGSSTool.width, y: positionY))
        path.lineWidth = lineWidth
        return path
    }

    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: scrollView的代理方法
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        setNeedsDisplay()
    }

}


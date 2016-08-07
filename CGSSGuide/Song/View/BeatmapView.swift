//
//  BeatmapView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BeatmapView: UIScrollView , UIScrollViewDelegate {

    static let widthInset:CGFloat = 100
    static let sectionHeight:CGFloat = 245
    static let heightInset:CGFloat = 60
    static let noteRadius:CGFloat = 7
    
    var beatmap:CGSSBeatmap!
    var notes:[CGSSBeatmap.Note]!
    var bpm:Int!
    var interval: CGFloat {
        return (CGSSTool.width - 2 * BeatmapView.widthInset ) / 4
    }
    
    var secScale: CGFloat {
        return BeatmapView.sectionHeight * (CGFloat(bpm) / 60 / 4)
    }
    
    
    var strokeColor:UIColor!
    
    private var lineWidth: CGFloat = 1
    func getPointX(position:Int) -> CGFloat {
        return BeatmapView.widthInset + interval * (CGFloat(position) - 1)
    }
    
    func getPointY(sec:Float) -> CGFloat {
        return contentSize.height - CGFloat(sec - self.beatmap.preSeconds!) * secScale - BeatmapView.heightInset
    }
    
    
    override func drawRect(rect: CGRect) {

        //画小节线
        let halfquadSectionMax = Int(((contentSize.height - rect.origin.y - BeatmapView.heightInset) / BeatmapView.sectionHeight * 8))
        let halfquadSectionMin = Int(((contentSize.height - frame.size.height - rect.origin.y - BeatmapView.heightInset) / BeatmapView.sectionHeight * 8))
        for i in halfquadSectionMin...halfquadSectionMax {
            let pointY = contentSize.height - BeatmapView.heightInset - CGFloat(i) * BeatmapView.sectionHeight / 8
            if i % 8 == 0 {
                UIColor.darkGrayColor().set()
                let sectionNumber:NSString = NSString.init(format: "%03d", i / 8)
                let attDict = [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.darkGrayColor()]
                sectionNumber.drawAtPoint(CGPointMake(25, pointY-7), withAttributes: attDict )
                let comboNumber:NSString = NSString.init(format: "%d", beatmap.comboForSec(Float(i / 8) / (Float(bpm) / 60 / 4)))
                comboNumber.drawAtPoint(CGPointMake(CGSSTool.width - 46, pointY-7), withAttributes: attDict)
            }
            else if i % 2 == 0 { UIColor.lightGrayColor().set() }
            else { UIColor.lightGrayColor().colorWithAlphaComponent(0.5).set() }
            let path = pathForSectionLine(pointY)
            path.stroke()
        }
        
        //画点
        var positionPressed = [Float].init(count: 5, repeatedValue: 0)
        typealias Note = CGSSBeatmap.Note
        var sliders = [Int: Note]()
        for note in notes {
            if note.finishPos != 0  {
                let pointY = getPointY(note.sec!)
                //未到达显示区域时 continue
                if pointY > rect.origin.y + rect.size.height {
                    if note.type == 2 {
                        if positionPressed[note.finishPos!-1] == 0 {
                            positionPressed[note.finishPos!-1] = note.sec!
                        } else {
                            positionPressed[note.finishPos!-1] = 0
                        }
                    }
                    if note.status > 0 && positionPressed[note.finishPos!-1] != 0 {
                        positionPressed[note.finishPos!-1] = 0
                    }
                    continue
                }
                //超出当前显示区域时 退出循环
                if pointY < rect.origin.y { break }
                let path = pathForPoint(note.finishPos!, sec: note.sec!)
                strokeColor.set()
                //path.stroke()
                path.fill()
                
                //简单长按类型
                if note.type == 2 {
                    if positionPressed[note.finishPos!-1] == 0 {
                        positionPressed[note.finishPos!-1] = note.sec!
                    } else {
                        let path = pathForLongPress(note.finishPos!, sec1: positionPressed[note.finishPos!-1], sec2: note.sec!)
                        positionPressed[note.finishPos!-1] = 0
                        strokeColor.colorWithAlphaComponent(0.5).set()
                        //path.stroke()
                        path.fill()
                    }
                }
                //长按以滑动结束的情况
                if note.status > 0 && positionPressed[note.finishPos!-1] != 0 {
                    let path = pathForLongPress(note.finishPos!, sec1: positionPressed[note.finishPos!-1], sec2: note.sec!)
                    positionPressed[note.finishPos!-1] = 0
                    strokeColor.colorWithAlphaComponent(0.5).set()
                    //path.stroke()
                    path.fill()
                }
            }
        }
        
        for note in notes {
            if note.finishPos != 0  {
                let pointY = getPointY(note.sec!)
                //未到达显示区域时 continue
                if pointY > rect.origin.y + rect.size.height + BeatmapView.sectionHeight {
                    continue
                }
                //超出当前显示区域时 退出循环
                if pointY < rect.origin.y - BeatmapView.sectionHeight { break }
                
                //滑条
                if note.groupId != 0 {
                    if (sliders[note.groupId!] != nil) {
                        let path = pathForSlider(sliders[note.groupId!]!, note2: note)
                        sliders[note.groupId!] = note
                        strokeColor.colorWithAlphaComponent(0.5).set()
                        //path.stroke()
                        path?.fill()
                    } else {
                        sliders[note.groupId!] = note
                    }
                }
            }
        }
        
        for note in notes {
            if note.finishPos != 0  {
                let pointY = getPointY(note.sec!)
                //未到达显示区域时 continue
                if pointY > rect.origin.y + rect.size.height {
                    continue
                }
                //超出当前显示区域时 退出循环
                if pointY < rect.origin.y { break }

                //箭头向左
                if note.status == 1 {
                    let center = CGPointMake(getPointX(note.finishPos!), getPointY(note.sec!))
                    let point1 = CGPointMake(center.x - BeatmapView.noteRadius + 1, center.y)
                    let point2 = CGPointMake(center.x - 1, center.y - BeatmapView.noteRadius + 2)
                    let point3 = CGPointMake(center.x - 1, center.y + BeatmapView.noteRadius - 2)
                    let rect = CGRectMake(center.x - 1, center.y - 1, BeatmapView.noteRadius, 2)
                    let path = UIBezierPath.init(rect: rect)
                    let path2 = UIBezierPath.init()
                    path.moveToPoint(point1)
                    path.addLineToPoint(point2)
                    path.addLineToPoint(point3)
                    UIColor.whiteColor().set()
                    //path.stroke()
                    path.fill()
                    //path2.stroke()
                    path2.fill()
                }
                
                //箭头向右
                if note.status == 2 {
                    let center = CGPointMake(getPointX(note.finishPos!), getPointY(note.sec!))
                    let point1 = CGPointMake(center.x + BeatmapView.noteRadius - 1, center.y)
                    let point2 = CGPointMake(center.x + 1, center.y - BeatmapView.noteRadius + 2)
                    let point3 = CGPointMake(center.x + 1, center.y + BeatmapView.noteRadius - 2)
                    let rect = CGRectMake(center.x - BeatmapView.noteRadius + 1, center.y - 1, BeatmapView.noteRadius, 2)
                    let path = UIBezierPath.init(rect: rect)
                    let path2 = UIBezierPath.init()
                    path.moveToPoint(point1)
                    path.addLineToPoint(point2)
                    path.addLineToPoint(point3)
                    UIColor.whiteColor().set()
                    //path.stroke()
                    path.fill()
                    //path2.stroke()
                    path2.fill()
                }
            }

        }
        
        //处理未显示完全的长按部分
        for i in 1...5 {
            if positionPressed[i-1] != 0 {
                let path = pathForLongPress(i, sec1: positionPressed[i-1], y: rect.origin.y)
                positionPressed[i-1] = 0
                strokeColor.colorWithAlphaComponent(0.5).set()
                //path.stroke()
                path.fill()
            }
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
            self.strokeColor = UIColor.darkGrayColor()
        default:
            break
        }
        self.backgroundColor = UIColor.clearColor()
        self.contentSize = CGSizeMake(CGSSTool.width, secScale * CGFloat(beatmap.validSeconds) + 2 * BeatmapView.heightInset)
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height)
        self.delegate = self
    }

    private func pathForPoint(position:Int, sec:Float) -> UIBezierPath
    {
        let radius = BeatmapView.noteRadius
        let center = CGPointMake(getPointX(position), getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    
    
    private func pathForLongPress(position:Int, sec1:Float, sec2:Float) -> UIBezierPath {
        let x = getPointX(position)
        let y1 = getPointY(sec1)
        let y2 = getPointY(sec2)
        let path = UIBezierPath.init(rect: CGRectMake(x - BeatmapView.noteRadius, y2, BeatmapView.noteRadius * 2, y1 - y2))
        return path
    }
    
    private func pathForSlider(note1:CGSSBeatmap.Note, note2:CGSSBeatmap.Note) -> UIBezierPath? {
        
        let x1 = getPointX(note1.finishPos!)
        let x2 = getPointX(note2.finishPos!)
        let y1 = getPointY(note1.sec!)
        let y2 = getPointY(note2.sec!)
        //个别情况下滑条的组id会重复使用,为了避免这种情况带来的错误,当滑条的点间距大于1个section时,失效
        if y1 - y2 > BeatmapView.sectionHeight {
            return nil
        }
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(x1, y1 - BeatmapView.noteRadius))
        path.addLineToPoint(CGPointMake(x1, y1 + BeatmapView.noteRadius))
        path.addLineToPoint(CGPointMake(x2, y2 + BeatmapView.noteRadius))
        path.addLineToPoint(CGPointMake(x2, y2 - BeatmapView.noteRadius))
        return path
    }
    
    private func pathForLongPress(position:Int, sec1:Float, y:CGFloat) -> UIBezierPath {
        let x = getPointX(position)
        let y1 = getPointY(sec1)
        let path = UIBezierPath.init(rect: CGRectMake(x - BeatmapView.noteRadius, y, BeatmapView.noteRadius * 2, y1 - y))
        return path
    }
    
    private func pathForSectionLine(positionY:CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 50, y: positionY))
        path.addLineToPoint(CGPoint(x: CGSSTool.width - 50, y: positionY))
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


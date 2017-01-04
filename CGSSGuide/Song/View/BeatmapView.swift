//
//  BeatmapView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}


class BeatmapView: UIScrollView, UIScrollViewDelegate {
    
    static let widthInset: CGFloat = ceil(CGSSGlobal.width / 7.2) * 2
    static let sectionHeight: CGFloat = 245
    static let heightInset: CGFloat = 60
    static let noteRadius: CGFloat = 7
    
    var beatmap: CGSSBeatmap!
    var notes: [CGSSBeatmapNote]!
    var bpm: Int!
    var interval: CGFloat {
        return (CGSSGlobal.width - 2 * BeatmapView.widthInset) / 4
    }
    
    var secScale: CGFloat {
        return BeatmapView.sectionHeight * (CGFloat(bpm) / 60 / 4)
    }
    
    // 对于长按范围过大的歌曲 扩大一定范围的上下区间
    var expand:CGFloat = 0
    
    // 是否镜像翻转
    var mirrorFlip:Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var strokeColor: UIColor!
    
    fileprivate var lineWidth: CGFloat = 1
    func getPointX(_ position: Int) -> CGFloat {
        return BeatmapView.widthInset + interval * (CGFloat(mirrorFlip ? 6 - position : position) - 1)
    }
    
    func getPointY(_ sec: Float) -> CGFloat {
        return contentSize.height - CGFloat(sec - self.beatmap.preSeconds) * secScale - BeatmapView.heightInset
    }
    
    func getSecOffset(y: CGFloat) -> Float {
        return Float((contentSize.height - y - BeatmapView.heightInset) / secScale)
    }
    
    
    func drawIn(rect:CGRect) {
        typealias Note = CGSSBeatmapNote
        // 画纵向辅助线
        for i in 1...5 {
            let path = pathForVerticalLine(rect.origin.y, height: rect.size.height, positionX: getPointX(i))
            UIColor.lightGray.withAlphaComponent(0.5).set()
            path.stroke()
        }
        
        // 画小节线
        let halfquadSectionMax = Int(((contentSize.height - rect.origin.y - BeatmapView.heightInset) / BeatmapView.sectionHeight * 8))
        let rectMin = contentSize.height - rect.size.height - rect.origin.y - BeatmapView.heightInset
        let halfquadSectionMin = Int(rectMin / BeatmapView.sectionHeight * 8)
        for i in halfquadSectionMin...halfquadSectionMax {
            let pointY = contentSize.height - BeatmapView.heightInset - CGFloat(i) * BeatmapView.sectionHeight / 8
            if i % 8 == 0 {
                UIColor.darkGray.set()
                let sectionNumber: NSString = NSString.init(format: "%03d", i / 8)
                let attDict = [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]
                sectionNumber.draw(at: CGPoint(x: BeatmapView.widthInset / 2 - 25, y: pointY - 7), withAttributes: attDict)
                let comboNumber: NSString = NSString.init(format: "%d", beatmap.comboForSec(Float(i / 8) / (Float(bpm) / 60 / 4)))
                comboNumber.draw(at: CGPoint(x: CGSSGlobal.width - BeatmapView.widthInset / 2 + 4, y: pointY - 7), withAttributes: attDict)
            }
            else if i % 2 == 0 { UIColor.lightGray.set() }
            else { UIColor.lightGray.withAlphaComponent(0.5).set() }
            let path = pathForSectionLine(pointY)
            path.stroke()
        }
        
        // 滑条 长按 同步线
        var sliders = [Int: Note]()
        var positionPressed = [Float].init(repeating: 0, count: 5)
        var sync: Note?
        
        
//        let datef = DateFormatter()
//        datef.dateFormat = "SSSS"
//        print(1)
//        print(datef.string(from: Date()))
        let maxY = rect.maxY + BeatmapView.sectionHeight + expand
        let minY = rect.minY - BeatmapView.sectionHeight - expand
        let minIndex = beatmap.comboForSec(getSecOffset(y: maxY))
        let maxIndex = beatmap.comboForSec(getSecOffset(y: minY))
        for i in minIndex..<maxIndex{
            let note = notes[i]
            // 画滑条
            if note.groupId != 0 {
                if (sliders[note.groupId!] != nil) {
                    let path = pathForSlider(sliders[note.groupId!]!, note2: note)
                    sliders[note.groupId!] = note
                    UIColor.white.set()
                    path?.fill()
                    strokeColor.withAlphaComponent(0.25).set()
                    path?.fill()
                } else {
                    sliders[note.groupId!] = note
                }
            }
            
            // 简单长按类型
            if note.longPressType == 1 {
                positionPressed[note.finishPos! - 1] = note.sec!
            } else if note.longPressType == 2 {
                let path = pathForLongPress(note.finishPos!, sec1: positionPressed[note.finishPos! - 1], sec2: note.sec!)
                positionPressed[note.finishPos! - 1] = 0
                UIColor.white.set()
                path.fill()
                strokeColor.withAlphaComponent(0.25).set()
                // path.stroke()
                path.fill()
            }
        }
        // 处理上方未显示完全的长按部分
        for i in 1...5 {
            if positionPressed[i - 1] != 0 {
                let path = pathForLongPress(i, sec1: positionPressed[i - 1], y: rect.origin.y)
                positionPressed[i - 1] = 0
                UIColor.white.set()
                path.fill()
                strokeColor.withAlphaComponent(0.25).set()
                // path.stroke()
                path.fill()
            }
        }
        
        // 画同步线
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 画同步线
                if note.sync == 1 {
                    if sync != nil {
                        if sync?.sec == note.sec {
                            let path = pathForSyncLine(sync!, note2: note)
                            UIColor.white.set()
                            path.stroke()
                            strokeColor.withAlphaComponent(0.5).set()
                            path.stroke()
                        } else {
                            sync = note
                        }
                    } else {
                        sync = note
                    }
                }
            }
        }
        
        // 画点
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 点
                let path = pathForPoint(note.finishPos!, sec: note.sec!)
                strokeColor.set()
                // path.stroke()
                path.fill()
                
                // 长按类型中间画一个小圆
                if note.type == 2 && (note.status < 1 || note.status > 2) {
                    let path = pathForPointSmall(note.finishPos!, sec: note.sec!)
                    UIColor.white.set()
                    path.stroke()
                }
                
                // 箭头向左
                if (note.status == 1 && !mirrorFlip) || (note.status == 2 && mirrorFlip) {
                    let center = CGPoint(x: getPointX(note.finishPos!), y: getPointY(note.sec!))
                    let point1 = CGPoint(x: center.x - BeatmapView.noteRadius + 1, y: center.y)
                    let point2 = CGPoint(x: center.x - 1, y: center.y - BeatmapView.noteRadius + 2)
                    let point3 = CGPoint(x: center.x - 1, y: center.y + BeatmapView.noteRadius - 2)
                    let rect = CGRect(x: center.x - 1, y: center.y - 1, width: BeatmapView.noteRadius, height: 2)
                    let path = UIBezierPath.init(rect: rect)
                    let path2 = UIBezierPath.init()
                    path.move(to: point1)
                    path.addLine(to: point2)
                    path.addLine(to: point3)
                    UIColor.white.set()
                    // path.stroke()
                    path.fill()
                    // path2.stroke()
                    path2.fill()
                }
                
                // 箭头向右
                if (note.status == 2 && !mirrorFlip) || (note.status == 1 && mirrorFlip) {
                    let center = CGPoint(x: getPointX(note.finishPos!), y: getPointY(note.sec!))
                    let point1 = CGPoint(x: center.x + BeatmapView.noteRadius - 1, y: center.y)
                    let point2 = CGPoint(x: center.x + 1, y: center.y - BeatmapView.noteRadius + 2)
                    let point3 = CGPoint(x: center.x + 1, y: center.y + BeatmapView.noteRadius - 2)
                    let rect = CGRect(x: center.x - BeatmapView.noteRadius + 1, y: center.y - 1, width: BeatmapView.noteRadius, height: 2)
                    let path = UIBezierPath.init(rect: rect)
                    let path2 = UIBezierPath.init()
                    path.move(to: point1)
                    path.addLine(to: point2)
                    path.addLine(to: point3)
                    UIColor.white.set()
                    // path.stroke()
                    path.fill()
                    // path2.stroke()
                    path2.fill()
                }
                
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        drawIn(rect: rect)
    }
    
    func initWith(_ beatmap: CGSSBeatmap, bpm: Int, type: Int) {
        self.beatmap = beatmap
        beatmap.contextFreeAllNotes()
        self.notes = beatmap.validNotes
        self.bpm = bpm
        // 设置上下边界扩大的范围
        let maxInterval = CGFloat(beatmap.maxLongPressInterval) * secScale
        let drawHeight = self.frame.size.height + 2 * BeatmapView.sectionHeight
        if maxInterval - drawHeight > 0 {
            expand = (maxInterval - drawHeight) / 2 + 1
        }
        switch type {
        case 1:
            self.strokeColor = Color.cute
        case 2:
            self.strokeColor = Color.cool
        case 3:
            self.strokeColor = Color.passion
        case 4:
            self.strokeColor = UIColor.darkGray
        default:
            break
        }
        self.backgroundColor = UIColor.clear
        self.contentSize = CGSize(width: CGSSGlobal.width, height: secScale * CGFloat(beatmap.validSeconds) + 2 * BeatmapView.heightInset)
        self.contentOffset = CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height)
        self.delegate = self
    }
    
    fileprivate func pathForPoint(_ position: Int, sec: Float) -> UIBezierPath
    {
        let radius = BeatmapView.noteRadius
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    fileprivate func pathForPointSmall(_ position: Int, sec: Float) -> UIBezierPath
    {
        let radius = BeatmapView.noteRadius / 2
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    fileprivate func pathForSyncLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath
    {
        let x1 = getPointX(note1.finishPos!)
        let x2 = getPointX(note2.finishPos!)
        let y = getPointY(note1.sec!)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y))
        path.addLine(to: CGPoint(x: x2, y: y))
        path.lineWidth = 3
        return path
        
    }
    
    fileprivate func pathForLongPress(_ position: Int, sec1: Float, sec2: Float) -> UIBezierPath {
        let y2 = getPointY(sec2)
        return pathForLongPress(position, sec1: sec1, y: y2)
    }
    
    fileprivate func pathForSlider(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
        
        let x1 = getPointX(note1.finishPos!)
        let x2 = getPointX(note2.finishPos!)
        let y1 = getPointY(note1.sec!)
        let y2 = getPointY(note2.sec!)
        // 个别情况下滑条的组id会重复使用,为了避免这种情况带来的错误,当滑条的点间距大于1个section时,失效
        if y1 - y2 > BeatmapView.sectionHeight {
            return nil
        }
        
        let t = atan((y1 - y2) / (x2 - x1))
        let r = BeatmapView.noteRadius - 3
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1 - sin(t) * r, y: y1 - cos(t) * r))
        path.addLine(to: CGPoint(x: x1 + sin(t) * r, y: y1 + cos(t) * r))
        path.addLine(to: CGPoint(x: x2 + sin(t) * r, y: y2 + cos(t) * r))
        path.addLine(to: CGPoint(x: x2 - sin(t) * r, y: y2 - cos(t) * r))
        return path
    }
    
    fileprivate func pathForLongPress(_ position: Int, sec1: Float, y: CGFloat) -> UIBezierPath {
        let x = getPointX(position)
        let y1 = getPointY(sec1)
        let r = BeatmapView.noteRadius - 1
        let path = UIBezierPath.init(rect: CGRect(x: x - r, y: y, width: r * 2, height: y1 - y))
        return path
    }
    
    fileprivate func pathForSectionLine(_ positionY: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: BeatmapView.widthInset / 2, y: positionY))
        path.addLine(to: CGPoint(x: CGSSGlobal.width - BeatmapView.widthInset / 2, y: positionY))
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func pathForVerticalLine(_ originY: CGFloat, height: CGFloat, positionX: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: positionX, y: originY))
        path.addLine(to: CGPoint(x: positionX, y: originY + height))
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2 * M_PI),
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
    
    // MARK: scrollView的代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsDisplay()
    }
    
    
    // MARK: 生成整张谱面图片的方法
    func exportImageAsync(title:String, callBack: @escaping (UIImage?) -> Void) {

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let adBeatmap = AdvanceBeatmap.init(sectionHeight: 240, columnWidth: 175, widthInset: 32, innerWidthInset: 5, heightInset: 35, noteRadius: 6, beatmap: self.beatmap, bpm: self.bpm, mirrorFlip: self.mirrorFlip, strokeColor: self.strokeColor, lineWidth: self.lineWidth)
            let newImage = adBeatmap.export(sectionPerColumn: 4, title: title)
            
            DispatchQueue.main.async {
                callBack(newImage)
            }
            
        }
     
    }
    
}

class AdvanceBeatmap {
    var sectionHeight: CGFloat
    var columnWidth: CGFloat
    var widthInset: CGFloat
    var innerWidthInset: CGFloat
    var heightInset: CGFloat
    var noteRadius: CGFloat
    var beatmap: CGSSBeatmap
    var bpm: Int
    var mirrorFlip: Bool
    var strokeColor: UIColor
    var lineWidth: CGFloat
    
    init(sectionHeight: CGFloat,
         columnWidth: CGFloat,
         widthInset: CGFloat,
         innerWidthInset: CGFloat,
         heightInset: CGFloat,
         noteRadius: CGFloat,
         beatmap: CGSSBeatmap,
         bpm: Int,
         mirrorFlip: Bool,
         strokeColor: UIColor,
         lineWidth: CGFloat) {
        self.sectionHeight = sectionHeight
        self.columnWidth = columnWidth
        self.widthInset = widthInset
        self.innerWidthInset = innerWidthInset
        self.heightInset = heightInset
        self.noteRadius = noteRadius
        self.beatmap = beatmap
        self.bpm = bpm
        self.mirrorFlip = mirrorFlip
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
    }
    
    var interval: CGFloat {
        return (columnWidth - 2 * widthInset - 2 * innerWidthInset) / 4
    }
    
    var secScale: CGFloat {
        return sectionHeight * (CGFloat(bpm) / 60 / 4)
    }
    
    var totalHeight: CGFloat {
        return secScale * CGFloat(beatmap.validSeconds) + 2 * heightInset
    }
    
    var totalBeatmapHeight: CGFloat {
        return secScale * CGFloat(beatmap.validSeconds)
    }
    
    var notes: [CGSSBeatmapNote] {
        return beatmap.notes
    }
    
    func export(sectionPerColumn:CGFloat, title:String) -> UIImage? {
        let textHeight:CGFloat = 50
        // 一列的原始高度
        let beatmapH = sectionPerColumn * sectionHeight
        // 一列含上下边界的高度
        let columnH = beatmapH + 2 * heightInset
        // 生成的图片总高度
        let imageH = columnH + textHeight
        // 总列数
        let columns = ceil(totalBeatmapHeight / beatmapH)
        // 生成的图片总宽度
        let imageW = columns * columnWidth
        UIGraphicsBeginImageContext(CGSize.init(width: columnWidth, height: totalHeight))
        var context:CGContext! = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        let rect = CGRect.init(x: 0, y: 0, width: columnWidth, height: totalHeight)
        self.drawIn(rect: rect)
        let image = UIImage.init(cgImage: context.makeImage()!)
        UIGraphicsEndImageContext()
        
        
        UIGraphicsBeginImageContext(CGSize.init(width: imageW, height: imageH))
        context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: imageW, height: imageH))
        UIColor.white.set()
        path.fill()
        // 画标题
        UIColor.darkGray.set()
        let attDict = [NSFontAttributeName: UIFont.systemFont(ofSize: 24), NSForegroundColorAttributeName: UIColor.darkGray]
        (title as NSString).draw(at: CGPoint.init(x: 30, y: 10), withAttributes: attDict)
        for i in 0..<Int(columns) {
            
            let subImage:CGImage! = image.cgImage?.cropping(to: CGRect.init(x: 0, y: totalHeight - columnH * CGFloat(i + 1) + CGFloat(i) * 2 * heightInset, width: columnWidth, height: columnH))
            
            // 最后一列特殊处理
            if i == Int(columns) - 1 {
                let offset = totalBeatmapHeight.truncatingRemainder(dividingBy: beatmapH)
                UIImage.init(cgImage: subImage).draw(in: CGRect.init(x: CGFloat(i) * columnWidth, y: imageH - 2 * heightInset - offset, width: columnWidth, height: offset + heightInset * 2))
            } else {
                // 这样的画法不会上下颠倒
                UIImage.init(cgImage: subImage).draw(in: CGRect.init(x: CGFloat(i) * columnWidth, y: textHeight, width: columnWidth, height: columnH))
            }
            
            // CGImage坐标系Y轴和UIImage的相反, 画出的图是上下颠倒的
            //context.draw(subImage, in: CGRect.init(x: CGFloat(i) * CGSSGlobal.width, y: 50, width: CGSSGlobal.width, height: columnH))
            
            //let bottomSide:CGImage! = image.cgImage?.cropping(to: CGRect.init(x: 0, y: contentSize.height - columnH * CGFloat(i) + CGFloat(i) * 2 * BeatmapView.heightInset - BeatmapView.heightInset, width: CGSSGlobal.width, height: BeatmapView.heightInset))
            
          
        }
        // 边缘颜色渐变
        let locations:[CGFloat] = [0, 1]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        var startPoint = CGPoint.init(x: 0, y: imageH)
        var endPoint = CGPoint.init(x: 0, y: imageH - heightInset)
        
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))

        startPoint = CGPoint.init(x: 0, y: textHeight)
        endPoint = CGPoint.init(x: 0, y: textHeight + heightInset)
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))

        
        //另一种思路处理上下颠倒, 翻转180度
        //context.translateBy(x: imageW, y: imageH + 50)
        //context.concatenate(CGAffineTransform.init(rotationAngle: CGFloat(M_PI)))
        
        let newImage = UIImage.init(cgImage: context.makeImage()!)
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func drawIn(rect:CGRect) {
        typealias Note = CGSSBeatmapNote
        // 画纵向辅助线
        for i in 1...5 {
            let path = pathForVerticalLine(rect.origin.y, height: rect.size.height, positionX: getPointX(i))
            UIColor.lightGray.withAlphaComponent(0.5).set()
            path.stroke()
        }
        
        // 画小节线
        let halfquadSectionMax = Int(((totalHeight - rect.origin.y - heightInset) / sectionHeight * 8))
        let rectMin = totalHeight - rect.size.height - rect.origin.y - heightInset
        let halfquadSectionMin = Int(rectMin / sectionHeight * 8)
        for i in halfquadSectionMin...halfquadSectionMax {
            let pointY = totalHeight - heightInset - CGFloat(i) * sectionHeight / 8
            if i % 8 == 0 {
                UIColor.darkGray.set()
                let sectionNumber: NSString = NSString.init(format: "%03d", i / 8)
                let attDict = [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.darkGray]
                sectionNumber.draw(at: CGPoint(x: widthInset - 25, y: pointY - 7), withAttributes: attDict)
                let comboNumber: NSString = NSString.init(format: "%d", beatmap.comboForSec(Float(i / 8) / (Float(bpm) / 60 / 4)))
                comboNumber.draw(at: CGPoint(x: columnWidth - widthInset + 4, y: pointY - 7), withAttributes: attDict)
            }
            else if i % 2 == 0 { UIColor.lightGray.set() }
            else { UIColor.lightGray.withAlphaComponent(0.5).set() }
            let path = pathForSectionLine(pointY)
            path.stroke()
        }
        
        // 滑条 长按 同步线
        var sliders = [Int: Note]()
        var positionPressed = [Float].init(repeating: 0, count: 5)
        var sync: Note?
        
        for note in notes {
            if note.finishPos != 0 {
                let pointY = getPointY(note.sec!)
                // 未到达显示区域时 continue
                if pointY > rect.origin.y + rect.size.height + sectionHeight {
                    if note.type == 2 {
                        if positionPressed[note.finishPos! - 1] == 0 {
                            positionPressed[note.finishPos! - 1] = note.sec!
                        } else {
                            positionPressed[note.finishPos! - 1] = 0
                        }
                    }
                    if note.status > 0 && positionPressed[note.finishPos! - 1] != 0 {
                        positionPressed[note.finishPos! - 1] = 0
                    }
                    continue
                }
                // 超出当前显示区域时 退出循环
                if pointY < rect.origin.y - sectionHeight { break }
                
                // 画滑条
                if note.groupId != 0 {
                    if (sliders[note.groupId!] != nil) {
                        let path = pathForSlider(sliders[note.groupId!]!, note2: note)
                        sliders[note.groupId!] = note
                        UIColor.white.set()
                        path?.fill()
                        strokeColor.withAlphaComponent(0.25).set()
                        path?.fill()
                    } else {
                        sliders[note.groupId!] = note
                    }
                }
                
                // 简单长按类型
                // 部分歌曲存在长按结束时但是结束type != 2的情况(Nation Blue) 手工修改
                if positionPressed[note.finishPos! - 1] != 0 && note.type != 2 {
                    note.type = 2
                }
                if note.type == 2 {
                    if positionPressed[note.finishPos! - 1] == 0 {
                        positionPressed[note.finishPos! - 1] = note.sec!
                    } else {
                        let path = pathForLongPress(note.finishPos!, sec1: positionPressed[note.finishPos! - 1], sec2: note.sec!)
                        positionPressed[note.finishPos! - 1] = 0
                        UIColor.white.set()
                        path.fill()
                        strokeColor.withAlphaComponent(0.25).set()
                        // path.stroke()
                        path.fill()
                    }
                }
                // 长按以滑动结束的情况
                if note.status > 0 && positionPressed[note.finishPos! - 1] != 0 {
                    let path = pathForLongPress(note.finishPos!, sec1: positionPressed[note.finishPos! - 1], sec2: note.sec!)
                    positionPressed[note.finishPos! - 1] = 0
                    UIColor.white.set()
                    path.fill()
                    strokeColor.withAlphaComponent(0.25).set()
                    // path.stroke()
                    path.fill()
                }
                
            }
        }
        // 处理上方未显示完全的长按部分
        for i in 1...5 {
            if positionPressed[i - 1] != 0 {
                let path = pathForLongPress(i, sec1: positionPressed[i - 1], y: rect.origin.y)
                positionPressed[i - 1] = 0
                UIColor.white.set()
                path.fill()
                strokeColor.withAlphaComponent(0.25).set()
                // path.stroke()
                path.fill()
            }
        }
        
        // 画同步线
        for note in notes {
            if note.finishPos != 0 {
                let pointY = getPointY(note.sec!)
                // 未到达显示区域时 continue
                if pointY > rect.origin.y + rect.size.height + noteRadius {
                    continue
                }
                // 超出当前显示区域时 退出循环
                if pointY < rect.origin.y - noteRadius { break }
                
                // 画同步线
                if note.sync == 1 {
                    if sync != nil {
                        if sync?.sec == note.sec {
                            let path = pathForSyncLine(sync!, note2: note)
                            UIColor.white.set()
                            path.stroke()
                            strokeColor.withAlphaComponent(0.5).set()
                            path.stroke()
                        } else {
                            sync = note
                        }
                    } else {
                        sync = note
                    }
                    
                }
            }
        }
        
        // 画点
        for note in notes {
            if note.finishPos != 0 {
                let pointY = getPointY(note.sec!)
                // 未到达显示区域时 continue
                if pointY > rect.origin.y + rect.size.height + noteRadius {
                    continue
                }
                // 超出当前显示区域时 退出循环
                if pointY < rect.origin.y - noteRadius { break }
                // 点
                let path = pathForPoint(note.finishPos!, sec: note.sec!)
                strokeColor.set()
                // path.stroke()
                path.fill()
                
                // 长按类型中间画一个小圆
                if note.type == 2 && (note.status < 1 || note.status > 2) {
                    let path = pathForPointSmall(note.finishPos!, sec: note.sec!)
                    UIColor.white.set()
                    path.stroke()
                }
                
                // 箭头向左
                if (note.status == 1 && !mirrorFlip) || (note.status == 2 && mirrorFlip) {
                    let center = CGPoint(x: getPointX(note.finishPos!), y: getPointY(note.sec!))
                    let point1 = CGPoint(x: center.x - noteRadius + 1, y: center.y)
                    let point2 = CGPoint(x: center.x - 1, y: center.y - noteRadius + 2)
                    let point3 = CGPoint(x: center.x - 1, y: center.y + noteRadius - 2)
                    let rect = CGRect(x: center.x - 1, y: center.y - 1, width: noteRadius, height: 2)
                    let path = UIBezierPath.init(rect: rect)
                    let path2 = UIBezierPath.init()
                    path.move(to: point1)
                    path.addLine(to: point2)
                    path.addLine(to: point3)
                    UIColor.white.set()
                    // path.stroke()
                    path.fill()
                    // path2.stroke()
                    path2.fill()
                }
                
                // 箭头向右
                if (note.status == 2 && !mirrorFlip) || (note.status == 1 && mirrorFlip) {
                    let center = CGPoint(x: getPointX(note.finishPos!), y: getPointY(note.sec!))
                    let point1 = CGPoint(x: center.x + noteRadius - 1, y: center.y)
                    let point2 = CGPoint(x: center.x + 1, y: center.y - noteRadius + 2)
                    let point3 = CGPoint(x: center.x + 1, y: center.y + noteRadius - 2)
                    let rect = CGRect(x: center.x - noteRadius + 1, y: center.y - 1, width: noteRadius, height: 2)
                    let path = UIBezierPath.init(rect: rect)
                    let path2 = UIBezierPath.init()
                    path.move(to: point1)
                    path.addLine(to: point2)
                    path.addLine(to: point3)
                    UIColor.white.set()
                    // path.stroke()
                    path.fill()
                    // path2.stroke()
                    path2.fill()
                }
                
            }
        }
    }

    private func pathForPoint(_ position: Int, sec: Float) -> UIBezierPath
    {
        let radius = BeatmapView.noteRadius
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    private func pathForPointSmall(_ position: Int, sec: Float) -> UIBezierPath
    {
        let radius = noteRadius / 2
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    private func pathForSyncLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath
    {
        let x1 = getPointX(note1.finishPos!)
        let x2 = getPointX(note2.finishPos!)
        let y = getPointY(note1.sec!)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y))
        path.addLine(to: CGPoint(x: x2, y: y))
        path.lineWidth = 3
        return path
        
    }
    
    private func pathForLongPress(_ position: Int, sec1: Float, sec2: Float) -> UIBezierPath {
        let y2 = getPointY(sec2)
        return pathForLongPress(position, sec1: sec1, y: y2)
    }
    
    private func pathForSlider(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
        
        let x1 = getPointX(note1.finishPos!)
        let x2 = getPointX(note2.finishPos!)
        let y1 = getPointY(note1.sec!)
        let y2 = getPointY(note2.sec!)
        // 个别情况下滑条的组id会重复使用,为了避免这种情况带来的错误,当滑条的点间距大于1个section时,失效
        if y1 - y2 > sectionHeight {
            return nil
        }
        
        let t = atan((y1 - y2) / (x2 - x1))
        let r = (noteRadius + 1) / 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1 - sin(t) * r, y: y1 - cos(t) * r))
        path.addLine(to: CGPoint(x: x1 + sin(t) * r, y: y1 + cos(t) * r))
        path.addLine(to: CGPoint(x: x2 + sin(t) * r, y: y2 + cos(t) * r))
        path.addLine(to: CGPoint(x: x2 - sin(t) * r, y: y2 - cos(t) * r))
        return path
    }
    
    private func pathForLongPress(_ position: Int, sec1: Float, y: CGFloat) -> UIBezierPath {
        let x = getPointX(position)
        let y1 = getPointY(sec1)
        let r = noteRadius - 1
        let path = UIBezierPath.init(rect: CGRect(x: x - r, y: y, width: r * 2, height: y1 - y))
        return path
    }

    private func pathForSectionLine(_ positionY: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthInset, y: positionY))
        path.addLine(to: CGPoint(x: columnWidth - widthInset, y: positionY))
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForVerticalLine(_ originY: CGFloat, height: CGFloat, positionX: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: positionX, y: originY))
        path.addLine(to: CGPoint(x: positionX, y: originY + height))
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: false
        )
        path.lineWidth = lineWidth
        return path
    }

    func getPointX(_ position: Int) -> CGFloat {
        return widthInset + innerWidthInset + interval * (CGFloat(mirrorFlip ? 6 - position : position) - 1)
    }
    
    func getPointY(_ sec: Float) -> CGFloat {
        return totalHeight - CGFloat(sec - self.beatmap.preSeconds!) * secScale - heightInset
    }
}





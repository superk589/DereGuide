//
//  BeatmapView.swift
//  CGSSGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BeatmapView: UIScrollView, UIScrollViewDelegate {
   
    var beatmapDrawer: AdvanceBeatmapDrawer!
    var beatmap: CGSSBeatmap!
    var bpm: Int!
    var type: Int!
    // 是否镜像翻转
    var mirrorFlip: Bool = false {
        didSet {
            beatmapDrawer.mirrorFlip = mirrorFlip
            setNeedsDisplay()
        }
    }
    
    var strokeColor: UIColor {
        switch type {
        case 1:
            return Color.cute
        case 2:
            return Color.cool
        case 3:
            return Color.passion
        default:
            return UIColor.darkGray
        }
    }
    
    func setup(beatmap: CGSSBeatmap, bpm: Int, type: Int) {
        self.beatmap = beatmap
        beatmap.contextFreeAllNotes()
        self.bpm = bpm
        self.type = type
        
        /* debug */
//        beatmap.exportNote()
//        beatmap.exportIntervalToBpm()
//        beatmap.exportNoteWithOffset() 
        
        let widthInset: CGFloat = ceil(CGSSGlobal.width / 7.2)
        let innerWidthInset: CGFloat = widthInset
        let sectionHeight: CGFloat = 245
        let heightInset: CGFloat = 60
        let noteRadius: CGFloat = 7
        
        self.backgroundColor = UIColor.white
        beatmapDrawer = AdvanceBeatmapDrawer.init(sectionHeight: sectionHeight, columnWidth: self.frame.size.width, widthInset: widthInset, innerWidthInset: innerWidthInset, heightInset: heightInset, noteRadius: noteRadius, beatmap: beatmap, bpm: bpm, mirrorFlip: false, strokeColor: strokeColor, lineWidth: 1)
        self.contentSize.height = beatmapDrawer.totalHeight
        self.contentOffset = CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height)
        self.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        beatmapDrawer.columnWidth = self.frame.size.width
    }
    
    override func draw(_ rect: CGRect) {
        beatmapDrawer.drawIn(rect: rect)
    }
    
    
    // MARK: scrollView的代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsDisplay()
    }
    
    
    // MARK: 生成整张谱面图片的方法
    func exportImageAsync(title:String, callBack: @escaping (UIImage?) -> Void) {

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let adBeatmapDrawer = AdvanceBeatmapDrawer.init(sectionHeight: 240, columnWidth: 200, widthInset: 32, innerWidthInset: 5, heightInset: 35, noteRadius: 7, beatmap: self.beatmap, bpm: self.bpm, mirrorFlip: self.mirrorFlip, strokeColor: self.strokeColor, lineWidth: 1)
            let newImage = adBeatmapDrawer.export(sectionPerColumn: 4, title: title)
            
            DispatchQueue.main.async {
                callBack(newImage)
            }
            
        }
     
    }
    
}

class AdvanceBeatmapDrawer {
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
        return secScale * CGFloat(beatmap.validSeconds + (beatmap.lastNote?.offset ?? 0)) + 2 * heightInset
    }
    
    var totalBeatmapHeight: CGFloat {
        return secScale * CGFloat(beatmap.validSeconds + (beatmap.lastNote?.offset ?? 0))
    }
    
    var notes: [CGSSBeatmapNote] {
        return beatmap.validNotes
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
    
    private func drawVerticalLine(_ rect: CGRect) {
        for i in 1...5 {
            let path = pathForVerticalLine(rect.origin.y, height: rect.size.height, positionX: getPointX(i))
            UIColor.lightGray.withAlphaComponent(0.5).set()
            path.stroke()
        }
    }
    
    private func drawSectionLine(_ rect: CGRect) {
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
    }
    
    private func drawBpmShiftLine(_ rect: CGRect) {
        if let shiftingPoints = beatmap.shiftingPoints {
            for i in 0..<shiftingPoints.count {
                let point = shiftingPoints[i]
                let y = getPointY(point.timestamp)
                if y < rect.minX - sectionHeight { break }
                if y > rect.maxY + sectionHeight { continue }
                let path = pathForSectionLine(y)
                Color.bpmShift.set()
                path.stroke()
                
                var offset: CGFloat = 0
                let remainder = (totalHeight - y - heightInset).truncatingRemainder(dividingBy: sectionHeight)
                if remainder < 24 {
                    offset = remainder - 24
                } else if sectionHeight - remainder < 24 {
                    offset = -24 - sectionHeight + remainder
                }
                
                UIColor.red.set()
                let bpmNumber = NSString.init(format: "%d", point.bpm)
                let attDict = [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: Color.bpmShift]
                bpmNumber.draw(at: CGPoint(x: columnWidth - widthInset + 4, y: y - 14 + offset), withAttributes: attDict)
                
                if i > 0 {
                    let lastPoint = shiftingPoints[i - 1]
                    let bpmNumber = NSString.init(format: "%d", lastPoint.bpm)
                    let attDict = [NSFontAttributeName: UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName: Color.bpmShift]
                    bpmNumber.draw(at: CGPoint(x: columnWidth - widthInset + 4, y: y + offset), withAttributes: attDict)
                }
                
                let path2 = UIBezierPath.init()
                path2.move(to: CGPoint(x: columnWidth - widthInset, y: y))
                path2.addLine(to: CGPoint(x: columnWidth - widthInset + 1, y: y))
                path2.addLine(to: CGPoint(x: columnWidth - widthInset + 1, y: y + offset))
                let bpmLength = bpmNumber.boundingRect(with: CGSize.init(width: 999, height: 999), options: NSStringDrawingOptions.init(rawValue: 0), attributes: attDict, context: nil).size.width
                path2.addLine(to: CGPoint(x: columnWidth - widthInset + bpmLength + 4, y: y + offset))
                path2.lineWidth = 1
                path2.stroke()
            }
        }
    }
    
    typealias Note = CGSSBeatmapNote

    private func drawNote(minIndex: Int, maxIndex: Int) {
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 常规点
                let path = pathForPoint(note.finishPos, sec: note.sec + note.offset)
                strokeColor.set()
                // path.stroke()
                path.fill()
                
                // 长按类型中间画一个小圆
                if [1, 2].contains(note.longPressType) && (note.status < 1 || note.status > 2) {
                    let path = pathForSmallPoint(note.finishPos, sec: note.sec + note.offset)
                    UIColor.white.set()
                    path.fill()
                }
                
                // slider 中间画一个小横线
                if note.type == 3 && (note.status < 1 || note.status > 2) {
                    let path = pathForSmallPoint(note.finishPos, sec: note.sec + note.offset)
                    let path2 = pathForSliderPoint(note.finishPos, sec: note.sec + note.offset)
                    UIColor.white.set()
                    path.fill()
                    path2.stroke()
                }
                
                // flick 箭头向左
                if (note.status == 1 && !mirrorFlip) || (note.status == 2 && mirrorFlip) {
                    let center = CGPoint(x: getPointX(note.finishPos), y: getPointY(note.sec + note.offset))
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
                
                // flick 箭头向右
                if (note.status == 2 && !mirrorFlip) || (note.status == 1 && mirrorFlip) {
                    let center = CGPoint(x: getPointX(note.finishPos), y: getPointY(note.sec + note.offset))
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
    
    private func drawNoteSyncLine(minIndex: Int, maxIndex: Int) {
        var syncNote: Note?
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 画同步线
                if note.sync == 1 {
                    if syncNote != nil {
                        if syncNote!.sec + syncNote!.offset == note.sec + note.offset {
                            let path = pathForSyncLine(syncNote!, note2: note)
                            UIColor.white.set()
                            path.stroke()
                            strokeColor.withAlphaComponent(0.5).set()
                            path.stroke()
                        } else {
                            syncNote = note
                        }
                    } else {
                        syncNote = note
                    }
                    
                }
            }
        }
    }
    
    private func drawNoteLongPressLine(minIndex: Int, maxIndex: Int) {
        var positionPressed = [Float].init(repeating: 0, count: 5)
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 简单长按类型
                if note.longPressType == 1 {
                    positionPressed[note.finishPos - 1] = note.sec + note.offset
                } else if note.longPressType == 2 {
                    let path = pathForLongPress(note.finishPos, sec1: positionPressed[note.finishPos - 1], sec2: note.sec + note.offset)
                    positionPressed[note.finishPos - 1] = 0
                    UIColor.white.set()
                    path.fill()
                    strokeColor.withAlphaComponent(0.25).set()
                    // path.stroke()
                    path.fill()
                }
                
            }
        }

    }
    
    private func drawNoteGroupLine(minIndex: Int, maxIndex: Int) {
        var slidersOrFlicks = [Int: Note]()
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 画滑条
                if note.groupId != 0 {
                    if (slidersOrFlicks[note.groupId!] != nil) {
                        let path = pathForSlider(slidersOrFlicks[note.groupId!]!, note2: note)
                        slidersOrFlicks[note.groupId!] = note
                        UIColor.white.set()
                        path?.fill()
                        strokeColor.withAlphaComponent(0.25).set()
                        path?.fill()
                    } else {
                        slidersOrFlicks[note.groupId!] = note
                    }
                }
            }
        }
    }
    
    func drawIn(rect:CGRect) {
        
        // 画纵向辅助线
        drawVerticalLine(rect)
        
        // 画小节线
        drawSectionLine(rect)
        
        // 画 bpm 改变线
        drawBpmShiftLine(rect)
        
        
        // 滑条 长按 同步线
        let maxInterval = CGFloat(beatmap.maxLongPressInterval) * secScale
        let expand = maxInterval
        
        let maxY = rect.maxY + expand
        let minY = rect.minY - expand
        let minIndex = beatmap.comboForSec(getSecOffset(y: maxY))
        let maxIndex = beatmap.comboForSec(getSecOffset(y: minY))
        
        drawNoteGroupLine(minIndex: minIndex, maxIndex: maxIndex)
        
        drawNoteLongPressLine(minIndex: minIndex, maxIndex: maxIndex)
        
        drawNoteSyncLine(minIndex: minIndex, maxIndex: maxIndex)

        // 画点
        drawNote(minIndex: minIndex, maxIndex: maxIndex)
    }

    private func pathForPoint(_ position: Int, sec: Float) -> UIBezierPath
    {
        let radius = noteRadius
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    private func pathForSmallPoint(_ position: Int, sec: Float) -> UIBezierPath
    {
        let radius = floor(noteRadius / 2)
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    fileprivate func pathForSliderPoint(_ position: Int, sec: Float) -> UIBezierPath {
        let path = UIBezierPath()
        let x = getPointX(position)
        let y = getPointY(sec)
        path.move(to: CGPoint(x: x - noteRadius , y: y))
        path.addLine(to: CGPoint(x: x + noteRadius, y: y))
        path.lineWidth = 2
        return path
    }
    private func pathForSyncLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath
    {
        let x1 = getPointX(note1.finishPos)
        let x2 = getPointX(note2.finishPos)
        let y = getPointY(note1.sec + note1.offset)
        
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
    
    private func pathForFlick(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
        
        let x1 = getPointX(note1.finishPos)
        let x2 = getPointX(note2.finishPos)
        let y1 = getPointY(note1.sec + note1.offset)
        let y2 = getPointY(note2.sec + note2.offset)
        // 个别情况下滑条的组id会重复使用,为了避免这种情况带来的错误,当滑条的点间距大于1个section时,失效
        // 但是要注意新类型slide会超过1个section故排除slide
        if y1 - y2 > sectionHeight && note1.type != 3 && note2.type != 3 {
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
    
    private func pathForSlider(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
        
        let x1 = getPointX(note1.finishPos)
        let x2 = getPointX(note2.finishPos)
        let y1 = getPointY(note1.sec + note1.offset)
        let y2 = getPointY(note2.sec + note2.offset)
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
        return totalHeight - CGFloat(sec - self.beatmap.secondOfFirstNote) * secScale - heightInset
    }
    
    func getSecOffset(y: CGFloat) -> Float {
        return Float((totalHeight - y - heightInset) / secScale)
    }
}





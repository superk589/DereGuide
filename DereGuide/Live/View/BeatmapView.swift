//
//  BeatmapView.swift
//  DereGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class BeatmapView: IndicatorScrollView {
    
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
    
    var setting: BeatmapAdvanceOptionsViewController.Setting!
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(beatmap: CGSSBeatmap, bpm: Int, type: Int, setting: BeatmapAdvanceOptionsViewController.Setting) {
        self.beatmap = beatmap
        self.setting = setting
        self.bpm = bpm
        self.type = type
        
        beatmap.contextFree()
        
        indicator.strokeColor = self.strokeColor
        
        /* debug */
//        beatmap.exportNote()
//        beatmap.exportIntervalToBpm()
//        beatmap.exportNoteWithOffset()
        
        let widthInset: CGFloat = ceil(CGSSGlobal.width / 7.2)
        let innerWidthInset: CGFloat = widthInset
        let sectionHeight: CGFloat = 245
        let heightInset: CGFloat = 60
        let noteRadius: CGFloat = 7
        
        beatmapDrawer = AdvanceBeatmapDrawer(sectionHeight: sectionHeight, columnWidth: frame.width, widthInset: widthInset, innerWidthInset: innerWidthInset, heightInset: heightInset, noteRadius: noteRadius, beatmap: beatmap, bpm: bpm, mirrorFlip: false, strokeColor: strokeColor, lineWidth: 1, tapColor: strokeColor, flickColor: strokeColor, slideColor: strokeColor, holdColor: strokeColor)
        updateBeatmapDrawer()
        contentSize.height = beatmapDrawer.totalHeight
        if #available(iOS 11.0, *) {
        } else {
            contentOffset = CGPoint(x: 0, y: contentSize.height - frame.size.height + contentInset.bottom)
        }
        delegate = self
        
        setNeedsDisplay()
    }
    
    private func updateBeatmapDrawer() {
        if beatmapDrawer == nil { return }
        switch setting.theme {
        case .single:
            beatmapDrawer.tapColor = strokeColor
            beatmapDrawer.holdColor = strokeColor
            beatmapDrawer.flickColor = strokeColor
            beatmapDrawer.slideColor = strokeColor
            beatmapDrawer.strokeColor = strokeColor
        case .type4:
            beatmapDrawer.tapColor = .tap
            beatmapDrawer.holdColor = .hold
            beatmapDrawer.flickColor = .flick4
            beatmapDrawer.slideColor = .slide
            beatmapDrawer.strokeColor = UIColor.init(hexString: "7f7f7f")
        case .type3:
            beatmapDrawer.tapColor = .tap
            beatmapDrawer.holdColor = .hold
            beatmapDrawer.flickColor = .flick3
            beatmapDrawer.slideColor = .slide
            beatmapDrawer.strokeColor = UIColor.init(hexString: "7f7f7f")
        }
        
        beatmapDrawer.sectionHeight = 245 * setting.scale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        beatmapDrawer?.columnWidth = self.frame.size.width
    }
    
    override func draw(_ rect: CGRect) {
        beatmapDrawer.drawIn(rect: rect)
    }
    
    func exportImageAsync(title:String, callBack: @escaping (UIImage?) -> Void) {

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            let adBeatmapDrawer = AdvanceBeatmapDrawer.init(sectionHeight: 240, columnWidth: 200, widthInset: 32, innerWidthInset: 5, heightInset: 35, noteRadius: 7, beatmap: self.beatmap, bpm: self.bpm, mirrorFlip: self.mirrorFlip, strokeColor: self.beatmapDrawer.strokeColor, lineWidth: 1, tapColor: self.beatmapDrawer.tapColor, flickColor: self.beatmapDrawer.flickColor, slideColor: self.beatmapDrawer.slideColor, holdColor: self.beatmapDrawer.holdColor)
            let newImage = adBeatmapDrawer.export(sectionPerColumn: 4, title: title)
            
            DispatchQueue.main.async {
                callBack(newImage)
            }
        }
    }
    
}

// MARK: UIScrollViewDelegate
extension BeatmapView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNeedsDisplay()
    }
    
}

struct AdvanceBeatmapDrawer {
    
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
    
    var tapColor: UIColor
    var flickColor: UIColor
    var slideColor: UIColor
    var holdColor: UIColor
    
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
        guard let imageContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let rect = CGRect.init(x: 0, y: 0, width: columnWidth, height: totalHeight)
        self.drawIn(rect: rect)
        let image = UIImage.init(cgImage: imageContext.makeImage()!)
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(CGSize.init(width: imageW, height: imageH))
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: imageW, height: imageH))
        UIColor.white.set()
        path.fill()
        // 画标题
        UIColor.darkGray.set()
        let attDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
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
            // context.draw(subImage, in: CGRect.init(x: CGFloat(i) * CGSSGlobal.width, y: 50, width: CGSSGlobal.width, height: columnH))
            
            // let bottomSide:CGImage! = image.cgImage?.cropping(to: CGRect.init(x: 0, y: contentSize.height - columnH * CGFloat(i) + CGFloat(i) * 2 * BeatmapView.heightInset - BeatmapView.heightInset, width: CGSSGlobal.width, height: BeatmapView.heightInset))
            
          
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

        
        // 另一种思路处理上下颠倒, 翻转180度
        // context.translateBy(x: imageW, y: imageH + 50)
        // context.concatenate(CGAffineTransform.init(rotationAngle: CGFloat(M_PI)))
        
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
                let attDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.darkGray]
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
                let attDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: Color.bpmShift]
                bpmNumber.draw(at: CGPoint(x: columnWidth - widthInset + 4, y: y - 14 + offset), withAttributes: attDict)
                
                if i > 0 {
                    let lastPoint = shiftingPoints[i - 1]
                    let bpmNumber = NSString.init(format: "%d", lastPoint.bpm)
                    let attDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: Color.bpmShift]
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
                let outerPath = pathForPoint(note.finishPos, sec: note.offsetSecond)
                
                if [1, 2].contains(note.longPressType) && (note.status < 1 || note.status > 2) {
                    // 长按类型中间画一个小圆
                    holdColor.set()
                    outerPath.fill()
                    let innerPath = pathForSmallPoint(note.finishPos, sec: note.offsetSecond)
                    UIColor.white.set()
                    innerPath.fill()
                } else if note.type == 3 && (note.status < 1 || note.status > 2) {
                    // slide 中间画一个小横线
                    slideColor.set()
                    outerPath.fill()
                    let path = pathForSmallPoint(note.finishPos, sec: note.offsetSecond)
                    let path2 = pathForSlidePoint(note.finishPos, sec: note.offsetSecond)
                    UIColor.white.set()
                    path.fill()
                    path2.stroke()
                } else if (note.status == 1 && !mirrorFlip) || (note.status == 2 && mirrorFlip) {
                    // flick 箭头向左
                    flickColor.set()
                    outerPath.fill()
                    let center = CGPoint(x: getPointX(note.finishPos), y: getPointY(note.offsetSecond))
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
                } else if (note.status == 2 && !mirrorFlip) || (note.status == 1 && mirrorFlip) {
                    // flick 箭头向右
                    flickColor.set()
                    outerPath.fill()
                    let center = CGPoint(x: getPointX(note.finishPos), y: getPointY(note.offsetSecond))
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
                } else {
                    tapColor.set()
                    outerPath.fill()
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
                        if syncNote!.offsetSecond == note.offsetSecond {
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
        var lastPressedNote = [Note?](repeating: nil, count: 5)
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 简单长按类型
                if note.longPressType == 1 {
                    lastPressedNote[note.finishPos - 1] = note
                }
                if note.longPressType == 2 && note.previous != nil {
                    let path = pathForLongPress(note.finishPos, sec1: note.previous!.offsetSecond, sec2: note.offsetSecond)
                    UIColor.white.set()
                    path.fill()
                    strokeColor.withAlphaComponent(0.25).set()
                    path.fill()
                    lastPressedNote[note.finishPos - 1] = nil
                }
            }
        }
        
        let pressed: [Note] = lastPressedNote.flatMap { $0 }
        for last in pressed {
            if let next = last.next {
                let path = pathForLongPress(last.finishPos, sec1: last.offsetSecond, sec2: next.offsetSecond)
                UIColor.white.set()
                path.fill()
                strokeColor.withAlphaComponent(0.25).set()
                path.fill()
            }
        }

    }
    
    private func drawNoteGroupLine(minIndex: Int, maxIndex: Int) {
        var lastSlidedOfFlickedNote = [Int: Note]()
        for i in minIndex..<maxIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                // 画滑条
                if note.groupId != 0 {
                    lastSlidedOfFlickedNote[note.groupId] = note
                    if note.previous != nil {
                        let path = (note.type == 3) ? pathForSlide(note.previous!, note2: note) : pathForFlick(note.previous!, note2: note)
                        UIColor.white.set()
                        path?.fill()
                        strokeColor.withAlphaComponent(0.25).set()
                        path?.fill()
                    }
                }
            }
        }
        
        for last in lastSlidedOfFlickedNote.values {
            if let next = last.next {
                let path = (next.type == 3) ? pathForSlide(last, note2: next) : pathForFlick(last, note2: next)
                UIColor.white.set()
                path?.fill()
                strokeColor.withAlphaComponent(0.25).set()
                path?.fill()
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
        let maxY = rect.maxY + noteRadius
        let minY = rect.minY - noteRadius
        var minIndex = beatmap.comboForSec(getSecOffset(y: maxY))
        var maxIndex = beatmap.comboForSec(getSecOffset(y: minY))
       
        // if full screen has no notes, then expand the index
        if maxIndex - minIndex < 1 {
            if minIndex - 2 > 0 {
                minIndex -= 2
            } else if maxIndex + 2 < notes.count {
                maxIndex += 2
            }
        }
        
        // if one side has long press or slide over the screen, the other side not, we need to expand the index too
        if let along = notes[minIndex].along {
            minIndex = along.comboIndex - 1
        }
        
        drawNoteGroupLine(minIndex: minIndex, maxIndex: maxIndex)
        
        drawNoteLongPressLine(minIndex: minIndex, maxIndex: maxIndex)
        
        drawNoteSyncLine(minIndex: minIndex, maxIndex: maxIndex)

        // 画点
        drawNote(minIndex: minIndex, maxIndex: maxIndex)
    }

    private func pathForPoint(_ position: Int, sec: Float) -> UIBezierPath {
        let radius = noteRadius
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    
    private func pathForSmallPoint(_ position: Int, sec: Float) -> UIBezierPath {
        let radius = floor(noteRadius / 2)
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    
    fileprivate func pathForSlidePoint(_ position: Int, sec: Float) -> UIBezierPath {
        let path = UIBezierPath()
        let x = getPointX(position)
        let y = getPointY(sec)
        path.move(to: CGPoint(x: x - noteRadius , y: y))
        path.addLine(to: CGPoint(x: x + noteRadius, y: y))
        path.lineWidth = 2
        return path
    }
    
    private func pathForSyncLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath {
        let x1 = getPointX(note1.finishPos)
        let x2 = getPointX(note2.finishPos)
        let y = getPointY(note1.offsetSecond)
        
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
        let y1 = getPointY(note1.offsetSecond)
        let y2 = getPointY(note2.offsetSecond)
        // 个别情况下flicks的组id会重复使用,为了避免这种情况带来的错误,当滑条的点间距大于1个section时,失效
        // 但是要注意新类型slide会超过1个section故排除slide
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
    
    private func pathForSlide(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
        
        let x1 = getPointX(note1.finishPos)
        let x2 = getPointX(note2.finishPos)
        let y1 = getPointY(note1.offsetSecond)
        let y2 = getPointY(note2.offsetSecond)
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
        let r = (noteRadius + 1) / 2
        let path = UIBezierPath.init(rect: CGRect(x: x - r, y: y, width: r * 2, height: y1 - y))
        return path
    }

    private func pathForSectionLine(_ positionY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: widthInset, y: positionY))
        path.addLine(to: CGPoint(x: columnWidth - widthInset, y: positionY))
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForVerticalLine(_ originY: CGFloat, height: CGFloat, positionX: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: positionX, y: originY))
        path.addLine(to: CGPoint(x: positionX, y: originY + height))
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2.0 * .pi),
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

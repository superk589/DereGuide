//
//  BeatmapView.swift
//  DereGuide
//
//  Created by zzk on 16/7/25.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

private enum Axis {
    case horizontal
    case vertical
}

private extension UIPinchGestureRecognizer {
    
    var axis: Axis {
        let point1 = location(ofTouch: 0, in: view)
        let point2 = location(ofTouch: 1, in: view)
        let angle = atan2(point2.y - point1.y, point2.x - point1.x)
        if (CGFloat.pi / 4)...(CGFloat.pi * 3 / 4) ~= abs(angle) {
            return .vertical
        } else {
            return .horizontal
        }
    }
    
    var isHorizontal: Bool {
        let point1 = location(ofTouch: 0, in: view)
        let point2 = location(ofTouch: 1, in: view)
        let angle = atan2(point2.y - point1.y, point2.x - point1.x)
        if 0...(CGFloat.pi / 3) ~= abs(angle) || (CGFloat.pi * 2 / 3)...CGFloat.pi ~= abs(angle) {
            return true
        } else {
            return false
        }
    }
    
    var isVertical: Bool {
        let point1 = location(ofTouch: 0, in: view)
        let point2 = location(ofTouch: 1, in: view)
        let angle = atan2(point2.y - point1.y, point2.x - point1.x)
        if (CGFloat.pi / 6)...(CGFloat.pi * 5 / 6) ~= abs(angle) {
            return true
        } else {
            return false
        }
    }
}

protocol BeatmapViewSettingDelegate: class {
    func beatmapView(_ beatmapView: BeatmapView, didChange setting: BeatmapAdvanceOptionsViewController.Setting)
}

class BeatmapView: IndicatorScrollView {
    
    var drawer: BeatmapDrawer?
    var beatmap: CGSSBeatmap!
    var bpm: Int!
    var type: Int!
    var player: CGSSBeatmapPlayer?
    
    weak var settingDelegate: BeatmapViewSettingDelegate?
    
    // 是否镜像翻转
    var mirrorFlip: Bool = false {
        didSet {
            drawer?.mirrorFlip = mirrorFlip
            setNeedsDisplay()
        }
    }
    
    var setting = BeatmapAdvanceOptionsViewController.Setting()
    
    var strokeColor: UIColor {
        switch type {
        case 1:
            return .cute
        case 2:
            return .cool
        case 3:
            return .passion
        default:
            return .darkGray
        }
    }
    
    var colorTheme: BeatmapDrawer.Theme {
        let colorTheme: BeatmapDrawer.Theme
        switch setting.theme {
        case .single:
            colorTheme = .single(mainColor: strokeColor)
        case .type3:
            colorTheme = .type3
        case .type4:
            colorTheme = .type4
        case .type6:
            colorTheme = .type6
        }
        return colorTheme
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        addGestureRecognizer(pinch)
        pinch.delegate = self
    }
    
    func getProgress(for point: CGPoint) -> CGFloat {
        guard let drawer = self.drawer else {
            return 0
        }
        let offsetY = contentOffset.y - drawer.inset.bottom + point.y
        return offsetY / drawer.totalBeatmapHeight
    }
    
    func setProgress(_ progress: CGFloat, for point: CGPoint) {
        guard let drawer = self.drawer else { return }
        contentOffset.y = progress * drawer.totalBeatmapHeight + drawer.inset.bottom - point.y
    }
    
    private var verticalScale: CGFloat {
        set {
            setting.verticalScale = max(0.5, min(newValue, 2))
            drawer?.barHeight = 245 * setting.verticalScale
            setNeedsDisplay()
        }
        get {
            return setting.verticalScale
        }
    }
    
    private var pinchCenter: CGPoint = .zero
    private var progress: CGFloat = 0
    @objc private func handlePinchGesture(_ pinch: UIPinchGestureRecognizer) {
        switch pinch.state {
        case .began:
            let center = pinch.location(in: self)
            pinchCenter.y = convert(center, to: superview).y - frame.minY
            progress = getProgress(for: pinchCenter)
        case .changed:
            let scale = pinch.scale
            verticalScale *= scale
            contentSize.height = drawer?.totalHeight ?? 0
            setProgress(progress, for: pinchCenter)
            pinch.scale = 1
        case .ended, .cancelled:
            settingDelegate?.beatmapView(self, didChange: setting)
        default:
            break
        }
        
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
        let horizontalInset: CGFloat = ceil(CGSSGlobal.width / 7.2)
        let innerPadding: CGFloat
        if frame.width > frame.height {
            innerPadding = horizontalInset / 3
        } else {
            innerPadding = horizontalInset
        }
        let sectionHeight: CGFloat = 245
        let verticalInset: CGFloat = 60
        let noteRadius: CGFloat = 7
        
        verticalScale = setting.verticalScale
        let inset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        drawer = BeatmapDrawer(
            barHeight: sectionHeight,
            columnWidth: frame.width,
            inset: inset,
            numberAreaWidth: innerPadding,
            noteRadius: noteRadius,
            beatmap: beatmap,
            bpm: bpm,
            mirrorFlip: false,
            lineWidth: 1,
            colorTheme: colorTheme,
            hidesAssistedLines: setting.hidesAssistedLines
        )
        
        contentSize.height = drawer?.totalHeight ?? 0
        if #available(iOS 11.0, *) {
        } else {
            contentOffset = CGPoint(x: 0, y: contentSize.height - frame.size.height + contentInset.bottom)
        }
        
        player = CGSSBeatmapPlayer(beatmap: beatmap, rawBPM: bpm)
        
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawer?.columnWidth = frame.width
        contentSize.width = frame.width
        drawer?.inset.left = ceil(frame.width / 7.2)
        drawer?.inset.right = ceil(frame.width / 7.2)
        if frame.width > frame.height {
            drawer?.numberAreaWidth = ceil(frame.width / 21.6)
        } else {
            drawer?.numberAreaWidth = ceil(frame.width / 7.2)
        }
    }
    
    var isAutoScrolling = false
    override func draw(_ rect: CGRect) {
        drawer?.draw(rect)
        if isAutoScrolling && setting.showsPlayLine {
            pathForPlayLine()?.stroke()
            drawTime()
            if beatmap.shiftingPoints != nil {
                drawBPM()
            }
        }
    }
    
    func exportImageAsync(title:String, callBack: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            guard let _ = self.drawer else {
                DispatchQueue.main.async {
                    callBack(nil)
                }
                return
            }
            let adBeatmapDrawer = BeatmapDrawer(
                barHeight: 240,
                columnWidth: 200,
                inset: UIEdgeInsets(top: 35, left: 32, bottom: 35, right: 32),
                numberAreaWidth: 5,
                noteRadius: 7,
                beatmap: self.beatmap,
                bpm: self.bpm,
                mirrorFlip: self.mirrorFlip,
                lineWidth: 1,
                colorTheme: self.colorTheme,
                hidesAssistedLines: false
            )
            let newImage = adBeatmapDrawer.export(sectionPerColumn: 4, title: title)
            
            DispatchQueue.main.async {
                callBack(newImage)
            }
        }
    }
    
    @objc func frameUpdated(displayLink: CADisplayLink) {
        guard let drawer = self.drawer, let player = self.player else { return }
        playOffsetY = drawer.getPointY(Float(player.currentShiftedOffset()))
    }
    
    func startAutoScrolling() {
        isAutoScrolling = true
        isUserInteractionEnabled = false
        indicator.hide()
        setContentOffset(contentOffset, animated: false)
        player?.play(shiftedOffset: TimeInterval(drawer?.getShiftedOffset(y: playOffsetY) ?? 0) + TimeInterval(beatmap.timeOfFirstNote))
    }
    
    func endAutoScrolling() {
        isAutoScrolling = false
        setNeedsDisplay()
        isUserInteractionEnabled = true
        player?.pause()
    }
    
    var playOffsetY: CGFloat {
        get {
            guard let drawer = self.drawer else { return 0 }
            if #available(iOS 11.0, *) {
                return frame.height + contentOffset.y - drawer.inset.bottom - adjustedContentInset.bottom
            } else {
                return frame.height + contentOffset.y - drawer.inset.bottom - contentInset.bottom
            }
        }
        set {
            guard let drawer = self.drawer else { return }
            if #available(iOS 11.0, *) {
                contentOffset.y = -frame.height + newValue + drawer.inset.bottom + adjustedContentInset.bottom
            } else {
                contentOffset.y = -frame.height + newValue + drawer.inset.bottom + contentInset.bottom
            }
        }
    }
    
    private func pathForPlayLine() -> UIBezierPath? {
        guard let drawer = self.drawer else { return nil }
        let path = UIBezierPath()
        if #available(iOS 11.0, *) {
            path.move(to: CGPoint(x: 0, y: frame.height + contentOffset.y - drawer.inset.bottom - adjustedContentInset.bottom))
        } else {
            path.move(to: CGPoint(x: 0, y: frame.height + contentOffset.y - drawer.inset.bottom - contentInset.bottom))
        }
        path.addLine(to: CGPoint(x: frame.maxX, y: path.currentPoint.y))
        UIColor.black.set()
        path.lineWidth = 2
        return path
    }
    
    private func drawTime() {
        guard let player = self.player else { return }
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black]
        let elapsed = player.currentOffset()
        let time: NSString = NSString(format: "%d:%02d", Int(elapsed) / 60, Int(elapsed) % 60)
        time.draw(at: CGPoint(x: 10, y: playOffsetY - 19), withAttributes: attributes)
    }
    
    private func drawBPM() {
        guard let player = self.player else { return }
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.black]
        let bpm: NSString = NSString(format: "%d", player.currentBPM())
        bpm.draw(at: CGPoint(x: 10, y: playOffsetY + 4), withAttributes: attributes)
    }
    
}

extension BeatmapView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pinch = gestureRecognizer as? UIPinchGestureRecognizer {
            return pinch.isVertical
        } else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
    }
    
}

struct BeatmapDrawer {
    
    struct Theme {
        var clickColor: UIColor
        var holdColor: UIColor
        var flickLeftColor: UIColor
        var flickRightColor: UIColor
        var slideColor: UIColor
        var lineColor: UIColor
        
        /// 单一颜色风格，颜色为传入的歌曲主题色
        /// - Parameter mainColor: 主题色
        static func single(mainColor: UIColor) -> Theme {
            return Theme(clickColor: mainColor, holdColor: mainColor, flickLeftColor: mainColor, flickRightColor: mainColor, slideColor: mainColor, lineColor: mainColor)
        }
        
        /// 区分 note 类型颜色，左右箭头颜色固定为绿色
        static let type3 = Theme(clickColor: .tap, holdColor: .hold, flickLeftColor: .flick3, flickRightColor: .flick3, slideColor: .slide, lineColor: .beatmapLine)
        
        /// 区分 note 类型颜色，左右箭头颜色固定为蓝色
        static let type4 = Theme(clickColor: .tap, holdColor: .hold, flickLeftColor: .flick4, flickRightColor: .flick4, slideColor: .slide, lineColor: .beatmapLine)
        
        /// 区分左右箭头颜色，区分 note 类型颜色
        static let type6 = Theme(clickColor: .tap, holdColor: .hold, flickLeftColor: .flick3, flickRightColor: .flick4, slideColor: .slide, lineColor: .beatmapLine)
    }
    
    /// 小节高度
    var barHeight: CGFloat
    
    /// 列宽度，通常展示时是屏幕的宽度，导出时需要指定
    var columnWidth: CGFloat
    
    /// 整列的内边缘距离
    var inset: UIEdgeInsets
    
    /// combo 数字和小节数字所在区域的宽度
    var numberAreaWidth: CGFloat
    
    /// note 的半径
    var noteRadius: CGFloat
    
    var beatmap: CGSSBeatmap
    var bpm: Int
    
    /// 是否镜像翻转
    var mirrorFlip: Bool
    
    var lineWidth: CGFloat
    var colorTheme: Theme
    
    /// 是否隐藏辅助线
    var hidesAssistedLines: Bool

    var isGrandLive: Bool {
        return beatmap.isGrandLive
    }
        
    var interval: CGFloat {
        if isGrandLive {
            return (columnWidth - inset.left - inset.right - 2 * numberAreaWidth) / 14
        } else {
            return (columnWidth - inset.left - inset.right - 2 * numberAreaWidth) / 4
        }
    }
    
    var secScale: CGFloat {
        return barHeight * (CGFloat(bpm) / 60 / 4)
    }
    
    var totalHeight: CGFloat {
        return secScale * CGFloat(beatmap.validSeconds + (beatmap.lastNote?.offset ?? 0)) + inset.top + inset.bottom
    }
    
    var totalBeatmapHeight: CGFloat {
        return secScale * CGFloat(beatmap.validSeconds + (beatmap.lastNote?.offset ?? 0))
    }
    
    var notes: [CGSSBeatmapNote] {
        return beatmap.validNotes
    }
    
    func export(sectionPerColumn: CGFloat, title: String) -> UIImage? {
        let textHeight:CGFloat = 50
        // 一列的原始高度
        let beatmapH = sectionPerColumn * barHeight
        // 一列含上下边界的高度
        let columnH = beatmapH + inset.top + inset.bottom
        // 生成的图片总高度
        let imageH = columnH + textHeight
        // 总列数
        let columns = ceil(totalBeatmapHeight / beatmapH)
        // 生成的图片总宽度
        let imageW = columns * columnWidth
        UIGraphicsBeginImageContext(CGSize(width: columnWidth, height: totalHeight))
        guard let imageContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: columnWidth, height: totalHeight)
        draw(rect)
        let image = UIImage(cgImage: imageContext.makeImage()!)
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(CGSize(width: imageW, height: imageH))
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: imageW, height: imageH))
        UIColor.white.set()
        path.fill()
        // 画标题
        UIColor.darkGray.set()
        let attDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        (title as NSString).draw(at: CGPoint(x: 30, y: 10), withAttributes: attDict)
        for i in 0..<Int(columns) {
            
            let subImage:CGImage! = image.cgImage?.cropping(to: CGRect(x: 0, y: totalHeight - columnH * CGFloat(i + 1) + CGFloat(i) * (inset.top + inset.bottom), width: columnWidth, height: columnH))
            
            // 最后一列特殊处理
            if i == Int(columns) - 1 {
                let offset = totalBeatmapHeight.truncatingRemainder(dividingBy: beatmapH)
                UIImage(cgImage: subImage).draw(in: CGRect(x: CGFloat(i) * columnWidth, y: imageH - inset.top - inset.bottom - offset, width: columnWidth, height: offset + inset.top + inset.bottom))
            } else {
                // 这样的画法不会上下颠倒
                UIImage(cgImage: subImage).draw(in: CGRect(x: CGFloat(i) * columnWidth, y: textHeight, width: columnWidth, height: columnH))
            }
            
            // CGImage坐标系Y轴和UIImage的相反, 画出的图是上下颠倒的
            // context.draw(subImage, in: CGRect.init(x: CGFloat(i) * CGSSGlobal.width, y: 50, width: CGSSGlobal.width, height: columnH))
            
            // let bottomSide:CGImage! = image.cgImage?.cropping(to: CGRect.init(x: 0, y: contentSize.height - columnH * CGFloat(i) + CGFloat(i) * 2 * BeatmapView.heightInset - BeatmapView.heightInset, width: CGSSGlobal.width, height: BeatmapView.heightInset))
            
            
        }
        // 边缘颜色渐变
        let locations:[CGFloat] = [0, 1]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        var startPoint = CGPoint(x: 0, y: imageH)
        var endPoint = CGPoint(x: 0, y: imageH - inset.bottom)
        
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        startPoint = CGPoint(x: 0, y: textHeight)
        endPoint = CGPoint(x: 0, y: textHeight + inset.top)
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        
        // 另一种思路处理上下颠倒, 翻转180度
        // context.translateBy(x: imageW, y: imageH + 50)
        // context.concatenate(CGAffineTransform.init(rotationAngle: CGFloat(M_PI)))
        
        let newImage = UIImage(cgImage: context.makeImage()!)
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func draw(_ rect: CGRect) {
        
        if !hidesAssistedLines {
            // 画纵向辅助线
            drawVerticalLine(rect)
            
            // 画小节线
            drawSectionLine(rect)
            
            // 画 bpm 改变线
            drawBpmShiftLine(rect)
        }
        
        let range = convertRectToIndexRange(rect)
        
        drawGroupLine(indexRange: range)
        drawHoldConnectionLine(indexRange: range)
        drawSyncLine(indexRange: range)
        drawNote(rangeIndex: range)
    }
    
    private func convertRectToIndexRange(_ rect: CGRect) -> Range<Int> {
        // 滑条 长按 同步线
        let maxY = rect.maxY + noteRadius
        let minY = rect.minY - noteRadius
        var minIndex = beatmap.comboForSec(getShiftedOffset(y: maxY))
        var maxIndex = beatmap.comboForSec(getShiftedOffset(y: minY))
        
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
        
        return minIndex..<maxIndex
    }
}

// MARK: Drawing logic
extension BeatmapDrawer {
    
    private func drawVerticalLine(_ rect: CGRect) {
        let count = isGrandLive ? 15 : 5
        for i in 1...count {
            let x = isGrandLive ? getWidePointX(i, width: 1).start : getPointX(i)
            let origin = CGPoint(x: x, y: rect.origin.y)
            let path = pathForVerticalLine(origin: origin, height: rect.size.height)
            UIColor.lightGray.withAlphaComponent(0.5).set()
            path.stroke()
        }
    }
    
    private func drawSectionLine(_ rect: CGRect) {
        let halfquadSectionMax = Int(((totalHeight - rect.origin.y - inset.bottom) / barHeight * 8))
        let rectMin = totalHeight - rect.size.height - rect.origin.y - inset.bottom
        let halfquadSectionMin = Int(rectMin / barHeight * 8)
        for i in halfquadSectionMin...halfquadSectionMax {
            let pointY = totalHeight - inset.bottom - CGFloat(i) * barHeight / 8
            if i % 8 == 0 {
                UIColor.darkGray.set()
                let sectionNumber: NSString = NSString.init(format: "%03d", i / 8)
                let attDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
                sectionNumber.draw(at: CGPoint(x: numberAreaWidth - 25, y: pointY - 7), withAttributes: attDict)
                let comboNumber: NSString = NSString.init(format: "%d", beatmap.comboForSec(Float(i / 8) / (Float(bpm) / 60 / 4)))
                comboNumber.draw(at: CGPoint(x: columnWidth - numberAreaWidth + 4, y: pointY - 7), withAttributes: attDict)
            }
            else if i % 2 == 0 { UIColor.lightGray.set() }
            else { UIColor.lightGray.withAlphaComponent(0.5).set() }
            let path = pathForBarLine(pointY)
            path.stroke()
        }
    }
    
    
    private func drawBpmShiftLine(_ rect: CGRect) {
        if let shiftingPoints = beatmap.shiftingPoints {
            for i in 0..<shiftingPoints.count {
                let point = shiftingPoints[i]
                let y = getPointY(point.timestamp)
                if y < rect.minX - barHeight { break }
                if y > rect.maxY + barHeight { continue }
                let path = pathForBarLine(y)
                UIColor.bpmShift.set()
                path.stroke()
                
                var offset: CGFloat = 0
                let remainder = (totalHeight - y - inset.bottom).truncatingRemainder(dividingBy: barHeight)
                if remainder < 24 {
                    offset = remainder - 24
                } else if barHeight - remainder < 24 {
                    offset = -24 - barHeight + remainder
                }
                
                UIColor.red.set()
                let bpmNumber = NSString(format: "%d", point.bpm)
                let attDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.bpmShift]
                bpmNumber.draw(at: CGPoint(x: columnWidth - numberAreaWidth + 4, y: y - 14 + offset), withAttributes: attDict)
                
                if i > 0 {
                    let lastPoint = shiftingPoints[i - 1]
                    let bpmNumber = NSString(format: "%d", lastPoint.bpm)
                    let attDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor
                        .bpmShift]
                    bpmNumber.draw(at: CGPoint(x: columnWidth - numberAreaWidth + 4, y: y + offset), withAttributes: attDict)
                }
                
                let path2 = UIBezierPath.init()
                path2.move(to: CGPoint(x: columnWidth - numberAreaWidth, y: y))
                path2.addLine(to: CGPoint(x: columnWidth - numberAreaWidth + 1, y: y))
                path2.addLine(to: CGPoint(x: columnWidth - numberAreaWidth + 1, y: y + offset))
                let bpmLength = bpmNumber.boundingRect(with: CGSize.init(width: 999, height: 999), options: NSStringDrawingOptions.init(rawValue: 0), attributes: attDict, context: nil).size.width
                path2.addLine(to: CGPoint(x: columnWidth - numberAreaWidth + bpmLength + 4, y: y + offset))
                path2.lineWidth = 1
                path2.stroke()
            }
        }
    }
    
    typealias Note = CGSSBeatmapNote
    
    private func drawNote(rangeIndex: Range<Int>) {
        
        for i in rangeIndex {
            let note = notes[i]
            if note.finishPos != 0 {
                switch note.style {
                case .hold:
                    let outerPath = pathForNoteOuter(note.finishPos, sec: note.offsetSecond)
                    // 长按类型中间画一个小圆
                    colorTheme.holdColor.set()
                    outerPath.fill()
                    let innerPath = pathForNoteInner(note.finishPos, sec: note.offsetSecond)
                    UIColor.white.set()
                    innerPath.fill()
                case .slide:
                    let outerPath = pathForNoteOuter(note.finishPos, sec: note.offsetSecond)
                    // slide 中间画一个小横线
                    colorTheme.slideColor.set()
                    outerPath.fill()
                    let path = pathForNoteInner(note.finishPos, sec: note.offsetSecond)
                    let path2 = pathForSlideNote(note.finishPos, sec: note.offsetSecond)
                    UIColor.white.set()
                    path.fill()
                    path2.stroke()
                case .flick(.left) where !mirrorFlip,
                     .flick(.right) where mirrorFlip:
                    let outerPath = pathForNoteOuter(note.finishPos, sec: note.offsetSecond)
                    colorTheme.flickLeftColor.set()
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
                case .flick(.right) where !mirrorFlip,
                     .flick(.left) where mirrorFlip:
                    let outerPath = pathForNoteOuter(note.finishPos, sec: note.offsetSecond)
                    colorTheme.flickRightColor.set()
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
                case .wideClick:
                    let outerPath = pathForWideNoteOuter(position: note.finishPos, sec: note.offsetSecond, width: note.width)
                    colorTheme.clickColor.set()
                    outerPath.fill()
                case .wideSlide:
                    let outerPath = pathForWideNoteOuter(position: note.finishPos, sec: note.offsetSecond, width: note.width)
                    colorTheme.holdColor.set()
                    outerPath.fill()
                    let innerPath = pathForWideNoteInner(note.finishPos, sec: note.offsetSecond, width: note.width)
                    UIColor.white.set()
                    innerPath.fill()
                case .wideFlick(.left) where !mirrorFlip,
                     .wideFlick(.right) where mirrorFlip:
                    let outerPath = pathForWideNoteOuter(position: note.finishPos, sec: note.offsetSecond, width: note.width)
                    colorTheme.flickLeftColor.set()
                    outerPath.fill()
                    let (start, end) = getWidePointX(note.finishPos, width: note.width)
                    let startPoint = CGPoint(x: start, y: getPointY(note.offsetSecond))
                    let endPoint = CGPoint(x: end, y: getPointY(note.offsetSecond))
                    let point1 = CGPoint(x: startPoint.x - noteRadius + 1, y: startPoint.y)
                    let point2 = CGPoint(x: startPoint.x + 1, y: startPoint.y - noteRadius + 3)
                    let point3 = CGPoint(x: startPoint.x + 1, y: startPoint.y + noteRadius - 3)
                    let rect = CGRect(x: startPoint.x - 1, y: startPoint.y - 1, width: endPoint.x - startPoint.x + noteRadius, height: 2)
                    let path = UIBezierPath(rect: rect)
                    path.move(to: point1)
                    path.addLine(to: point2)
                    path.addLine(to: point3)
                    UIColor.white.set()
                    path.fill()
                case .wideFlick(.right) where !mirrorFlip,
                     .wideFlick(.left) where mirrorFlip:
                    let outerPath = pathForWideNoteOuter(position: note.finishPos, sec: note.offsetSecond, width: note.width)
                    colorTheme.flickRightColor.set()
                    outerPath.fill()
                    let (start, end) = getWidePointX(note.finishPos, width: note.width)
                    let startPoint = CGPoint(x: start, y: getPointY(note.offsetSecond))
                    let endPoint = CGPoint(x: end, y: getPointY(note.offsetSecond))
                    let point1 = CGPoint(x: endPoint.x + noteRadius - 1, y: startPoint.y)
                    let point2 = CGPoint(x: endPoint.x - 1, y: startPoint.y - noteRadius + 3)
                    let point3 = CGPoint(x: endPoint.x - 1, y: startPoint.y + noteRadius - 3)
                    let rect = CGRect(x: startPoint.x - noteRadius + 1, y: startPoint.y - 1, width: endPoint.x - startPoint.x + noteRadius - 2, height: 2)
                    let path = UIBezierPath(rect: rect)
                    path.move(to: point1)
                    path.addLine(to: point2)
                    path.addLine(to: point3)
                    UIColor.white.set()
                    path.fill()
                case .click:
                    let outerPath = pathForNoteOuter(note.finishPos, sec: note.offsetSecond)
                    colorTheme.clickColor.set()
                    outerPath.fill()
                default:
                    fatalError()
                }
            }
        }
    }
    
    private func drawSyncLine(indexRange: Range<Int>) {
        var syncNote: Note?
        for i in indexRange {
            let note = notes[i]
            if note.finishPos != 0 {
                // 画同步线
                if note.sync == 1 {
                    if syncNote != nil {
                        if syncNote!.offsetSecond == note.offsetSecond {
                            let path = note.style.isWide ? pathForWideSyncLine(syncNote!, note2: note) : pathForSyncLine(syncNote!, note2: note)
                            UIColor.white.set()
                            path.stroke()
                            colorTheme.lineColor.withAlphaComponent(0.5).set()
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
    
    private func drawGroupLine(indexRange: Range<Int>) {
        var lastSlideOrFlickNote = [Int: Note]()
        for i in indexRange {
            let note = notes[i]
            if note.finishPos != 0 {
                // 画滑条
                if note.groupId != 0 {
                    lastSlideOrFlickNote[note.groupId] = note
                    if note.previous != nil {
                        let path: UIBezierPath?
                        switch note.style {
                        case .flick:
                            path = pathForFlickConnectionLine(note.previous!, note2: note)
                        case .slide:
                            path = pathForSlideConnectionLine(note.previous!, note2: note)
                        default:
                            path = pathForWideSlideConnectionLine(note.previous!, note2: note)
                        }
                        colorTheme.lineColor.withAlphaComponent(0.25).set()
                        path?.fill()
                    }
                }
            }
        }
        
        for last in lastSlideOrFlickNote.values {
            if let next = last.next {
                let path: UIBezierPath?
                switch last.style {
                case .flick:
                    path = pathForFlickConnectionLine(last, note2: next)
                case .slide:
                    path = pathForSlideConnectionLine(last, note2: next)
                default:
                    path = pathForWideSlideConnectionLine(last, note2: next)
                }
                colorTheme.lineColor.withAlphaComponent(0.25).set()
                path?.fill()
            }
        }
    }
    
    private func drawHoldConnectionLine(indexRange: Range<Int>) {
        var lastPressedNote = [Note?](repeating: nil, count: 15)
        if isGrandLive { return }
        for i in indexRange {
            let note = notes[i]
            if note.finishPos != 0 {
                // 简单长按类型
                if note.longPressType == 1 {
                    lastPressedNote[note.finishPos - 1] = note
                }
                if note.longPressType == 2 && note.previous != nil {
                    let path = pathForHoldConnectionLine(note.finishPos, sec1: note.previous!.offsetSecond, sec2: note.offsetSecond)
                    UIColor.white.set()
                    path.fill()
                    colorTheme.lineColor.withAlphaComponent(0.25).set()
                    path.fill()
                    lastPressedNote[note.finishPos - 1] = nil
                }
            }
        }
        
        let pressed = lastPressedNote.compactMap { $0 }
        for last in pressed {
            if let next = last.next {
                let path = pathForHoldConnectionLine(last.finishPos, sec1: last.offsetSecond, sec2: next.offsetSecond)
                UIColor.white.set()
                path.fill()
                colorTheme.lineColor.withAlphaComponent(0.25).set()
                path.fill()
            }
        }
        
    }
    
}

// MARK: Note shapes
extension BeatmapDrawer {
    
    private func pathForNoteOuter(_ position: Int, sec: Float) -> UIBezierPath {
        let radius = noteRadius
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    
    private func pathForWideNoteOuter(position: Int, sec: Float, width: Int) -> UIBezierPath {
        let xRadius = noteRadius
        let yRadius = noteRadius - 2
        let (start, end) = getWidePointX(position, width: width)
        let startPoint = CGPoint(x: start, y: getPointY(sec))
        let endPoint = CGPoint(x: end, y: getPointY(sec))
        return pathForRoundedRectangle(startPoint: startPoint, endPoint: endPoint, xRadius: xRadius, yRadius: yRadius)
    }
    
    private func pathForNoteInner(_ position: Int, sec: Float) -> UIBezierPath {
        let radius = floor(noteRadius / 2)
        let center = CGPoint(x: getPointX(position), y: getPointY(sec))
        return pathForCircleCenteredAtPoint(center, withRadius: radius)
    }
    
    private func pathForWideNoteInner(_ position: Int, sec: Float, width: Int) -> UIBezierPath {
        let xRadius = noteRadius / 2
        let yRadius = noteRadius / 2 - 2
        let (start, end) = getWidePointX(position, width: width)
        let startPoint = CGPoint(x: start, y: getPointY(sec))
        let endPoint = CGPoint(x: end, y: getPointY(sec))
        return pathForRoundedRectangle(startPoint: startPoint, endPoint: endPoint, xRadius: xRadius, yRadius: yRadius)
    }
    
    fileprivate func pathForSlideNote(_ position: Int, sec: Float) -> UIBezierPath {
        let path = UIBezierPath()
        let x = getPointX(position)
        let y = getPointY(sec)
        path.move(to: CGPoint(x: x - noteRadius , y: y))
        path.addLine(to: CGPoint(x: x + noteRadius, y: y))
        path.lineWidth = 2
        return path
    }
    
}

// MARK: Note connection lines
extension BeatmapDrawer {
    
    private func pathForHoldConnectionLine(_ position: Int, sec1: Float, sec2: Float) -> UIBezierPath {
        let y1 = getPointY(sec1)
        let y2 = getPointY(sec2)
        let x = getPointX(position)
        let r = (noteRadius + 1) / 2
        let path = UIBezierPath(rect: CGRect(x: x - r, y: y2, width: r * 2, height: y1 - y2))
        return path
    }
    
    private func pathForSlideConnectionLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
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
    
    private func pathForWideSlideConnectionLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath {
        let (startX1, endX1) = getWidePointX(note1.finishPos, width: note1.width)
        let (startX2, endX2) = getWidePointX(note2.finishPos, width: note2.width)
        let y1 = getPointY(note1.offsetSecond)
        let y2 = getPointY(note2.offsetSecond)
        let t1 = atan((y1 - y2) / (startX2 - startX1))
        let t2 = atan((y1 - y2) / (endX2 - endX1))
        let startSign: CGFloat = (startX2 - startX1) >= 0 ? 1 : -1
        let endSign: CGFloat = (endX2 - endX1) >= 0 ? 1 : -1
        let r = noteRadius - 2
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startX1 - startSign * sin(t1) * r, y: y1 - startSign * cos(t1) * r))
        path.addLine(to: CGPoint(x: startX1, y: y1))
        path.addLine(to: CGPoint(x: endX1, y: y1))
        path.addLine(to: CGPoint(x: endX1 + endSign * sin(t2) * r, y: y1 + endSign * cos(t2) * r))
        path.addLine(to: CGPoint(x: endX2 + endSign * sin(t2) * r, y: y2 + endSign * cos(t2) * r))
        path.addLine(to: CGPoint(x: endX2, y: y2))
        path.addLine(to: CGPoint(x: startX2, y: y2))
        path.addLine(to: CGPoint(x: startX2 - startSign * sin(t1) * r, y: y2 - startSign * cos(t1) * r))
        return path
    }
    
    private func pathForFlickConnectionLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath? {
        let x1 = getPointX(note1.finishPos)
        let x2 = getPointX(note2.finishPos)
        let y1 = getPointY(note1.offsetSecond)
        let y2 = getPointY(note2.offsetSecond)
        // 个别情况下flicks的组id会重复使用,为了避免这种情况带来的错误,当滑条的点间距大于1个section时,失效
        // 但是要注意新类型slide会超过1个section故排除slide
        if y1 - y2 > barHeight {
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
    
    private func pathForWideSyncLine(_ note1: CGSSBeatmapNote, note2: CGSSBeatmapNote) -> UIBezierPath {
        let (x1, _) = getWidePointX(note1.finishPos, width: note1.width)
        let (x2, _) = getWidePointX(note2.finishPos, width: note2.width)
        let y = getPointY(note1.offsetSecond)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y))
        path.addLine(to: CGPoint(x: x2, y: y))
        path.lineWidth = 3
        return path
    }
}

// MARK: Position converting
extension BeatmapDrawer {
    
    /// Get the shifted offset time from the very begining of the beatmap to a specific point in all the drawing area
    ///
    /// - Parameter y: the point.y of the drawing area
    /// - Returns: the shifted offset time
    func getShiftedOffset(y: CGFloat) -> Float {
        return Float((totalHeight - y - inset.bottom) / secScale)
    }
    
    func getWidePointX(_ position: Int, width: Int) -> (start: CGFloat, end: CGFloat) {
        let endPosition = position + width - 1
        let x1 = inset.left + numberAreaWidth + interval * (CGFloat(mirrorFlip ? 16 - position : position) - 1)
        let x2 = inset.left + numberAreaWidth + interval * (CGFloat(mirrorFlip ? 16 - endPosition : endPosition) - 1)
        if mirrorFlip {
            return (start: x2, end: x1)
        } else {
            return (start: x1, end: x2)
        }
    }
    
    func getPointX(_ position: Int) -> CGFloat {
        return inset.left + numberAreaWidth + interval * (CGFloat(mirrorFlip ? 6 - position : position) - 1)
    }
    
    func getPointY(_ sec: Float) -> CGFloat {
        return totalHeight - CGFloat(sec - self.beatmap.timeOfFirstNote) * secScale - inset.bottom
    }
}

// MARK: Basic shapes
extension BeatmapDrawer {
    
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
    
    private func pathForRoundedRectangle(startPoint: CGPoint, endPoint: CGPoint, xRadius: CGFloat, yRadius: CGFloat) -> UIBezierPath {
        let rect = CGRect(x1: startPoint.x - xRadius, y1: startPoint.y - yRadius, x2: endPoint.x + xRadius, y2: endPoint.y + yRadius)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: yRadius)
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForBarLine(_ originY: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: numberAreaWidth, y: originY))
        path.addLine(to: CGPoint(x: columnWidth - numberAreaWidth, y: originY))
        path.lineWidth = lineWidth
        return path
    }
    
    private func pathForVerticalLine(origin: CGPoint, height: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: origin.x, y: origin.y))
        path.addLine(to: CGPoint(x: origin.x, y: origin.y + height))
        path.lineWidth = lineWidth
        return path
    }
    
}

private extension CGRect {
    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        self.init(x: x1, y: y1, width: x2 - x1, height: y2 - y1)
    }
}

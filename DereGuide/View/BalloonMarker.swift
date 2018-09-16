//
//  BalloonMarker.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import Foundation
import Charts

protocol BalloonMarkerDataSource: class {
    func balloonMarker(_ balloonMarker: BalloonMarker, stringForEntry entry: ChartDataEntry, highlight: Highlight) -> String
}

public class BalloonMarker: MarkerImage {
    public var color: UIColor
    public var arrowSize = CGSize(width: 15, height: 11)
    public var font: UIFont
    public var textColor: UIColor
    public var insets: UIEdgeInsets
    public var minimumSize = CGSize()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : AnyObject]()
    
    weak var dataSource: BalloonMarkerDataSource?
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, in chartView: ChartViewBase?) {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
        
        self.chartView = chartView
        chartView?.marker = self
    }
    
    public override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        let size = self.size
        var point = point
        point.x -= size.width / 2.0
        point.y -= size.height
        return super.offsetForDrawing(atPoint: point)
    }
    
    public override func draw(context: CGContext, point: CGPoint) {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()
        
        let roundedRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height)
        let roundedRectPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 4)
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(
                        x: point.x - arrowSize.width / 2,
                        y: rect.origin.y - 1 + rect.size.height - arrowSize.height))
        arrowPath.addLine(to: CGPoint(
                        x: point.x,
                        y: rect.origin.y + rect.size.height))
        arrowPath.addLine(to: CGPoint(
                        x: point.x + arrowSize.width / 2,
                        y: rect.origin.y - 1 + rect.size.height - arrowSize.height))
        arrowPath.close()
        
        context.setFillColor(color.cgColor)
        
        roundedRectPath.fill()
        arrowPath.fill()
        
        rect.origin.y += self.insets.top
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        guard let string = dataSource?.balloonMarker(self, stringForEntry: entry, highlight: highlight) else { return }
        setLabel(string)
    }
    
    public func setLabel(_ newLabel: String) {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? .zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
}

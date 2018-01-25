//
//  EventChartController.swift.swift
//  DereGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import Charts
import SnapKit

protocol RankingLineChartRepresentable {
    var chartEntries: [Int: [ChartDataEntry]] { get }
    var xAxis: [String] { get }
    var xAxisDetail: [String] { get }
    var borders: [Int] { get }
    var xAxisDates: [Date] { get }
}

extension EventRanking: RankingLineChartRepresentable {
    var chartEntries: [Int: [ChartDataEntry]] {
        var borderEntries = [Int: [ChartDataEntry]]()
        
        for border in borders {
            var entries = [ChartDataEntry]()
            for (index, item) in list.enumerated() {
                entries.append(ChartDataEntry(x: Double(index), y: Double(item[border])))
            }
            borderEntries[border] = entries
        }
        return borderEntries
    }
    
    
    var xAxis: [String] {
        var strings = [String]()
        for i in 0..<list.count {
            let date = list[i].date.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
            var gregorian = Calendar(identifier: .gregorian)
            gregorian.timeZone = TimeZone.current
            let comp = gregorian.dateComponents([.day, .hour, .minute], from: date)
            let string = String.init(format: NSLocalizedString("%d日%d时", comment: ""), comp.day!, comp.hour!)
            strings.append(string)
        }
        return strings
    }
    
    var xAxisDetail: [String] {
        var strings = [String]()
        for i in 0..<list.count {
            let date = list[i].date.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
            var gregorian = Calendar(identifier: .gregorian)
            gregorian.timeZone = TimeZone.current
            let comp = gregorian.dateComponents([.day, .hour, .minute], from: date)
            let string = String.init(format: NSLocalizedString("%d日%d时%d分", comment: ""), comp.day!, comp.hour!, comp.minute!)
            strings.append(string)
        }
        return strings
    }
    
    var xAxisDates: [Date] {
        var dates = [Date]()
        for i in 0..<list.count {
            let date = list[i].date.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
            dates.append(date)
        }
        return dates
    }
    
}

class EventChartController: BaseViewController {

    var rankingList: RankingLineChartRepresentable!
    
    private struct Height {
        static let sv: CGFloat = Screen.height - 113
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartView = LineChartView()
        view.addSubview(chartView)
        
        chartView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom)
                make.bottom.equalTo(bottomLayoutGuide.snp.top)
                make.left.right.equalToSuperview()
            }
        }
        
        var colors = ChartColorTemplates.vordiplom()
        var dataSets = [LineChartDataSet]()
        for border in rankingList.borders.prefix(5) {
            let set = LineChartDataSet.init(values: rankingList.chartEntries[border] ?? [], label: String(border))
            set.drawCirclesEnabled = false
            let color = colors.removeLast()
            set.setColor(color)
            set.lineWidth = 2
            set.drawValuesEnabled = false
            set.highlightColor = color
            dataSets.append(set)
        }
    
        let data = LineChartData.init(dataSets: dataSets)
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: rankingList.xAxis)
        chartView.chartDescription?.text = ""
        chartView.chartDescription?.font = UIFont.systemFont(ofSize: 14)
        chartView.chartDescription?.textColor = UIColor.darkGray
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        chartView.xAxis.granularity = 1
        chartView.scaleYEnabled = false
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        let nf = NumberFormatter()
        nf.positiveFormat = "0K"
        nf.multiplier = 0.001
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: nf)
        chartView.leftAxis.axisMinimum = 0
                
        let marker = BalloonMarker(color: UIColor(hex: 0x343D46), font: UIFont.boldSystemFont(ofSize: 12), textColor: UIColor.white, insets: UIEdgeInsets(top: 5, left: 7.0, bottom: 15, right: 7.0), in: chartView)
        marker.offset = CGPoint(x: 0, y: -5)
        
        marker.dataSource = self
        
        chartView.delegate = self
    }

}

extension EventChartController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        chartView.chartDescription?.text = "\(rankingList.xAxisDetail[Int(entry.x)])\(Int(entry.y))"
    }
}

extension EventChartController: BalloonMarkerDataSource {
    func balloonMarker(_ balloonMarker: BalloonMarker, stringForEntry entry: ChartDataEntry, highlight: Highlight) -> String {
        let date = rankingList.xAxisDates[Int(entry.x)]
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
        let scoreString = String(Int(round(entry.y)))
        return "\(dateString)\n\(scoreString)"
    }
}

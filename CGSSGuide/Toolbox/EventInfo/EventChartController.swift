//
//  EventChartController.swift.swift
//  CGSSGuide
//
//  Created by zzk on 2017/1/24.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import Charts
import SnapKit

struct ChartDataEntryWithLabel {
    var entry: [ChartDataEntry]
    var label: String
}

protocol RankingListChartPresentable {
    var chartEntries: [ChartDataEntryWithLabel] { get }
    var xAxis: [String] { get }
    var xAxisDetail: [String] { get }
}

extension EventScoreRankingList: RankingListChartPresentable {
    var chartEntries: [ChartDataEntryWithLabel] {
        var array = [ChartDataEntryWithLabel]()
        var reward1Entries = [ChartDataEntry]()
        var reward2Entries = [ChartDataEntry]()
        var reward3Entries = [ChartDataEntry]()
        for i in 0..<list.count {
            let entry1 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward1))
            reward1Entries.append(entry1)
            let entry2 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward2))
            reward2Entries.append(entry2)
            let entry3 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward3))
            reward3Entries.append(entry3)
        }
        array.append(ChartDataEntryWithLabel.init(entry: reward1Entries, label: "5000"))
        array.append(ChartDataEntryWithLabel.init(entry: reward2Entries, label: "10000"))
        array.append(ChartDataEntryWithLabel.init(entry: reward3Entries, label: "40000"))
        return array
    }
    
    
    var xAxis: [String] {
        var strings = [String]()
        for i in 0..<list.count {
            let df = DateFormatter()
            df.dateFormat = ""
            let date = list[i].date.toDate(format: "yyyy-MM-dd HH:mm")
            var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            gregorian.timeZone = CGSSGlobal.timeZoneOfTyoko
            let comp = gregorian.dateComponents([.day, .hour, .minute], from: date)
            let string = String.init(format: NSLocalizedString("%d日%d时", comment: ""), comp.day!, comp.hour!)
            strings.append(string)
        }
        return strings
    }
    
    var xAxisDetail: [String] {
        var strings = [String]()
        for i in 0..<list.count {
            let df = DateFormatter()
            df.dateFormat = ""
            let date = list[i].date.toDate(format: "yyyy-MM-dd HH:mm")
            var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            gregorian.timeZone = CGSSGlobal.timeZoneOfTyoko
            let comp = gregorian.dateComponents([.day, .hour, .minute], from: date)
            let string = String.init(format: NSLocalizedString("%d日%d时%d分", comment: ""), comp.day!, comp.hour!, comp.minute!)
            strings.append(string)
        }
        return strings
    }
    
}

extension EventPtRankingList: RankingListChartPresentable {
    var chartEntries: [ChartDataEntryWithLabel] {
        var array = [ChartDataEntryWithLabel]()
        var reward1Entries = [ChartDataEntry]()
        var reward2Entries = [ChartDataEntry]()
        var reward3Entries = [ChartDataEntry]()
        var reward4Entries = [ChartDataEntry]()
        var reward5Entries = [ChartDataEntry]()
        for i in 0..<list.count {
            let entry1 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward1))
            reward1Entries.append(entry1)
            let entry2 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward2))
            reward2Entries.append(entry2)
            let entry3 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward3))
            reward3Entries.append(entry3)
            let entry4 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward4))
            reward4Entries.append(entry4)
            let entry5 = ChartDataEntry.init(x: Double(i), y: Double(list[i].reward5))
            reward5Entries.append(entry5)
        }
        array.append(ChartDataEntryWithLabel.init(entry: reward1Entries, label: "2000"))
        array.append(ChartDataEntryWithLabel.init(entry: reward2Entries, label: "10000"))
        array.append(ChartDataEntryWithLabel.init(entry: reward3Entries, label: "20000"))
        array.append(ChartDataEntryWithLabel.init(entry: reward4Entries, label: "60000"))
        array.append(ChartDataEntryWithLabel.init(entry: reward5Entries, label: "120000"))
        return array
    }
    
    
    var xAxis: [String] {
        var strings = [String]()
        for i in 0..<list.count {
            let df = DateFormatter()
            df.dateFormat = ""
            let date = list[i].date.toDate(format: "yyyy-MM-dd HH:mm")
            var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            gregorian.timeZone = CGSSGlobal.timeZoneOfTyoko
            let comp = gregorian.dateComponents([.day, .hour, .minute], from: date)
            let string = String.init(format: NSLocalizedString("%d日%d时", comment: ""), comp.day!, comp.hour!)
            strings.append(string)
        }
        return strings
    }
    
    var xAxisDetail: [String] {
        var strings = [String]()
        for i in 0..<list.count {
            let df = DateFormatter()
            df.dateFormat = ""
            let date = list[i].date.toDate(format: "yyyy-MM-dd HH:mm")
            var gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            gregorian.timeZone = CGSSGlobal.timeZoneOfTyoko
            let comp = gregorian.dateComponents([.day, .hour, .minute], from: date)
            let string = String.init(format: NSLocalizedString("%d日%d时%d分", comment: ""), comp.day!, comp.hour!, comp.minute!)
            strings.append(string)
        }
        return strings
    }
    
}

class EventChartController: BaseViewController {

    var rankingList: RankingListChartPresentable!
    
    private struct Height {
        static let sv: CGFloat = Screen.height - 113
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartView = LineChartView()
        view.addSubview(chartView)
        
        chartView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.bottom.equalTo(-49)
            make.left.right.equalToSuperview()
        }
        
        var colors = ChartColorTemplates.vordiplom()
        var dataSets = [LineChartDataSet]()
        for entry in rankingList.chartEntries {
            let set = LineChartDataSet.init(values: entry.entry, label: entry.label)
            set.drawCirclesEnabled = false
            let color = colors.removeLast()
            set.setColor(color)
            set.lineWidth = 2
            dataSets.append(set)
        }
    
        let data = LineChartData.init(dataSets: dataSets)
    
        chartView.data = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: rankingList.xAxis)
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        chartView.xAxis.granularity = 1
        chartView.scaleYEnabled = false
        let nf = NumberFormatter()
        nf.positiveFormat = "0K"
        nf.multiplier = 0.001
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: nf)
        chartView.leftAxis.axisMinimum = 0
        chartView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension EventChartController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.chartDescription?.text = "\(rankingList.xAxisDetail[Int(entry.x)])\(Int(entry.y))"
    }
}

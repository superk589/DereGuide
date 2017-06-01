//
//  TeamSimulationScoreDistributionController.swift
//  CGSSGuide
//
//  Created by zzk on 2017/6/1.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Charts


protocol DistributionChartRepresentable {
    var dataSet: LineChartDataSet { get }
}

extension LSResult: DistributionChartRepresentable {
    
    var parzenH: Double {
        guard let max = scores.max(), let min = scores.min() else {
            return .infinity
        }
        return 4 * Double(max - min) / sqrt(Double(scores.count))
    }
    
    var dataSet: LineChartDataSet {
        
        var entries = [ChartDataEntry]()
        let sortedScores = scores.sorted()
        
        let h = parzenH
        
        guard let max = scores.max(), let min = scores.min() else {
            fatalError()
        }
        
        let step = (max + 2 * Int(h) - min) / 400
        var current = min - Int(h)
        
        var lastIndex = 0
        
        
        func k(_ value: Double) -> Double {
            //        return 1 / sqrt(2 * Double.pi) * pow(M_E, -value * value / 2)
            return 1 / 2
        }

        while current <= max + Int(h) {
            var kx = 0.0
            for score in sortedScores[lastIndex..<sortedScores.count] {
                if Double(score - current) < -h {
                    lastIndex += 1
                    continue
                } else if Double(abs(score - current)) <= h {
                    kx += k(Double(score - current) / h)
                } else {
                    break
                }
            }
            entries.append(ChartDataEntry.init(x: Double(current), y: kx / h / Double(scores.count)))
            current += step
        }
        return LineChartDataSet.init(values: entries, label: nil)
    }
}

class TeamSimulationScoreDistributionController: BaseViewController {

    var result: LSResult!
    var chartView: LineChartView!
    
    convenience init(result: LSResult) {
        self.init()
        self.result = result
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomLabel = UILabel()
        bottomLabel.text = NSLocalizedString("* 本图是得分分布的近似概率密度函数，纵坐标代表某值的概率密度，模拟次数越多，曲线越准确", comment: "")
        bottomLabel.textColor = UIColor.darkGray
        bottomLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(bottomLabel)
        bottomLabel.numberOfLines = 0
        
        bottomLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        chartView = LineChartView()
        view.addSubview(chartView)
        
        chartView.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalTo(bottomLabel.snp.top).offset(-10)
            make.left.right.equalToSuperview()
        }
        
        
        let dataSet = result.dataSet
        dataSet.setColor(Color.parade)
        dataSet.drawCirclesEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.lineWidth = 2
        dataSet.drawValuesEnabled = false
        
        let data = LineChartData.init(dataSets: [dataSet])
        
        chartView.legend.enabled = false
        chartView.data = data
        chartView.chartDescription?.text = ""
        chartView.chartDescription?.font = UIFont.systemFont(ofSize: 14)
        chartView.chartDescription?.textColor = UIColor.darkGray
        chartView.xAxis.labelPosition = .bottom
        chartView.rightAxis.enabled = false
        chartView.xAxis.granularity = 1
        chartView.scaleYEnabled = false
        chartView.leftAxis.drawBottomYLabelEntryEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.marker = MarkerView(frame: CGRect.init(x: 0, y: 0, width: 40, height: 20))
        
        let nf = NumberFormatter()
        nf.roundingMode = .halfUp
//        nf.maximumFractionDigits = 2
        nf.numberStyle = .scientific
        nf.exponentSymbol = "e"
        nf.maximumFractionDigits = 1
//        nf.multiplier = 10000
//        nf.positiveFormat = "0.00e-5"
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: nf)
        chartView.leftAxis.axisMinimum = 0
        chartView.delegate = self

    }
}

extension TeamSimulationScoreDistributionController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.chartDescription?.text = String.init(format: "%d: %.2e", Int(entry.x), entry.y)
    }
}

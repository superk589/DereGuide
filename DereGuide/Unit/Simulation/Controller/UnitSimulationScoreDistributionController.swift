//
//  UnitSimulationScoreDistributionController.swift
//  DereGuide
//
//  Created by zzk on 2017/6/1.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Charts

protocol DistributionChartRepresentable {
    var dataSet: LineChartDataSet { get }
}

extension LSResult: DistributionChartRepresentable {
    
    var dataSet: LineChartDataSet {
        
        var entries = [ChartDataEntry]()
        let h = self.h
        let step = (maxScore + 2 * Int(h) - minScore) / 400
        var current = minScore - Int(h)
        var lastIndex = 0
        let scores = self.reversed
        while current <= maxScore + Int(h) {
            var k = 0.0
            for score in scores[lastIndex..<scores.count] {
                if Double(score - current) < -h {
                    lastIndex += 1
                    continue
                } else if Double(abs(score - current)) <= h {
                    k += Kernel.uniformUnchecked(Double(score - current), h)
                } else {
                    break
                }
            }
            entries.append(ChartDataEntry.init(x: Double(current), y: k / Double(scores.count)))
            current += step
        }
        return LineChartDataSet.init(entries: entries, label: nil)
    }
}

class UnitSimulationScoreDistributionController: BaseViewController {

    var result: LSResult!
    var chartView: LineChartView!
    
    convenience init(result: LSResult) {
        self.init()
        self.result = result
        self.navigationItem.title = NSLocalizedString("得分分布", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomLabel = UILabel()
        bottomLabel.text = NSLocalizedString("* 本图是得分分布的近似概率密度曲线，模拟次数越多越精确", comment: "")
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
        
        let data = LineChartData(dataSets: [])
        
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
        nf.maximumFractionDigits = 2
//        nf.multiplier = 10000
//        nf.positiveFormat = "0.00e-5"
        chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: nf)
        chartView.leftAxis.axisMinimum = 0
        chartView.delegate = self
        
        CGSSLoadingHUDManager.default.show()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let strongSelf = self {
                let dataSet = strongSelf.result.dataSet
                dataSet.setColor(.parade)
                dataSet.drawCirclesEnabled = false
                dataSet.drawCircleHoleEnabled = false
                dataSet.lineWidth = 2
                dataSet.drawValuesEnabled = false
                DispatchQueue.main.async {
                    data.addDataSet(dataSet)
                    strongSelf.chartView.notifyDataSetChanged()
                    CGSSLoadingHUDManager.default.hide()
                }
            } else {
                DispatchQueue.main.async {
                    CGSSLoadingHUDManager.default.hide()
                }
            }
        }
    }
}

extension UnitSimulationScoreDistributionController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartView.chartDescription?.text = String.init(format: "%d: %.2e", Int(entry.x), entry.y)
    }
}

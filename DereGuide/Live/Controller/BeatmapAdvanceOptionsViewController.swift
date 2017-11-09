//
//  BeatmapAdvanceOptionsViewController.swift
//  DereGuide
//
//  Created by zzk on 16/10/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol BeatmapAdvanceOptionsViewControllerDelegate: class {
    func didDone(_ beatmapAdvanceOptionsViewController: BeatmapAdvanceOptionsViewController)
}

class BeatmapAdvanceOptionsViewController: UITableViewController {
    
    weak var delegate: BeatmapAdvanceOptionsViewControllerDelegate?
    
    var sectionTitles = [NSLocalizedString("颜色方案", comment: ""),
                         NSLocalizedString("绘制参数", comment: "")]
    
    struct Setting: Equatable, Codable {
        
        enum ColorTheme: Int, Codable, CustomStringConvertible {
            case single
            case type3
            case type4
            var description: String {
                switch self {
                case .single:
                    return NSLocalizedString("与歌曲颜色相同", comment: "")
                case .type3:
                    return "TYPE 3"
                case .type4:
                    return "TYPE 4"
                }
            }
            
        }
        
        static func ==(lhs: BeatmapAdvanceOptionsViewController.Setting, rhs: BeatmapAdvanceOptionsViewController.Setting) -> Bool {
            if lhs.theme == rhs.theme && lhs.verticalScale == rhs.verticalScale && lhs.showsPlayLine == rhs.showsPlayLine {
                return true
            } else {
                return false
            }
        }
        
        var theme: ColorTheme
        var verticalScale: CGFloat
        var showsPlayLine: Bool
        
//        var isMirrorFlipped: Bool
        
        func save() {
            try? JSONEncoder().encode(self).write(to: URL.init(fileURLWithPath: Path.document + "/beatmapSettings.json"))
        }
        
        static func load() -> Setting? {
            let decoder = JSONDecoder()
            guard let data = try? Data(contentsOf: URL.init(fileURLWithPath: Path.document + "/beatmapSettings.json")) else {
                return nil
            }
            let setting = try? decoder.decode(Setting.self, from: data)
            return setting
        }
       
        init() {
            theme = .type4
            verticalScale = 1.0
            showsPlayLine = true
        }
    }
    
    var setting: Setting!
    
    var stepperCell: UnitAdvanceOptionsTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("选项", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        
        tableView.register(BeatmapColorThemeTableViewCell.self, forCellReuseIdentifier: BeatmapColorThemeTableViewCell.description())
        
        prepareStaticCells()
        
        tableView.register(ColleagueFilterCardCell.self, forCellReuseIdentifier: ColleagueFilterCardCell.description())
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
    }
    
    private var staticCells = [UITableViewCell]()
    private func prepareStaticCells() {
        let option1 = StepperOption()
        option1.stepper.stepValue = 0.1
        option1.stepper.numberFormatter.maximumFractionDigits = 1
        option1.stepper.numberFormatter.minimumFractionDigits = 1
        option1.addTarget(self, action: #selector(handleOption1Stepper(_:)), for: .valueChanged)
        option1.setup(title: NSLocalizedString("纵向缩放比例", comment: ""), minValue: 0.5, maxValue: 2.0, currentValue: Double(setting.verticalScale))
        let cell1 = UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(option1))
        
        let option2 = SwitchOption()
        option2.label.text = NSLocalizedString("自动播放时显示辅助线", comment: "")
        option2.switch.isOn = setting.showsPlayLine
        option2.addTarget(self, action: #selector(handleOption2Switch(_:)), for: .valueChanged)
        let cell2 = UnitAdvanceOptionsTableViewCell(optionStyle: .switch(option2))
        staticCells = [cell1, cell2]
    }
    
    @objc func doneAction() {
        setting.save()
        dismiss(animated: true, completion: nil)
        delegate?.didDone(self)
    }
    
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleOption1Stepper(_ stepper: ValueStepper) {
        setting.verticalScale = CGFloat(stepper.value)
    }
    
    @objc private func handleOption2Switch(_ `switch`: UISwitch) {
        setting.showsPlayLine = `switch`.isOn
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return staticCells.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: BeatmapColorThemeTableViewCell.description(), for: indexPath) as! BeatmapColorThemeTableViewCell
            switch indexPath.row {
            case 0:
                cell.setup(.single)
                cell.customSelected = setting.theme == .single
            case 1:
                cell.setup(.type3)
                cell.customSelected = setting.theme == .type3
            case 2:
                cell.setup(.type4)
                cell.customSelected = setting.theme == .type4
            default:
                fatalError("invalid indexpath")
            }
            return cell
        case 1:
            return staticCells[indexPath.row]
        default:
            fatalError("invalid section")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                setting.theme = .single
            case 1:
                setting.theme = .type3
            case 2:
                setting.theme = .type4
            default:
                break
            }
            tableView.reloadSections([0], with: .none)
        default:
            break
        }
    }
    
}

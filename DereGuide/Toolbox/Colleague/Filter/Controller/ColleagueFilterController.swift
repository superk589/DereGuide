//
//  ColleagueFilterController.swift
//  DereGuide
//
//  Created by zzk on 2017/8/15.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit

protocol ColleagueFilterControllerDelegate: class {
    func didDone(_ colleagueFilterController: ColleagueFilterController)
}

class ColleagueFilterController: UITableViewController {
    
    weak var delegate: ColleagueFilterControllerDelegate?
    
    var sectionTitles = [NSLocalizedString("位置", comment: ""),
                         NSLocalizedString("潜能", comment: ""),
                         NSLocalizedString("偶像", comment: "")]
    var footerTitles = [NSLocalizedString("目前仅支持筛选单个位置，如果您不需要筛选请设置为\"不限\"", comment: ""),
                        "",
                        NSLocalizedString("* 左滑删除", comment: "")]

    struct FilterSetting: Equatable {
        
        var type: CGSSLiveTypes
        var cardIDs: [Int]
        var minLevel: Int
        var minVocalLevel: Int
        var minVisualLevel: Int
        var minDanceLevel: Int
        var minLifeLevel: Int
        
        func toDictionary() -> [String: Any] {
            return ["type": type.rawValue,
                    "cardIDs": cardIDs,
                    "minLevel": minLevel,
                    "minVocalLevel": minVocalLevel,
                    "minDanceLevel": minDanceLevel,
                    "minVisualLevel": minVisualLevel,
                    "minLifeLevel": minLifeLevel
            ]
        }
        
        func save() {
            (toDictionary() as NSDictionary).write(toFile: Path.document + "/colleagueFinderSettings.plist", atomically: true)
        }
        
        mutating func load() {
            if let dict = NSDictionary(contentsOfFile: Path.document + "/colleagueFinderSettings.plist") {
                self.type = CGSSLiveTypes(rawValue: dict["type"] as! UInt)
                self.cardIDs = dict["cardIDs"] as! [Int]
                self.minLevel = dict["minLevel"] as! Int
                self.minVocalLevel = dict["minVocalLevel"] as? Int ?? 0
                self.minDanceLevel = dict["minDanceLevel"] as? Int ?? 0
                self.minVisualLevel = dict["minVisualLevel"] as? Int ?? 0
                self.minLifeLevel = dict["minLifeLevel"] as? Int ?? 0
            }
        }
        
        var predicate: NSPredicate {
            if cardIDs.count > 0 {
                switch type {
                case CGSSLiveTypes.cute:
                    return NSPredicate(format: "cuteCardID IN %@ AND cuteTotalLevel >= %ld AND cuteVocalLevel >= %ld AND cuteDanceLevel >= %ld AND cuteVisualLevel >= %ld AND cuteLifeLevel >= %ld", cardIDs, minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                case CGSSLiveTypes.allType:
                    return NSPredicate(format: "allTypeCardID IN %@ AND allTypeTotalLevel >= %ld AND allTypeVocalLevel >= %ld AND allTypeDanceLevel >= %ld AND allTypeVisualLevel >= %ld AND allTypeLifeLevel >= %ld", cardIDs, minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                case CGSSLiveTypes.cool:
                    return NSPredicate(format: "coolCardID IN %@ AND coolTotalLevel >= %ld AND coolVocalLevel >= %ld AND coolDanceLevel >= %ld AND coolVisualLevel >= %ld AND coolLifeLevel >= %ld", cardIDs, minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                case CGSSLiveTypes.passion:
                    return NSPredicate(format: "passionCardID IN %@ AND passionTotalLevel >= %ld AND passionVocalLevel >= %ld AND passionDanceLevel >= %ld AND passionVisualLevel >= %ld AND passionLifeLevel >= %ld", cardIDs, minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                default:
                    return NSPredicate(value: true)
                }
            } else {
                switch type {
                case CGSSLiveTypes.cute:
                    return NSPredicate(format: "cuteTotalLevel >= %ld AND cuteVocalLevel >= %ld AND cuteDanceLevel >= %ld AND cuteVisualLevel >= %ld AND cuteLifeLevel >= %ld", minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                case CGSSLiveTypes.allType:
                    return NSPredicate(format: "allTypeTotalLevel >= %ld AND allTypeVocalLevel >= %ld AND allTypeDanceLevel >= %ld AND allTypeVisualLevel >= %ld AND allTypeLifeLevel >= %ld", minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                case CGSSLiveTypes.cool:
                    return NSPredicate(format: "coolTotalLevel >= %ld AND coolVocalLevel >= %ld AND coolDanceLevel >= %ld AND coolVisualLevel >= %ld AND coolLifeLevel >= %ld", minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                case CGSSLiveTypes.passion:
                    return NSPredicate(format: "passionTotalLevel >= %ld AND passionVocalLevel >= %ld AND passionDanceLevel >= %ld AND passionVisualLevel >= %ld AND passionLifeLevel >= %ld", minLevel, minVocalLevel, minDanceLevel, minVisualLevel, minLifeLevel)
                default:
                    return NSPredicate(value: true)
                }
            }
        }
    }
    
    lazy var cardSelectionViewController: UnitCardSelectTableViewController = {
        let vc = UnitCardSelectTableViewController()
        vc.delegate = self
        return vc
    }()
    
    var lastSelectedIndex: Int?
    
    var setting = FilterSetting(type: [], cardIDs: [], minLevel: 0, minVocalLevel: 0, minVisualLevel: 0, minDanceLevel: 0, minLifeLevel: 0)
    
    var totalStepperOption: StepperOption!
    var vocalStepperOption: StepperOption!
    var danceStepperOption: StepperOption!
    var visualStepperOption: StepperOption!
    var lifeStepperOption: StepperOption!
    
    var stepperCells = [UnitAdvanceOptionsTableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load the saved setting only when user open this page, otherwise use the default setting
        setting.load()
        
        navigationItem.title = NSLocalizedString("筛选条件", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        
        tableView.register(ColleagueFilterTypeCell.self, forCellReuseIdentifier: ColleagueFilterTypeCell.description())
        tableView.register(ColleagueFilterCardCell.self, forCellReuseIdentifier: ColleagueFilterCardCell.description())
        tableView.cellLayoutMarginsFollowReadableWidth = false
        tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        totalStepperOption = createSteppterOption(minValue: 0, maxValue: Double(Config.maximumTotalPotential), currentValue: Double(setting.minLevel), tintColor: .parade, title: NSLocalizedString("最低潜能等级", comment: ""))
        stepperCells.append(UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(totalStepperOption)))
        
        vocalStepperOption = createSteppterOption(minValue: 0, maxValue: Double(Config.maximumSinglePotential), currentValue: Double(setting.minVocalLevel), tintColor: .vocal, title: String(format: NSLocalizedString("最低%@等级", comment: ""), "Vocal"))
        stepperCells.append(UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(vocalStepperOption)))
        
        danceStepperOption = createSteppterOption(minValue: 0, maxValue: Double(Config.maximumSinglePotential), currentValue: Double(setting.minDanceLevel), tintColor: .dance, title: String(format: NSLocalizedString("最低%@等级", comment: ""), "Dance"))
        stepperCells.append(UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(danceStepperOption)))
        
        visualStepperOption = createSteppterOption(minValue: 0, maxValue: Double(Config.maximumSinglePotential), currentValue: Double(setting.minVisualLevel), tintColor: .visual, title: String(format: NSLocalizedString("最低%@等级", comment: ""), "Visual"))
        stepperCells.append(UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(visualStepperOption)))
        
        lifeStepperOption = createSteppterOption(minValue: 0, maxValue: Double(Config.maximumSinglePotential), currentValue: Double(setting.minLifeLevel), tintColor: .life, title: String(format: NSLocalizedString("最低%@等级", comment: ""), "Life"))
        stepperCells.append(UnitAdvanceOptionsTableViewCell(optionStyle: .stepper(lifeStepperOption)))
        
    }
    
    private func createSteppterOption(minValue: Double, maxValue: Double, currentValue: Double, tintColor: UIColor, title: String) -> StepperOption {
        let option = StepperOption()
        option.setup(title: title, minValue: minValue, maxValue: maxValue, currentValue: currentValue)
        option.stepper.tintColor = tintColor
        option.addTarget(self, action: #selector(handleStepper(_:)), for: .valueChanged)
        return option
    }
    
    @objc func doneAction() {
        setting.save()
        dismiss(animated: true, completion: nil)
        delegate?.didDone(self)
    }
    
    @objc func cancelAction() {
        setting.load()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleStepper(_ stepper: ValueStepper) {
        if stepper == totalStepperOption.stepper {
            setting.minLevel = Int(stepper.value)
        } else if stepper == vocalStepperOption.stepper {
            setting.minVocalLevel = Int(stepper.value)
        } else if stepper == danceStepperOption.stepper {
            setting.minDanceLevel = Int(stepper.value)
        } else if stepper == visualStepperOption.stepper {
            setting.minVisualLevel = Int(stepper.value)
        } else if stepper == lifeStepperOption.stepper {
            setting.minLifeLevel = Int(stepper.value)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if setting.type == [] {
            return 1
        } else {
            return sectionTitles.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footerTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            if setting.type == [] {
                return 0
            } else {
                return stepperCells.count
            }
        case 2:
            if setting.type == [] {
                return 0
            } else {
                return setting.cardIDs.count + 1
            }
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColleagueFilterTypeCell.description(), for: indexPath) as! ColleagueFilterTypeCell
            if indexPath.row < 4 {
                let type = CGSSLiveTypes.init(type: indexPath.row)
                cell.setup(type)
                cell.customSelected = setting.type == type
            } else {
                cell.setup([])
                cell.customSelected = setting.type == []
            }
            return cell
        case 1:
            return stepperCells[indexPath.row]
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ColleagueFilterCardCell.description(), for: indexPath) as! ColleagueFilterCardCell
            if indexPath.row < setting.cardIDs.count {
                cell.setup(cardID: setting.cardIDs[indexPath.row])
            } else {
                cell.setupWithoutCard()
            }
            return cell
        default:
            fatalError("invalid section")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if indexPath.row < 4 {
                setting.type = CGSSLiveTypes.init(type: indexPath.row)
                if tableView.numberOfSections == 1 {
                    tableView.insertSections([1, 2], with: .automatic)
                }
            } else {
                setting.type = []
                if tableView.numberOfSections == 3 {
                    tableView.deleteSections([1, 2], with: .automatic)
                }
            }
            tableView.reloadSections([0], with: .none)
        case 2:
            lastSelectedIndex = indexPath.row
            navigationController?.pushViewController(cardSelectionViewController, animated: true)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 0, 1:
            return .none
        case 2:
            if indexPath.row < setting.cardIDs.count {
                return .delete
            } else {
                return .insert
            }
        default:
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            lastSelectedIndex = indexPath.row
        } else if editingStyle == .delete {
            setting.cardIDs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ColleagueFilterController: BaseCardTableViewControllerDelegate {
    
    func selectCard(_ card: CGSSCard) {
        if lastSelectedIndex! >= setting.cardIDs.count {
            setting.cardIDs.append(card.id)
            tableView.insertRows(at: [IndexPath.init(row: lastSelectedIndex! + 1, section: 2)], with: .automatic)
            tableView.reloadRows(at: [IndexPath.init(row: lastSelectedIndex!, section: 2)], with: .automatic)
        } else {
            setting.cardIDs[lastSelectedIndex!] = card.id
            tableView.reloadRows(at: [IndexPath.init(row: lastSelectedIndex!, section: 2)], with: .automatic)
        }
    }
    
}

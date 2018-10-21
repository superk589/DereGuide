//
//  CharaDetailViewController.swift
//  DereGuide
//
//  Created by zzk on 16/8/21.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit
import SnapKit

class CharaDetailViewController: BaseTableViewController {
    
    var chara: CGSSChar! {
        didSet {
            loadDataAsync()
        }
    }
    
    private var songs = [CGSSSong]()
    
    lazy var cards: [CGSSCard] = {
        var cards = CGSSDAO.shared.findCardsByCharId(self.chara.charaId)
        let sorter = CGSSSorter.init(property: "sAlbumId")
        sorter.sortList(&cards)
        return cards
    }()
    
    private struct Row: CustomStringConvertible {
        var type: UITableViewCell.Type
        var description: String {
            return type.description()
        }
    }
    
    private var rows = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        prepareNavigationBar()
    }
    
    private func prepareNavigationBar() {
        let rightItem = UIBarButtonItem(image: FavoriteCharasManager.shared.contains(chara.charaId) ? UIImage(named: "748-heart-toolbar-selected") : UIImage(named: "748-heart-toolbar"), style: .plain, target: self, action: #selector(addOrRemoveFavorite))
        rightItem.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightItem
    }
    
    // 添加当前角色到收藏
    @objc func addOrRemoveFavorite() {
        let manager = FavoriteCharasManager.shared
        if !manager.contains(chara.charaId) {
            manager.add(chara)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "748-heart-toolbar-selected")
        } else {
            manager.remove(chara.charaId)
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "748-heart-toolbar")
        }
    }
    
    private func loadDataAsync() {
        CGSSGameResource.shared.master.getMusicInfo(charaID: chara.charaId) { (songs) in
            DispatchQueue.main.async {
                self.songs = songs
                self.prepareRows()
                self.registerCells()
                self.tableView?.reloadData()
                print("load chara \(self.chara.charaId!)")
            }
        }
    }
    
    private func prepareRows() {
        rows.removeAll()
        
        rows.append(Row(type: CharaDetailProfileTableViewCell.self))
        rows.append(Row(type: CharaDetailRelatedCardsTableViewCell.self))
        
        if songs.count > 0 {
            let row = Row(type: CharaDetailMVTableViewCell.self)
            self.rows.append(row)
        }
    }
    
    private func registerCells() {
        rows.forEach {
            tableView.register($0.type, forCellReuseIdentifier: $0.description)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.description, for: indexPath)
        switch cell {
        case let cell as CharaDetailProfileTableViewCell:
            cell.setup(chara: chara)
        case let cell as CharaDetailRelatedCardsTableViewCell:
            cell.cards = cards
            cell.delegate = self
        case let cell as CharaDetailMVTableViewCell:
            cell.setup(songs: songs)
            cell.layoutIfNeeded()
            cell.delegate = self
        default:
            break
        }
        return cell
    }
}

extension CharaDetailViewController: CardDetailMVCellDelegate {
    
    func cardDetailMVCell(_ cardDetailMVCell: CardDetailMVCell, didClickAt index: Int) {
        let vc = SongDetailController()
        vc.setup(songs: songs, index: index)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CharaDetailViewController: CardDetailRelatedCardsCellDelegate, CGSSIconViewDelegate {
    
    func didClickRightDetail(_ cardDetailRelatedCardsCell: CardDetailRelatedCardsCell) {
        
    }
    
    func iconClick(_ iv: CGSSIconView) {
        if let cardIcon = iv as? CGSSCardIconView, let id = cardIcon.cardID, let card = CGSSDAO.shared.findCardById(id) {
            let vc = CDTabViewController(card: card)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

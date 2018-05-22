//
//  CardTableViewController.swift
//  DereGuide
//
//  Created by zzk on 16/6/5.
//  Copyright © 2016 zzk. All rights reserved.
//

import UIKit

class CardTableViewController: BaseCardTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        print(Locale.preferredLanguages.first ?? "")
        
        if UserDefaults.standard.value(forKey: "DownloadAtStart") as? Bool ?? true {
            check(.all)
        }
        
        registerForPreviewing(with: self, sourceView: view)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let card = cardList[indexPath.row]
        let vc = CDTabViewController(card: card)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

@available(iOS 9.0, *)
extension CardTableViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        viewControllerToCommit.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        
        let card = cardList[indexPath.row]
        let vc = CDTabViewController(card: card)

        vc.preferredContentSize = CGSize(width: view.shortSide, height: CGSSGlobal.spreadImageHeight * view.shortSide / CGSSGlobal.spreadImageWidth + 68)
        
        previewingContext.sourceRect = cell.frame
        
        return vc
    }
}

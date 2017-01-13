//
//  EventViewController.swift
//  CGSSGuide
//
//  Created by zzk on 2016/10/9.
//  Copyright © 2016年 zzk. All rights reserved.
//

import UIKit

class EventViewController: RefreshableTableViewController {

    var eventList:[CGSSEvent]!
    var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventList = CGSSGameResource.sharedResource.getEvent()
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.rowHeight = 112
        // tableView.allowsSelection = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CGSSNotificationCenter.add(self, selector: #selector(refresh), name: CGSSNotificationCenter.updateEnd, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CGSSNotificationCenter.removeAll(self)
    }
    
    override func refresh() {
        tableView.reloadData()
    }
    
    override func refresherValueChanged() {
        check(0b1000001)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        cell.setupWith(event: eventList[indexPath.row], bannerId: eventList.count - indexPath.row + 1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

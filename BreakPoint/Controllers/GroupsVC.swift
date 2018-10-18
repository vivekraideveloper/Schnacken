//
//  SecondViewController.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class GroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupsArray = [Group]()
    
    @IBOutlet weak var groupTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupTableView.rowHeight = 120
        groupTableView.separatorColor = UIColor.black
        groupTableView.separatorStyle = .singleLine
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupTableView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupCell else {return UITableViewCell()}
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, desc: group.groupDesc, members: group.memberCount) 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "groupFeedVC") as? GroupFeedVC else { return }
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
//        present(groupFeedVC, animated: true, completion: nil)
        presentDetail(groupFeedVC)
        
    }
}

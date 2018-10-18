//
//  FirstViewController.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black
        tableView.allowsSelection = false
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DataService.instance.getAllFeedmessages { (returnedmessageArray) in
            self.messageArray = returnedmessageArray.reversed()
            self.tableView.reloadData()
        }
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedCell else { return UITableViewCell() }
        
        DataService.instance.getUserName(forUID: messageArray[indexPath.row].senderId) { (userName) in
            cell.configureCell(profileImage: UIImage(named: "account")!, email: userName, content: self.messageArray[indexPath.row].content)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


//
//  GroupFeed VC.swift
//  BreakPoint
//
//  Created by Vivek Rai on 15/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var memberlabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var group: Group?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendView.bindToKeyboard()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        if self.groupMessages.count > 0 {
            self.feedTableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTitleLabel.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.memberlabel.text = returnedEmails.joined(separator: " | ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesForGroup(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.feedTableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.feedTableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    

    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUid: Auth.auth().currentUser!.uid, withGroupKey: group?.key, sendComplete: { (complete) in
                if complete {
                    self.messageTextField.text = ""
                    self.messageTextField.isEnabled = true
                    self.sendButton.isEnabled = true
                }
            })
        }
        
    }
}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getUserName(forUID: message.senderId) { (email) in
            cell.configureCell(profileImage: UIImage(named: "account")!, feedEmail: email, feedMessage: message.content)
        }
        return cell
    }
    
}


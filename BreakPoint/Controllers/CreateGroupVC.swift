//
//  CreateGroupVC.swift
//  BreakPoint
//
//  Created by Vivek Rai on 14/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {

    @IBOutlet weak var groupTitle: UITextField!
    @IBOutlet weak var groupDescription: UITextField!
    @IBOutlet weak var groupPeople: UITextField!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var peopleLabel: UILabel!
    
    var emailArray = [String]()
    var choosenArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupPeople.delegate = self
        groupPeople.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        doneButton.isHidden = true
    }
    
    @objc func textFieldChanged(){
        if groupPeople.text == ""{
            emailArray = []
            groupTableView.reloadData()
        }else{
            DataService.instance.getEmailForSearchQuery(searchQuery: groupPeople.text!) { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.groupTableView.reloadData()
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if groupTitle.text != "" && groupDescription.text != ""{
            DataService.instance.getIds(forUsernames: choosenArray) { (idsArray) in
                var userids = idsArray
                userids.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.groupTitle.text!, andDescription: self.groupDescription.text!, forUserIds: userids, handler: { (groupCreated) in
                    if groupCreated{
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("Group couldn't be created!")
                    }
                })
            }
        }
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserCell else{return UITableViewCell()}
        if choosenArray.contains(emailArray[indexPath.row]){
            cell.configureCell(profileImage: UIImage(named: "account")!, email: emailArray[indexPath.row], isSelected: true)
        }else{
            cell.configureCell(profileImage: UIImage(named: "account")!, email: emailArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else {
            return
        }
        
        if !choosenArray.contains(cell.userEmail.text!){
            choosenArray.append(cell.userEmail.text!)
            peopleLabel.text = choosenArray.joined(separator: ", ")
            doneButton.isHidden = false
        }else{
            choosenArray = choosenArray.filter({ $0 != cell.userEmail.text!})
            if choosenArray.count >= 1{
                peopleLabel.text = choosenArray.joined(separator: ", ")
                
            }else{
                peopleLabel.text = "Add People to the group..."
                doneButton.isHidden = true
            }
        }
    }
}

extension CreateGroupVC: UITextFieldDelegate{
    
}

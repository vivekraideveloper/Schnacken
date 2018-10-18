//
//  DataService.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE: DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference{
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference{
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference{
        return _REF_FEED
    }
    
    func createDBUSER(uid: String, userData: Dictionary<String, Any>) {
        _REF_USERS.child(uid).updateChildValues(userData)
    }
    
        
    func uploadPost(withMessage message: String, forUid uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        
        if groupKey != nil{
//            Send to group ref
            
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
            
        }else{
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
        
    }
    
    func getUserName(forUID uid: String, handler: @escaping (_ username: String)-> ()){
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let _userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else{ return }
            for user in _userSnapshot{
                if user.key == uid{
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
        
    }
    
    func  getAllFeedmessages(handler: @escaping(_ messages: [Message])-> () ){
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for message in feedMessageSnapshot{
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let _message = Message(content: content, sendrId: senderId)
                messageArray.append(_message)
            }
            
            handler(messageArray)
            
        }
        
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, sendrId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    
    func getAllMessagesForGroup(desiredGroup: Group, handler: @escaping (_ messageArray: [Message])-> ()){
        
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for groupMessage in groupMessageSnapshot{
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, sendrId: senderId)
                groupMessageArray.append(message)
            }
            
            handler(groupMessageArray)
        }
        
    }
    
    func getEmailForSearchQuery(searchQuery query: String, handler: @escaping(_ emailArray: [String]) -> ()){
        
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSanpshot) in
            
            guard let _userSnapshot = userSanpshot.children.allObjects as? [DataSnapshot] else {return}
            for user in _userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if email.contains(query) == true && email != Auth.auth().currentUser?.email{
                    emailArray.append(email)
                }
            }
            
            handler(emailArray)
        }
    }
    
    func getIds(forUsernames username: [String], handler: @escaping (_ uidArray: [String]) -> ()){
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot{
                let email = user.childSnapshot(forPath: "email").value as! String
                if username.contains(email){
                    idArray.append(user.key)
                }
            }
            
            handler(idArray)
            
        }
        
    }
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds id: [String], handler: @escaping(_ groupCreated: Bool) -> ()){
        
        REF_GROUPS.childByAutoId().updateChildValues(["title" : title, "descriptions": description, "members": id])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping(_ groupsArray: [Group]) -> ()){
        
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot
                ] else {return}
            
            for  group in groupSnapshot{
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!){
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "descriptions").value as! String
                    
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
}






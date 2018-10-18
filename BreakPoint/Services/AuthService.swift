//
//  AuthService.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import Foundation
import Firebase


class AuthService {
    
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, withPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil{
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": Auth.auth().currentUser?.providerID, "email": email]
            
            DataService.instance.createDBUSER(uid: (Auth.auth().currentUser?.uid)!, userData: userData)
            
            userCreationComplete(true, nil)
        }
        
        
    }
    
    func loginUser(withEmail email: String, withPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil{
                loginComplete(false, error)
                return
            }
            
            loginComplete(true, nil)
        }
        
    }
    
}

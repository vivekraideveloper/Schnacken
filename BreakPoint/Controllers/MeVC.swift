//
//  MeVC.swift
//  BreakPoint
//
//  Created by Vivek Rai on 13/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD
import FBSDKLoginKit

class MeVC: UIViewController {
    
    let loginManager = FBSDKLoginManager()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        Update User email here
        
        
    }
    
    func socialLogout(){
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        for info in (user.providerData){
            switch info.providerID{
            case GoogleAuthProviderID:
                GIDSignIn.sharedInstance()?.signOut()
                print("google")
            case FacebookAuthProviderID:
                loginManager.logOut()
                print("Facebook")
            case TwitterAuthProviderID:
                print("Twitter")
            default:
                break
            }
        }
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        
        
        
        let logoutPopUp = UIAlertController(title: "Logout", message: "Do you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            SVProgressHUD.show()
            
            do {
                self.socialLogout()
                try Auth.auth().signOut()
                print("SignOut Pressed")
                SVProgressHUD.dismiss(withDelay: 3, completion: {
                    self.performSegue(withIdentifier: "logout", sender: self)
                })
                
            } catch let err {
                print(err)
                SVProgressHUD.dismiss()
            }
            
        }
        
        logoutPopUp.addAction(logoutAction)
        present(logoutPopUp, animated: true, completion: nil)
        
        
        
        
    }
    
}

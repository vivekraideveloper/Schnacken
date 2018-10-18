//
//  AuthVC.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class AuthVC: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    let loginManager = FBSDKLoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (Auth, user) in
            if user != nil{
                self.performSegue(withIdentifier: "socialLogin", sender: self)
                print("User logged in!")
            }
        }
    }
    
    @IBAction func facebookSignUpButton(_ sender: Any) {
        
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if let error  = error{
                debugPrint("Error ocurred while Login: \(error)")
            }else if (result?.isCancelled)!{
                print("FB Login was cancelled")
            }else{
                let credential = FacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!)
                self.firebaseLogin(credential)
            }
            
        }
        
    }
    
    @IBAction func googleSignUpButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func emailSignUpButton(_ sender: Any) {
        
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
        
    }
    
    @IBAction func googleSignInButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func firebaseLogin(_ credential: AuthCredential){
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("Error occured \(error.localizedDescription)")
                return
            }
            
        }
    }
    
//    Facebook Methods when UIView is used
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error{
            debugPrint("Error while login \(error)")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        firebaseLogin(credential)
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        
        
    }
    
    
}

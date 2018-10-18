//
//  AppDelegate.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
//        Email SigIn
        if Auth.auth().currentUser == nil{
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let authVC = storyBoard.instantiateViewController(withIdentifier: "AuthVC")
            window?.makeKeyAndVisible()
            window?.rootViewController?.present(authVC, animated: true, completion: nil)
        }
        
//        Google SignIn
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
//        FB SignIn
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let  error = error{
            debugPrint("Could not sign in with google \(error)")
        }else{
            guard let controller = GIDSignIn.sharedInstance()?.uiDelegate as? AuthVC else {return}
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            controller.firebaseLogin(credential)
        }
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let returnGoogle = GIDSignIn.sharedInstance()?.handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let returnFacebook = FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options)
        
        return returnGoogle! || returnFacebook!
        
    }
    

    

}


//
//  LoginVC.swift
//  BreakPoint
//
//  Created by Vivek Rai on 11/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        SVProgressHUD.show()
        
        if emailTextField.text != nil && passwordTextField.text != nil{
            
            AuthService.instance.loginUser(withEmail: emailTextField.text!, withPassword: passwordTextField.text!) { (success, error) in
                
                if success{
//                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "success", sender: self)
                }else{
                    SVProgressHUD.dismiss()
                    print(String(describing: error?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.emailTextField.text!, withPassword: self.passwordTextField.text!
                    , userCreationComplete: { (success, error) in
                        
                        
                        if success{
                            AuthService.instance.loginUser(withEmail: self.emailTextField.text!, withPassword: self.passwordTextField.text!, loginComplete: { (success, nil) in
                                    print("Successfully registered user!")
                                SVProgressHUD.dismiss()
//                                    self.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "success", sender: self)
                                
                            })
                        }else{
                            SVProgressHUD.dismiss()
                            print(String(describing: error?.localizedDescription))
                        }
                        
                })
            }
        }
        
    }
    
}

extension LoginVC: UITextFieldDelegate{
    
}

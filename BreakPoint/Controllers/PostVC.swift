//
//  PostVC.swift
//  BreakPoint
//
//  Created by Vivek Rai on 13/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase

class PostVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        postButton.bindToKeyboard()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.email.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        if textField.text != nil && textField.text != "Say something here..."{
            postButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: textField.text, forUid: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (success) in
                if success{
                    self.postButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.postButton.isEnabled = true
                    print("There was an error uploading the post!")
                }
            }
            
        }
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PostVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textField.text = ""
    }
}

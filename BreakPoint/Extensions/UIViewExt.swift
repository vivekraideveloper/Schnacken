//
//  UIViewExt.swift
//  BreakPoint
//
//  Created by Vivek Rai on 13/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

extension UIView{
    
    func bindToKeyboard() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyBoardWillChange(_ notification: NSNotification) {
    
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
        
    }
}

//
//  UIViewControllerExt.swift
//  BreakPoint
//
//  Created by Vivek Rai on 16/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: true, completion: nil)
        
    }
    
    func dismissDetail() {
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
        
    }
    
}

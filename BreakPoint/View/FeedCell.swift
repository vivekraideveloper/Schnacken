//
//  FeedCell.swift
//  BreakPoint
//
//  Created by Vivek Rai on 13/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    
    
    func configureCell(profileImage: UIImage, email: String, content: String) {
        
        self.profileImage.image = profileImage
        self.userEmail.text = email
        self.userMessage.text = content
        
    }
    
}

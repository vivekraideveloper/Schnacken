//
//  UserCell.swift
//  BreakPoint
//
//  Created by Vivek Rai on 14/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    
    var showing: Bool = false
    
    
    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
        self.profileImage.image = image
        self.userEmail.text = email
        if isSelected{
            self.checkMarkImage.isHidden = false
        }else{
            self.checkMarkImage.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected{
            if showing == false{
                checkMarkImage.isHidden = false
                showing = true
            }else{
                checkMarkImage.isHidden = true
                showing = false
            }
            
        }
    }

}

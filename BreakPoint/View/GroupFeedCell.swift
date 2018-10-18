//
//  GroupFeedCell.swift
//  BreakPoint
//
//  Created by Vivek Rai on 15/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedEmail: UILabel!
    @IBOutlet weak var feedMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(profileImage: UIImage, feedEmail: String, feedMessage: String) {
        self.feedImage.image = profileImage
        self.feedEmail.text = feedEmail
        self.feedMessage.text = feedMessage
        
    }

}

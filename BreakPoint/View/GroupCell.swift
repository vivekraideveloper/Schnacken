//
//  GroupCell.swift
//  BreakPoint
//
//  Created by Vivek Rai on 14/10/18.
//  Copyright © 2018 Vivek Rai. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var groupMembers: UILabel!
    
    func configureCell(title: String, desc: String, members: Int ){
        
        groupTitle.text = title
        groupDescription.text = desc
        groupMembers.text = "\(members) Members"
        
    }
    
}

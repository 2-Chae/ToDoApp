//
//  CustomTableViewCell.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 03/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var tfTaskName: UILabel!
    @IBOutlet var tfDueDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

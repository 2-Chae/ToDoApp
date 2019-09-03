//
//  CustomTableViewCell.swift
//  ToDo
//
//  Created by Chaehyeon Lee on 03/09/2019.
//  Copyright © 2019  Chaehyeon Lee. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var lblTaskName: UILabel!
    @IBOutlet var lblDeadline: UILabel!
    @IBOutlet var lblContent: UILabel!
    @IBOutlet var completeCheckBtn: UIButton!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lblTaskName.text = nil
        lblDeadline.text = nil
        lblDeadline.sizeToFit()
        lblContent.text = nil
    }

}

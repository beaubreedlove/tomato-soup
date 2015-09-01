//
//  ErrorCell.swift
//  tomato-soup
//
//  Created by Beau Breedlove on 8/31/15.
//  Copyright (c) 2015 Tumblr. All rights reserved.
//

import UIKit

class ErrorCell: UITableViewCell {

    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

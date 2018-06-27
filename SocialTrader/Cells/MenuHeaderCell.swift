//
//  MenuHeaderCell.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-25.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class MenuHeaderCell: UITableViewCell {
    @IBOutlet weak var photo: UIImageView?
    @IBOutlet weak var fname: UILabel?
    @IBOutlet weak var lname: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

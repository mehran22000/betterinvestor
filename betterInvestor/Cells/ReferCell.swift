//
//  ReferCell.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-26.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class ReferCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel?
    @IBOutlet weak var iconImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

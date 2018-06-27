//
//  ProductCell.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-25.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class ProductCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel?
    @IBOutlet weak var buyBtn: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

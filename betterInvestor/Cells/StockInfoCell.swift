//
//  StockInfoCell.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-29.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class StockInfoCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel?;
    @IBOutlet weak var subtitleLbl: UILabel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

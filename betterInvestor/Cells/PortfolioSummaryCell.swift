//
//  PortfolioSummaryCell.swift
//  betterInvestor
//
//  Created by mehran  on 2018-02-03.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class PortfolioSummaryCell: UITableViewCell {

    @IBOutlet var cashLbl: UILabel?;
    @IBOutlet var stockLbl: UILabel?;
    @IBOutlet var totalGainLbl: UILabel?;
    @IBOutlet var rankGlobalLbl: UILabel?;
    @IBOutlet var rankFrinedsLbl: UILabel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

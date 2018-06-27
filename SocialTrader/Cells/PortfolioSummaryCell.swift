//
//  PortfolioSummaryCell.swift
//  betterInvestor
//
//  Created by mehran  on 2018-02-03.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class PortfolioSummaryCell: UITableViewCell {

    @IBOutlet weak var cashLbl: UILabel?;
    @IBOutlet weak var stockLbl: UILabel?;
    @IBOutlet weak var totalGainLbl: UILabel?;
    @IBOutlet weak var rankGlobalLbl: UILabel?;
    @IBOutlet weak var rankFrinedsLbl: UILabel?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

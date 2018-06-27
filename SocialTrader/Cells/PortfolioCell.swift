//
//  PortfolioTableVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-05.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class PortfolioCell: UITableViewCell {
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var performanceBtn: UIButton!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        performanceBtn.layer.cornerRadius = 0.05 * performanceBtn.bounds.size.width
        performanceBtn.clipsToBounds = true
    }

}


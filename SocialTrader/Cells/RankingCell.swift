//
//  RankingCell.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-09.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class RankingCell: UITableViewCell {
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var performanceBtn: UIButton!
    
    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }
    
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

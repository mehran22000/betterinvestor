//
//  HolderCellTableViewCell.swift
//  betterInvestor
//
//  Created by mehran  on 2018-03-15.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class HolderCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var globalRank: UILabel!
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

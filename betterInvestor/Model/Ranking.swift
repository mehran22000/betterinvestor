//
//  Ranking.swift
//  betterInvestor
//
//  Created by mehran  on 2018-02-27.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

@objc class Ranking: NSObject {
    
    var user_id: String?
    var first_name: String?
    var last_name: String?
    var gain: String?
    var gain_pct: String?
    var photo_url: String?
    var rank: Int?
    
    
    init(_user_id:String, _first_name: String, _last_name: String, _gain: String, _gain_pct: String, _photo_url: String, _rank: Int) {
        
        self.user_id = _user_id;
        self.first_name = _first_name;
        self.last_name = _last_name;
        self.gain = _gain;
        self.gain_pct = _gain_pct;
        self.photo_url = _photo_url;
        self.rank = _rank;
    }

    
}

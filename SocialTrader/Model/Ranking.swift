//
//  Ranking.swift
//  betterInvestor
//
//  Created by mehran  on 2018-02-27.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

@objc class Ranking: NSObject {
    
    let user_id: String!
    let first_name: String!
    let last_name: String!
    let gain: String!
    let gain_pct: String!
    var photo_url: String?
    let rank: Int!
    var photo: UIImage?
    
    
    init(_user_id:String, _first_name: String, _last_name: String, _gain: String, _gain_pct: String, _photo_url: String,_rank: Int) {
        
        self.user_id = _user_id;
        self.first_name = _first_name;
        self.last_name = _last_name;
        self.gain = _gain;
        self.gain_pct = _gain_pct;
        self.photo_url = _photo_url;
        self.rank = _rank;
        self.photo = nil;
    }

    
}

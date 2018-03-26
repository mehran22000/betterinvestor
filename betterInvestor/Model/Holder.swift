//
//  Holder.swift
//  betterInvestor
//
//  Created by mehran  on 2018-03-14.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation


@objc class Holder: NSObject {
    
    var user_id: String?;
    var first_name: String?;
    var last_name: String?;
    var picUrl: String?;
    var photo: UIImage?;
    var pos: Position?;
    var global_ranking: Int?;
    
    init (_user_id:String,_first_name:String,_last_name:String,_picUrl: String, _pos: Position, _global_rank: Int){
        self.user_id = _user_id;
        self.first_name = _first_name;
        self.last_name = _last_name;
        self.picUrl = _picUrl;
        self.pos = _pos;
        self.global_ranking = _global_rank;
    }
    
}

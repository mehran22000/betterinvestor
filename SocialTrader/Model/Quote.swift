//
//  Quote.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-12.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation
class Quote {
    let symbol: String!
    var price: Double!
    var time: NSDate!
    
    init (symbol:String, price: Double, time:NSDate){
        self.symbol = symbol;
        self.price = price;
        self.time = time;
    }
    
    func update (price: Double, time: NSDate){
        self.price = price;
        self.time = time;
    }
}

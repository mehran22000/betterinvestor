//
//  Position.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-10.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

class Position {
    let symbol: String;
    let qty: NSInteger;
    let cost: Double;
    var gain: Double;
    
    init (symbol:String,qty:NSInteger,cost:Double){
        self.symbol = symbol;
        self.qty = qty;
        self.cost = cost;
        self.gain = 0;
    }
    
    func calculate_gain(quote: Quote){
        self.gain = Double(qty) * quote.price - cost;
    }
}

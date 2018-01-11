//
//  Position.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-10.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

class Position {
    let symbol: String!;
    let qty: NSInteger!;
    let cost: Double!;
    
    init (symbol:String,qty:NSInteger,cost:Double){
        self.symbol = symbol;
        self.qty = qty;
        self.cost = cost;
    }
}

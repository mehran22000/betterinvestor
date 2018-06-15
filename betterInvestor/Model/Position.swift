//
//  Position.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-10.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

@objc class Position:NSObject {
    @objc let symbol: String!;
    @objc let name: String!;
    @objc var gain_precentage: Double;
    
    let qty: NSInteger!;
    let cost: Double!;
    var gain: Double!;
    var value: Double!;
    
    init (symbol:String,qty:NSInteger,cost:Double,name: String){
        self.symbol = symbol;
        self.name = name;
        self.qty = qty;
        self.cost = cost;
        self.gain = 0;
        self.gain_precentage = 0;
        self.value = 0;
    }
    
    func calculate_gain(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let quote = appDelegate.market?.quotes[self.symbol];
        self.value = Double(qty) * (quote?.price)!;
        self.gain = self.value - cost;
        self.gain_precentage = (self.gain / self.cost) * 100;
    }
    
}

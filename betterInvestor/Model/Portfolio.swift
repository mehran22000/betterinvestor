//
//  Portfolio.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-10.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

class Portfolio {
    var positions : [Position]?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var total_gain: Double = 0;
    
    init() {
        self.positions = [Position]();
    }
    
    func addPosition (position:Position){
        self.positions?.insert(position, at:0);
    }
    
    func getStockList() -> String{
        var str = "";
        let posNo = positions?.count;
        if (posNo == 0){
            return "";
        }
        else {
            for i in 0...posNo!-1 {
                str = str + self.positions![i].symbol;
                if (i < posNo!-1) {
                    str = str + ","
                }
            }
            return str;
        }
    }
    
    func calculateGain() {
        
        let posNo = positions?.count;
        var total : Double = 0;
        
        if (posNo! >= 0) {
            for i in 0...posNo!-1 {
                let quote = appDelegate.market?.quotes[self.positions![i].symbol];
                self.positions![i].calculate_gain(quote:quote!)
                total = total + self.positions![i].gain;
            }
            self.total_gain = total;
        }
    }
    
    func getPosition(_symbol: String) -> Position?{
        let symbol = _symbol.lowercased();
        let posNo = positions?.count;
        for i in 0...posNo!-1 {
            if (self.positions![i].symbol == symbol) {
                return self.positions![i];
            }
        }
        return nil;
    }
    
}

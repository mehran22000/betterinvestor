//
//  Portfolio.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-10.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

@objc class Portfolio:NSObject {
    
    @objc var positions = [Position]();
    var cash: Double = 0;
    var realized: Double = 0;
    var credit: Double = 0;
    var total_cost: Double = 0;
    var total_stock_value: Double = 0;
    var total_gain: Double = 0;
    var total_gain_precentage: Double = 0;
    
    
    override init() {
    }
    
    func addPosition (position:Position){
        self.positions.insert(position, at:0);
    }
    
    func getStockList() -> String{
        var str = "";
        let posNo = positions.count;
        if (posNo == 0){
            return "";
        }
        else {
            for i in 0...posNo-1 {
                str = str + self.positions[i].symbol;
                if (i < posNo-1) {
                    str = str + ","
                }
            }
            return str;
        }
    }
    
    func calculateGain() {
        
        let posNo = positions.count;
        var total : Double = 0;
        var total_value: Double = 0;
        
        if (posNo > 0) {
            for i in 0...posNo-1 {
                self.positions[i].calculate_gain()
                self.total_cost = self.total_cost + self.positions[i].cost;
                total_value = total_value + self.positions[i].value;
                total = total + self.positions[i].gain;
            }
            self.total_stock_value = total_value;
            self.total_gain = total;
        }
        self.total_gain = self.total_gain + realized;
        if (self.total_cost > 0) {
            self.total_gain_precentage = (self.total_gain/self.total_cost) * 100;
        }
        else {
            self.total_gain_precentage = 0;
        }
    }
    
    
    func getPosition(_symbol: String) -> Position?{
        let symbol = _symbol;
        let posNo = positions.count;
        if (posNo == 0) {
            return nil;
        }
        else {
            for i in 0...posNo-1 {
                if (self.positions[i].symbol == symbol) {
                    return self.positions[i];
                }
            }
        }
        return nil;
    }
}

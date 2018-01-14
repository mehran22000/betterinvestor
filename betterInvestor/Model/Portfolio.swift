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
}

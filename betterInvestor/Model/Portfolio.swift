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
}

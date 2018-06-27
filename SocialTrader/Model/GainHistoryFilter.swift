//
//  GainHistoryFilter.swift
//  betterInvestor
//
//  Created by mehran  on 2018-03-04.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

@objc class GainHistoryFilter: NSObject {

    @objc func getSamples(_gainHistory:NSArray, _isMonth: Bool) -> NSMutableArray {
        var result = NSMutableArray();
        let maxSample:NSInteger;
        _isMonth == true ? (maxSample = 30) : (maxSample = 365)
        if (maxSample > _gainHistory.count) {
            result = _gainHistory as! NSMutableArray;
        }
        else {
            for i in 0..._gainHistory.count {
                result.add (_gainHistory[i]);
            }
        }
        return result;
    }

}



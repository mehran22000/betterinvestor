//
//  GainHistory.swift
//  betterInvestor
//
//  Created by mehran  on 2018-03-03.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation

@objc class GainHistoryItem: NSObject {
    @objc let dateStr: String
    @objc var date: Date?
    @objc var gain: Double
    @objc var day: Int
    @objc var month: Int
    @objc var year: Int
    @objc var monthStr: NSString
    
    var month_names = ["Jan","Feb","March","April","May","June","July","Aug","Sep","Oct","Nov","Dec"];
    
    
    init (_dateStr:String, _gain: Double){
        self.dateStr = _dateStr;
        self.gain = _gain;
        self.day = 0;
        self.month = 0;
        self.year = 0;
        self.monthStr = "";
    }
    
    init (_keyValStr:String){
        var str_no_brackets = _keyValStr.replacingOccurrences(of: "{", with: "");
        str_no_brackets = str_no_brackets.replacingOccurrences(of: "}", with: "");
        let key_val_array = str_no_brackets.split{$0 == ":"}.map(String.init)
        self.dateStr = key_val_array[0];
        self.gain = Double(key_val_array[1])!;
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self.date = dateFormatter.date(from: self.dateStr)!
        
        let calendar = Calendar.current
        
        self.year = calendar.component(.year, from: self.date!)
        self.month = calendar.component(.month, from: self.date!)
        self.day = calendar.component(.day, from: self.date!)
        
        self.monthStr = month_names[self.month-1] as NSString;
        
    }
}

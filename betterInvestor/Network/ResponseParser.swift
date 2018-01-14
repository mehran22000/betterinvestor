//
//  ResponseParser.swift
//  smarterInvestor
//
//  Created by mehran najafi on 2017-12-18.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation

class ResponseParser {
    
    class func parseUserPortfolio (json:NSDictionary, user: User){
        let data = json["data"] as! [NSDictionary];
        
        for index in 0...data.count-1  {
            let pos = Position(symbol:data[index].value(forKey: "symbol") as! String,
                               qty:data[index].value(forKey: "qty") as! NSInteger,
                               cost:data[index].value(forKey: "cost") as! Double);
            user.portfolio?.addPosition(position: pos);
        }
    }
    
    class func parseQuotes (json:NSDictionary, market: Market){
        
        let data = json["data"] as! NSDictionary;
        let date = NSDate()
        for (symbol, price) in data {
            print(symbol,price);
            let quote = Quote(symbol: symbol as! String,price: Double(price as! String)!, time:date);
            market.updateQuote(quote: quote);
        }
    }


}

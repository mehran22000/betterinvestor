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
        let data = json["data"] as! NSDictionary;
        let portfolio = data["portfolio"] as! [NSDictionary];
        if (portfolio.count > 0) {
            for index in 0...portfolio.count-1  {
                let pos = Position(symbol:portfolio[index].value(forKey: "symbol") as! String,
                               qty:portfolio[index].value(forKey: "qty") as! NSInteger,
                               cost:portfolio[index].value(forKey: "cost") as! Double,
                               name:portfolio[index].value(forKey: "name") as! String);
                user.portfolio?.addPosition(position: pos);
            }
        }
        user.portfolio?.cash = data["cash"] as? Double;
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

    class func parseSymbols (json:NSDictionary){
        
        let symbolsArray = json["symbols"] as! NSArray;
        let symbols = NSMutableArray();
        for sym in symbolsArray {
            let dic = sym as! NSDictionary;
            let symbol = Symbol(key: dic.object(forKey: "Symbol") as! String, name: dic.object(forKey: "Name") as! String)
            symbols.add(symbol);
        }
        
        UserDefaults.standard.set(symbolsArray, forKey: "symbols")
        
        let symbols_version = json["version"] as! String;
        UserDefaults.standard.set(symbols_version, forKey: "symbols_version")
    }
    
    
    class func parseUserGainHistory(json: NSDictionary,user: User) {
        
        let data = json["data"] as! NSDictionary;
        let gain_history = data["gain"] as! NSString;
        var arr = gain_history.components(separatedBy: ",")
        
        user.gain_history = NSMutableArray ()
        
        for index in 0...arr.count-1  {
            let gain_history_item = GainHistoryItem(_keyValStr: arr[index]);
            user.gain_history?.add(gain_history_item);
        }
    }
    
    
    class func parseUserRanking (json:NSDictionary, user: User, isGlobalRanking:Bool){
        let data = json["data"] as! NSDictionary;
        let ranking = data["ranking"] as! [NSDictionary];
        
        if (isGlobalRanking == true){
            user.global_ranking = NSMutableArray()
        }
        else {
            user.friend_ranking = NSMutableArray()
        }
        
        
        if (ranking.count > 0) {
            for index in 0...ranking.count-1  {
                let ranking = Ranking(_user_id: ranking[index].value(forKey: "user_id") as! String,
                                   _first_name: ranking[index].value(forKey: "first_name") as! String,
                                   _last_name: ranking[index].value(forKey: "last_name") as! String,
                                   _gain: ranking[index].value(forKey: "gain") as! String,
                                   _gain_pct: ranking[index].value(forKey: "gain_pct") as! String,
                                   _photo_url: ranking[index].value(forKey: "photo_url") as! String,
                                   _rank: ranking[index].value(forKey: "rank_global") as! Int)
               
                if (isGlobalRanking == true){
                    user.global_ranking?.add(ranking)
                    if (ranking.user_id == user.id) {
                        user.global_rank = ranking.rank;
                    }
                }
                else {
                    user.friend_ranking?.add(ranking)
                    if (ranking.user_id == user.id) {
                        user.friends_rank = index;
                    }
                }
            }
        }
    }

}

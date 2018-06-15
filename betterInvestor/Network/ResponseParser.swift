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
                user.portfolio.addPosition(position: pos);
            }
        }
        user.portfolio.cash = data["cash"] as! Double;
        user.global_rank = data["rank_global"] as! NSInteger;
        user.portfolio.credit = data["credit"] as! Double;
    }
    
    class func parseQuotes (json:NSDictionary){
        
        let data = json["data"] as! NSDictionary;
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let date = NSDate()
        for (symbol, price) in data {
            print(symbol,price);
           // let quote = Quote(symbol: symbol as! String,price: Double(price as! String)!, time:date);
            let quote = Quote(symbol: symbol as! String,price: price as! Double, time:date);
            appDelegate.market?.updateQuote(quote: quote);
        }
    }

    class func parseSymbols (json:NSDictionary){
        
        let data = json["data"] as! NSDictionary;
        let symbolsArray = data["symbols"] as! NSArray;
        let symbols = NSMutableArray();
        for sym in symbolsArray {
            let dic = sym as! NSDictionary;
            let symbol = Symbol(key: dic.object(forKey: "Symbol") as! String, name: dic.object(forKey: "Name") as! String)
            symbols.add(symbol);
        }
        
        UserDefaults.standard.set(symbolsArray, forKey: "symbols")
        
        let symbols_version = data["version"] as! String;
        UserDefaults.standard.set(symbols_version, forKey: "symbols_version")
    }
    
    
    class func parseUserGainHistory(json: NSDictionary,user: User) {
        
        let data = json["data"] as! NSDictionary;
        let gain_history = data["gain"] as? NSString;
        if (gain_history != nil){
            var arr = gain_history!.components(separatedBy: ",")
            user.gain_history = NSMutableArray ()
            for index in 0...arr.count-1  {
                let gain_history_item = GainHistoryItem(_keyValStr: arr[index]);
                user.gain_history.add(gain_history_item);
            }
        }
    }
    
    
    class func parseStockHolders(json: NSDictionary,holders: NSMutableArray) {
        
        let data = json["data"] as! NSDictionary;
        let array = data["holders"] as! [NSDictionary];
        
        if (array.count > 0)
        {
            for index in 0...array.count-1  {
            
                let pos = Position(symbol:array[index].value(forKey: "symbol") as! String,
                                   qty:array[index].value(forKey: "qty") as! NSInteger,
                                   cost:array[index].value(forKey: "cost") as! Double,
                                   name:array[index].value(forKey: "name") as! String);
            
                pos.calculate_gain();
                let h = Holder.init(_user_id: array[index].value(forKey: "user_id") as! String,
                                    _first_name: array[index].value(forKey: "first_name") as! String,
                                    _last_name: array[index].value(forKey: "last_name") as! String,
                                    _picUrl: array[index].value(forKey: "photo_url") as! String,
                                    _pos: pos,
                                    _global_rank: array[index].value(forKey: "global_ranking") as! Int );
                holders.add(h);
            }
        }
    }
    
    
    class func parseUserRanking (json:NSDictionary, user: User, isGlobalRanking:Bool){
        let data = json["data"] as! NSDictionary;
        let ranking = data["ranking"] as! [NSDictionary];
        let nc = NotificationCenter.default
        
        if (isGlobalRanking == true){
            user.global_ranking = NSMutableArray()
        }
        else {
            user.friend_ranking = NSMutableArray()
        }
        
        user.friends_rank = 1;
        
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
                    user.global_ranking.add(ranking)
                    if (ranking.user_id == user.id) {
                        user.global_rank = ranking.rank;
                    }
                }
                else {
                    user.friend_ranking.add(ranking)
                    let gain_double = NumberFormatter().number(from: ranking.gain_pct!)?.doubleValue
                    if (gain_double! > user.portfolio.total_gain_precentage) {
                        user.friends_rank = user.friends_rank! + 1;
                    }
                }
            }
        }
        nc.post(name:Notification.Name(rawValue:"portfolio_updated"),object: nil,userInfo: nil)
    }
    
}

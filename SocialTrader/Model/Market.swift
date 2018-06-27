//
//  Market.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-12.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Market{
    var quotes = [String:Quote]();
    let nc = NotificationCenter.default
    var stockList = "";
    
    func setPortfolio (portfolio: Portfolio) {
        stockList = portfolio.getStockList();
    }
    
    
    func addToStockList (portfolio: Portfolio,completion:@escaping () -> Void){        
        let posNo = portfolio.positions.count;
        if (posNo > 0) {
            for i in 0...posNo-1 {
                if let symbol = portfolio.positions[i].symbol {
                    if stockList.range(of:symbol) == nil {
                        if (self.stockList != "") {
                            self.stockList = self.stockList + "," + symbol;
                        }
                    }
                }
            }
        }
        fetchStockPrice(completion: completion);
    }
     
    
    func addToStockList (symbol: String,completion:@escaping () -> Void){
        
        if (self.stockList != "") {
            self.stockList = self.stockList + "," + symbol.lowercased();
        }
        else {
            self.stockList = symbol;
        }
        
        fetchStockPrice(completion: completion);
    }
    
    @objc func fetchStockPrice(symbol: String, completion:@escaping (_ success:Bool) -> Void) {
        var url = Constants.bsae_url + Constants.get_quote_url;
        url = url.replacingOccurrences(of: "{symbol}", with: symbol);
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    self.parseQuotes(json: jsonDic);
                    completion(true);
                }
                else {
                    completion(false);
                }
            }
        }
    }
    
    @objc func fetchStockPrice(completion:@escaping () -> Void) {
        let symbols = self.stockList;
        if (symbols != ""){
            var url = Constants.bsae_url + Constants.get_quotes_url ;
            url = url.replacingOccurrences(of: "{symbols}", with: symbols);
            Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
                if let result = response.result.value {
                    let jsonDic = result as! NSDictionary
                    if (jsonDic["status"] as! String == Constants.status_success) {
                        self.parseQuotes(json: jsonDic);
                        self.nc.post(name:Notification.Name(rawValue:Constants.notif_stocks_updated),object: nil,userInfo: nil)
                        completion();
                    }
                }
            }
        }
        else {
            completion();
        }
    }
    
    func parseQuotes (json:NSDictionary){
        let data = json["data"] as! NSDictionary;
        let date = NSDate()
        for (symbol, price) in data {
            let quote = Quote(symbol: symbol as! String,price: price as! Double, time:date);
            self.quotes[quote.symbol] = quote;
        }
    }
   
    func requestSymbols(completion:@escaping () -> Void) {
        
        let symbol_version = UserDefaults.standard.value(forKey: "symbols_version") as! String;
        
        let url = Constants.bsae_url + "market/stock/symbols/version/"+symbol_version;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == "200") {
                    self.parseSymbols(json: jsonDic);
                }
                completion();
            }
        }
    }
    
    
    
    func parseSymbols (json:NSDictionary){
        
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
    
}

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
    var quotes : [String:Quote];
    var timer = Timer()
    let nc = NotificationCenter.default
    var stockList: String?;
    
    init (portfolio: Portfolio?) {
        quotes = [String:Quote]();
        if (portfolio != nil) {
            stockList = portfolio?.getStockList();
        }
        
        /*
        self.timer = Timer.scheduledTimer(
            timeInterval: 30.0,
            target: self,
            selector: #selector(Market.fetchStockPrice),
            userInfo: nil,
            repeats: true)
        */
    }
    
    
    func addToStockList (user: User,completion:@escaping () -> Void){
        
        if let portfolio = user.portfolio {
            
            let posNo = portfolio.positions?.count;
            if (posNo! > 0) {
                for i in 0...posNo!-1 {
                    let symbol = portfolio.positions![i].symbol;
                    if stockList?.range(of:symbol) == nil {
                        if (self.stockList != "") {
                            self.stockList = self.stockList! + "," + symbol;
                        }
                    }
                }
            }
        }
        fetchStockPrice(completion: completion);
    }
     
    
    func addToStockList (symbol: String,completion:@escaping () -> Void){
        
        if (self.stockList != "") {
            self.stockList = self.stockList! + "," + symbol.lowercased();
        }
        else {
            self.stockList = symbol;
        }
        
        fetchStockPrice(completion: completion);
    }
    
    
    
    @objc func fetchStockPrice(completion:@escaping () -> Void) {
        let param = self.stockList;
        if (param != ""){
            let url = Constants.bsae_url + "market/stock/quote/array/"+param!;
            Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
                if let result = response.result.value {
                    let jsonDic = result as! NSDictionary
                    if (jsonDic["status"] as! String == "200") {
                        ResponseParser.parseQuotes(json: jsonDic);
                        self.nc.post(name:Notification.Name(rawValue:"quotes_updated"),object: nil,userInfo: nil)
                        completion();
                    }
                }
            }
        }
        else {
            completion();
        }
    }
    
    func updateQuote(quote:Quote) {
        quotes[quote.symbol] = quote;
    }
    
    @objc func fetchStockPrice(symbol: String, completion:@escaping (_ success:Bool) -> Void) {
        let url = Constants.bsae_url + "market/stock/quote/"+symbol;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == "200") {
                    ResponseParser.parseQuotes(json: jsonDic);
                    completion(true);
                }
                else {
                    completion(false);
                }
            }
        }
    }

}

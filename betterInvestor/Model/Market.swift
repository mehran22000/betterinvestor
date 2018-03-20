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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let nc = NotificationCenter.default
    var stockList: String?;
    
    init () {
        quotes = [String:Quote]();
        
        if let portfolio = appDelegate.user?.portfolio {
            stockList = portfolio.getStockList();
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
            for i in 0...posNo!-1 {
                let symbol = portfolio.positions![i].symbol;
                let stockList = self.stockList?.lowercased();
                if stockList?.range(of:symbol) == nil {
                    if (self.stockList != "") {
                        self.stockList = self.stockList! + "," + symbol;
                    }
                }
            }
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
    }
    
    func updateQuote(quote:Quote) {
        quotes[quote.symbol] = quote;
    }
    
    
}

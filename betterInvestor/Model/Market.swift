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

    init () {
        quotes = [String:Quote]();
        fetchStockPrice();
        self.timer = Timer.scheduledTimer(
            timeInterval: 30.0,
            target: self,
            selector: #selector(Market.fetchStockPrice),
            userInfo: nil,
            repeats: true)
    }
    
    
    @objc func fetchStockPrice() {
        
        if let portfolio = appDelegate.user?.portfolio {
            let param = portfolio.getStockList();
            if (param != ""){
                let url = Constants.bsae_url + "market/stock/quote/array/"+param;
                Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
                    if let result = response.result.value {
                        let jsonDic = result as! NSDictionary
                        if (jsonDic["status"] as! String == "200") {
                            ResponseParser.parseQuotes(json: jsonDic, market: self);
                            portfolio.calculateGain();
                            self.nc.post(name:Notification.Name(rawValue:"quotes_updated"),object: nil,userInfo: nil)
                        }
                    }
                }
            }
        }
    }
    
    func updateQuote(quote:Quote) {
        quotes[quote.symbol] = quote;
    }
    
    
}

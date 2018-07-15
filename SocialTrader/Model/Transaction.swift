//
//  RequestGenerator.swift
//  smarterInvestor
//
//  Created by mehran najafi on 2017-12-18.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Transaction {
    
    var order = [String: AnyObject]();
    
    func requestOrder(user: User, symbol: NSString, name: NSString, qty: NSInteger, price: Double, fee: Double){
        self.order["user_id"] = user.id as AnyObject;
        self.order["symbol"] = symbol as AnyObject;
        self.order["name"] = name as AnyObject;
        self.order["qty"] = qty as AnyObject;
        self.order["price"] = price as AnyObject;
        self.order["fee"] = fee as AnyObject;
    }
    
    func requestBuy(successCompletion:@escaping (_ msgHeader: String, _ msg: String) -> Void, failureCompletion:@escaping (_ msgHeader:String, _ msg:String) -> Void){
        
        let url = Constants.bsae_url + Constants.portfolio_url;
        Alamofire.request(url, method: HTTPMethod.post, parameters: self.order, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                if (json["status"] == "200") {
                    let title = "Order Executed Successfully!";
                    let qtyStr:String = String(format:"%d", self.order["qty"] as! NSInteger);
                    let quoteStr:String = String(format:"%.2f", self.order["price"] as! Double);
                    let msg = String(format: "Bought %@ %@ @ $%@", qtyStr, self.order["symbol"] as! String, quoteStr);
                    successCompletion(title,msg);
                }
                else if (json["status"] == "501") {
                    let title = "Insufficient Funds";
                    let msg = "Please try again"
                    failureCompletion(title,msg)
                }
                else {
                    let title = "Transaction Error";
                    let msg = "Please try again later"
                    failureCompletion(title,msg)
                }
            }
        }
    }
    
    
    func requestSell(successCompletion:@escaping (_ msgHeader: String, _ msg: String) -> Void, failureCompletion:@escaping (_ msgHeader:String, _ msg:String) -> Void){

        let url = Constants.bsae_url + Constants.portfolio_url;
        Alamofire.request(url, method: HTTPMethod.put, parameters: self.order, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                if (json["status"] == "200") {
                    let title = "Order Executed Successfully!";
                    let qtyStr:String = String(format:"%d", self.order["qty"] as! NSInteger);
                    let quoteStr:String = String(format:"%.2f", self.order["price"] as! Double);
                    let msg = String(format: "Sold %@ %@ @ $%@", qtyStr, self.order["symbol"] as! String, quoteStr);
                    successCompletion(title,msg);
                }
                else {
                    let title = "Transaction Error";
                    let msg = "Please try again later"
                    failureCompletion(title,msg)
                }
            }
        }
    }
}

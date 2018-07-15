//
//  Credit.swift
//  SocialTrader
//
//  Created by mehran  on 2018-07-08.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Credit {

    var order = [String: AnyObject]();
    var source: NSString?
    var amount: NSInteger?

    func requestOrder(user: User, source: NSString, amount: NSInteger){
        self.order["user_id"] = user.id as AnyObject;
        self.order["source"] = source as AnyObject;
        self.order["amount"] = amount as AnyObject;
        self.source = source;
        self.amount = amount;
    }

func requestCredit(successCompletion:@escaping (_ msgHeader: String, _ msg: String) -> Void, failureCompletion:@escaping (_ msgHeader:String, _ msg:String) -> Void){
    
    let url = Constants.bsae_url + Constants.post_credit_url;
    Alamofire.request(url, method: HTTPMethod.post, parameters: self.order, encoding:JSONEncoding.default).responseJSON { response in
        if let result = response.result.value {
            let json = JSON(result)
            if (json["status"] == "200") {
                let title = "";
                let msg = String(format: "You awarded %d points for your %@", self.amount!, self.source!);
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

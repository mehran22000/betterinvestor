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
  
    func requestOrder(user: User, source: NSString){
        self.order["user_id"] = user.id as AnyObject;
        self.order["source"] = source as AnyObject;
    }

func requestCredit(successCompletion:@escaping () -> Void, failureCompletion:@escaping () -> Void){
    
    let url = Constants.bsae_url + Constants.post_credit_url;
    Alamofire.request(url, method: HTTPMethod.post, parameters: self.order, encoding:JSONEncoding.default).responseJSON { response in
        if let result = response.result.value {
            let json = JSON(result)
            if (json["status"] == "200") {
                successCompletion();
            }
            else {
                failureCompletion()
                }
            }
        }
    }
}

//
//  RequestGenerator.swift
//  smarterInvestor
//
//  Created by mehran najafi on 2017-12-18.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation

class RequestGenerator {
    
    class func requestUserProfile(user: User) -> [String : AnyObject] {
        var dic = [String: AnyObject]();
        dic["user_id"] = user.id as AnyObject;
        dic["first_name"] = user.first_name as AnyObject;
        dic["last_name"] = user.last_name as AnyObject;
        dic["photo_url"] = user.pictureUrl as AnyObject;
        dic["email"] = user.email as AnyObject;
        var friends_str = String("");
        for friend in user.friends! {
            if (friends_str != "") {
                friends_str = friends_str + ",";
            }
            friends_str = friends_str + ((friend as! NSDictionary).value(forKey: "id") as! String);
        }
        dic["friends"] = friends_str as AnyObject;
        return dic;
        
    }
    
    
    class func requestOrder(user: User, symbol: NSString, name: NSString, qty: NSInteger, price: Double, fee: Double) -> [String : AnyObject] {
        var dic = [String: AnyObject]();
        dic["user_id"] = user.id as AnyObject;
        dic["symbol"] = symbol as AnyObject;
        dic["name"] = name as AnyObject;
        dic["qty"] = qty as AnyObject;
        dic["price"] = price as AnyObject;
        dic["fee"] = fee as AnyObject;
        return dic;
        
    }
}

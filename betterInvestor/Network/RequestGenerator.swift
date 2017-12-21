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
        dic["friends"] = user.friends as AnyObject;
        return dic;
        
    }
}

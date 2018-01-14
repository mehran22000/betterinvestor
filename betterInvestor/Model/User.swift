//
//  User.swift
//  smarterInvestor
//
//  Created by mehran najafi on 2017-12-19.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    var id: String?;
    var first_name: String?;
    var last_name: String?;
    var middle_name: String?;
    var name: String?;
    var email: String?;
    var pictureUrl: String?;
    var friends: String?;
    var portfolio: Portfolio?;

    init(_id:String, _first_name: String, _last_name: String, _middle_name: String, _name: String, _email: String, _pictureUrl: String, _friends: String) {
        self.id = _id;
        self.first_name = _first_name;
        self.last_name = _last_name;
        self.middle_name = _middle_name;
        self.name = _name;
        self.email = _email;
        self.pictureUrl = _pictureUrl;
        self.friends = _friends;
        self.portfolio = Portfolio();
    }

    init(dic: [String : AnyObject]) {
        self.id = dic["id"] as? String;
        self.first_name = dic["first_name"] as? String;
        self.last_name = dic["last_name"] as? String;
        self.middle_name = dic["middle_name"] as? String;
        self.name = dic["name"] as? String;
        self.email = dic["email"] as? String;
        if let picObj = dic["picture"]  {
            if let dataObj = picObj["data"] {
                self.pictureUrl = (dataObj as! [String: AnyObject])["url"] as? String;
            }
        }
        self.friends = dic["friends"] as? String;
        self.portfolio = Portfolio();

    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(first_name, forKey:"first_name")
        aCoder.encode(last_name, forKey:"last_name")
        aCoder.encode(middle_name, forKey:"middle_name")
        aCoder.encode(name, forKey:"name")
        aCoder.encode(email, forKey:"email")
        aCoder.encode(pictureUrl, forKey:"pictureUrl")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String ?? ""
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String ?? ""
        self.middle_name = aDecoder.decodeObject(forKey: "middle_name") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.pictureUrl = aDecoder.decodeObject(forKey: "pictureUrl") as? String ?? ""
        self.portfolio = Portfolio();
    }
    
    
    func setFriends(dic: [String: AnyObject]) {
        /*
        for (int i=0; i<dic.count; i++) {
            
        }
         */
    }

}

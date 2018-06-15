//
//  User.swift
//  smarterInvestor
//
//  Created by mehran najafi on 2017-12-19.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


@objc class User: NSObject, NSCoding {
    
    let id: String!;
    let first_name: String!;
    let last_name: String!;
    let middle_name: String?;
    let name: String!;
    let email: String!;
    var pictureUrl: String?;
    var pic: UIImage?;
    var friends: NSArray?;
    
    @objc var portfolio = Portfolio();
    @objc var gain_history = NSMutableArray();
    
    var global_ranking = NSMutableArray();
    var friend_ranking = NSMutableArray();
    var global_rank: Int?;
    var friends_rank: Int?;

    init(_id:String, _first_name: String, _last_name: String, _middle_name: String?, _name: String, _email: String, _pictureUrl: String?, _friends: NSArray?, _cash: Double, _pic: UIImage?) {
        self.id = _id;
        self.first_name = _first_name;
        self.last_name = _last_name;
        self.middle_name = _middle_name;
        self.name = _name;
        self.email = _email;
        self.pictureUrl = _pictureUrl;
        self.friends = _friends;
        self.portfolio.cash = _cash;
        self.pic = _pic;
    }

    init(dic: [String : AnyObject]) {
        self.id = dic["id"] as! String;
        self.first_name = dic["first_name"] as! String;
        self.last_name = dic["last_name"] as! String;
        self.middle_name = dic["middle_name"] as? String;
        self.name = dic["name"] as! String;
        self.email = dic["email"] as! String;
        self.friends = dic["friends"] as? NSArray;
        // self.portfolio.cash = dic["cash"] as! Double;
        if let picObj = dic["picture"]  {
            if let dataObj = picObj["data"] {
                self.pictureUrl = (dataObj as! [String: AnyObject])["url"] as? String;
            }
        }
        
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
    }
    
    func fetchPortfolio(completion:@escaping () -> Void) {
        let url = Constants.bsae_url + Constants.get_profile_url + self.id;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    ResponseParser.parseUserPortfolio(json: jsonDic,user: self);
                    completion();
                }
            }
        }
    }
    
    func fetchRanking(global: Bool, count: Int, completion:@escaping () -> Void) {
        var url: String;
        url = Constants.bsae_url + Constants.get_ranking_url;
        if (global == true) {
            url = url.replacingOccurrences(of: "{mode}", with: "global");
            url = url.replacingOccurrences(of: "{user_id}", with: self.id);
            url = url + "/count/" + String(count);
        }
        else {
            url = url.replacingOccurrences(of: "{mode}", with: "friends");
            url = url.replacingOccurrences(of: "{user_id}", with: self.id);
        }
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    ResponseParser.parseUserRanking(json: jsonDic,user: self, isGlobalRanking:global );
                    completion();
                }
            }
        }
    }
    
    
    func fetchGainHistory(completion:@escaping () -> Void) {
        var url: String;
        url = Constants.bsae_url + Constants.get_gains_url;
        url = url.replacingOccurrences(of: "{user_id}", with: self.id);
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    ResponseParser.parseUserGainHistory(json: jsonDic,user: self);
                    completion();
                }
            }
        }
    }
    
    
    
    
}

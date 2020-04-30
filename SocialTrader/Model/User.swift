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
    let first_name: String?;
    let last_name: String?;
    let middle_name: String?;
    let name: String?;
    let email: String?;
    var pictureUrl: String?;
    var picture_key: String?;
    var pic: UIImage?;
    var friends: NSArray?;
    
    @objc var portfolio = Portfolio();
    @objc var gain_history = NSMutableArray();
    
    var global_ranking = NSMutableArray();
    var friend_ranking = NSMutableArray();
    var global_rank: Int?;
    var friends_rank: Int?;

    init(_id:String, _first_name: String, _last_name: String, _middle_name: String?, _name: String, _email: String, _pictureUrl: String?, _friends: NSArray?, _cash: Double, _realized: Double, _pic: UIImage?) {
        self.id = _id;
        self.first_name = _first_name;
        self.last_name = _last_name;
        self.middle_name = _middle_name;
        self.name = _name;
        self.email = _email;
        self.pictureUrl = _pictureUrl;
        self.friends = _friends;
        self.portfolio.cash = _cash;
        self.portfolio.realized = _realized;
        self.pic = _pic;
    }

    init(dic: [String : AnyObject]) {
        self.id = dic["id"] as! String;
        self.first_name = dic["first_name"] as? String;
        self.last_name = dic["last_name"] as? String;
        self.middle_name = dic["middle_name"] as? String;
        self.name = dic["name"] as? String;
        self.email = dic["email"] as? String;
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
    

    
    func requestUserProfile(completion:@escaping () -> Void) {
        
        var dic = [String: AnyObject]();
        dic["user_id"] = self.id as AnyObject;
        dic["first_name"] = self.first_name as AnyObject;
        dic["last_name"] = self.last_name as AnyObject;
        dic["photo_url"] = self.pictureUrl as AnyObject;
        dic["email"] = self.email as AnyObject;
        // dic["friends_pic"] = [String: AnyObject]() as AnyObject;
        var friends_str = String("");
        var friends_pic_str = String("");
        for friend in self.friends! {
            if (friends_str != "") {
                friends_str = friends_str + ",";
                friends_pic_str = friends_pic_str + ",";
            }
            let friend_id = (friend as! NSDictionary).value(forKey: "id") as! String;
            friends_str = friends_str + friend_id;
            
            if let friendDic = friend as? NSDictionary {
                if let picObj = friendDic.value(forKey: "picture") as? NSDictionary {
                    if let dataObj = picObj["data"] as? [String: AnyObject] {
                        if let picUrl = dataObj["url"] as? String {
                            friends_pic_str = friends_pic_str + picUrl;
                        }
                    }
                }
            }
        }
        dic["friends"] = friends_str as AnyObject;
        dic["friends_pic"] = friends_pic_str as AnyObject;
        
        let url = Constants.bsae_url + Constants.get_profile_url;
        Alamofire.request(url, method: HTTPMethod.post, parameters: dic, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    completion();
                }
            }
        }
    }
    
    /* Portfolio Request and Parser */
    
    func requestPortfolio(completion:@escaping () -> Void) {
        let url = Constants.bsae_url + Constants.portfolio_url + self.id;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    self.parsePortfolio(json: jsonDic);
                    completion();
                }
            }
        }
    }
    
    func parsePortfolio (json:NSDictionary){
        let data = json["data"] as! NSDictionary;
        let portfolio = data["portfolio"] as! [NSDictionary];
        self.portfolio = Portfolio();
        if (portfolio.count > 0) {
            for index in 0...portfolio.count-1  {
                let pos = Position(symbol:portfolio[index].value(forKey: "symbol") as! String,
                                   qty:portfolio[index].value(forKey: "qty") as! NSInteger,
                                   cost:portfolio[index].value(forKey: "cost") as! Double,
                                   name:portfolio[index].value(forKey: "name") as! String);
                self.portfolio.addPosition(position: pos);
            }
        }
        self.portfolio.cash = data["cash"] as! Double;
        self.global_rank = data["rank_global"] as? NSInteger;
    }
    
    
    /* GainHistory Request and Parser */
    
    func requestGainHistory(completion:@escaping () -> Void) {
        var url: String;
        url = Constants.bsae_url + Constants.get_gains_url;
        url = url.replacingOccurrences(of: "{user_id}", with: self.id);
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    self.parseGainHistory(json: jsonDic);
                    completion();
                }
            }
        }
    }
    
    func parseGainHistory(json: NSDictionary) {
        
        let data = json["data"] as! NSDictionary;
        let gain_history = data["gain"] as? NSString;
        if (gain_history != nil){
            var arr = gain_history!.components(separatedBy: ",")
            self.gain_history = NSMutableArray ()
            for index in 0...arr.count-1  {
                let gain_history_item = GainHistoryItem(_keyValStr: arr[index]);
                self.gain_history.add(gain_history_item);
            }
        }
    }
    
    
    /* Ranking Request and Parser */
    
    func requestRanking(global: Bool, count: Int, completion:@escaping () -> Void) {
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
                    self.parseRanking(json: jsonDic, isGlobalRanking:global );
                    completion();
                }
            }
        }
    }
    

    func parseRanking (json:NSDictionary, isGlobalRanking:Bool){
        let data = json["data"] as! NSDictionary;
        let ranking = data["ranking"] as! [NSDictionary];
        let nc = NotificationCenter.default
        
        if (isGlobalRanking == true){
            self.global_ranking = NSMutableArray()
        }
        else {
            self.friend_ranking = NSMutableArray()
        }
        
        self.friends_rank = 1;
        
        if (ranking.count > 0) {
            for index in 0...ranking.count-1  {
                let ranking = Ranking(_user_id: ranking[index].value(forKey: "user_id") as! String,
                                      _first_name: ranking[index].value(forKey: "first_name") as! String,
                                      _last_name: ranking[index].value(forKey: "last_name") as! String,
                                      _gain: ranking[index].value(forKey: "gain") as! String,
                                      _gain_pct: ranking[index].value(forKey: "gain_pct") as! String,
                                      _photo_url: ranking[index].value(forKey: "photo_url") as! String,
                                      _rank: ranking[index].value(forKey: "rank_global") as! Int)
                
                if (isGlobalRanking == true){
                    self.global_ranking.add(ranking)
                    if (ranking.user_id == self.id) {
                        self.global_rank = ranking.rank;
                    }
                }
                else {
                    self.friend_ranking.add(ranking)
                    let gain_double = NumberFormatter().number(from: ranking.gain_pct!)?.doubleValue
                    if (gain_double! > self.portfolio.total_gain_precentage) {
                        self.friends_rank = self.friends_rank! + 1;
                    }
                }
            }
        }
        nc.post(name:Notification.Name(rawValue:"portfolio_updated"),object: nil,userInfo: nil)
    }
    
}

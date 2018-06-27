//
//  ResponseParser.swift
//  smarterInvestor
//
//  Created by mehran najafi on 2017-12-18.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Holders {
    
    let symbol: String!;
    let holders = NSMutableArray();
    
    init (symbol: String) {
        self.symbol = symbol;
    }
    

    
    func requestHolders(justFriends: Bool, user_id: String?, completion:@escaping () -> Void) {
        
        var url: String;
        url = Constants.bsae_url + Constants.get_holders_url;
        url = url.replacingOccurrences(of: "{symbol}", with: self.symbol);
        url = url.replacingOccurrences(of: "{user_id}", with: user_id!);
        
        if (justFriends == false) {
            url = url.replacingOccurrences(of: "{isGlobal}", with: "true");
        }
        else {
            url = url.replacingOccurrences(of: "{isGlobal}", with: "false");
        }
        
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == Constants.status_success) {
                    self.parse(json: jsonDic);
                    completion();
                }
            }
        }
    }
    
    func parse(json: NSDictionary) {
        
        
        let data = json["data"] as! NSDictionary;
        let array = data["holders"] as! [NSDictionary];
        
        if (array.count > 0)
        {
            for index in 0...array.count-1  {
                
                let pos = Position(symbol:array[index].value(forKey: "symbol") as! String,
                                   qty:array[index].value(forKey: "qty") as! NSInteger,
                                   cost:array[index].value(forKey: "cost") as! Double,
                                   name:array[index].value(forKey: "name") as! String);
                
                pos.calculate_gain();
                let h = Holder.init(_user_id: array[index].value(forKey: "user_id") as! String,
                                    _first_name: array[index].value(forKey: "first_name") as! String,
                                    _last_name: array[index].value(forKey: "last_name") as! String,
                                    _picUrl: array[index].value(forKey: "photo_url") as! String,
                                    _pos: pos,
                                    _global_rank: array[index].value(forKey: "global_ranking") as! Int );
                self.holders.add(h);
            }
        }
    }
    
    
}

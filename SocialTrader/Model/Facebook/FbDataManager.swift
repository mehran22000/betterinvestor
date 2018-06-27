//
//  fbLoginManager.swift
//  betterInvestor
//
//  Created by mehran  on 2018-02-24.
//  Copyright © 2018 Ron. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Alamofire
import SwiftyJSON


class FbDataManager: NSObject
{
    
    var dict : [String : AnyObject]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    func getFBUserData( completion:@escaping () -> Void){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    self.appDelegate.user = User(dic: self.dict);
                    self.defaults.set(NSKeyedArchiver.archivedData(withRootObject: self.appDelegate.user!), forKey: "user")
                    self.getFBFriendsList(completion: completion);
                }
            })
        }
    }
    
    
    func getFBFriendsList(completion:@escaping () -> Void){
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start { (connection, result , error) -> Void in
            
            if error != nil {
                print(error!)
            }
            else {
                self.dict = result as! [String : AnyObject]
                if let user = self.appDelegate.user {
                    user.friends = self.dict["data"] as? NSArray;
                    user.requestUserProfile {
                        completion();
                    }
                }
            }
        }
    }
}

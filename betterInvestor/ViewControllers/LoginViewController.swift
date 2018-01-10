//
//  LoginViewController.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-27.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet var fbLoginBtn: UIButton?;
    var dict : [String : AnyObject]!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
 
   
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: facebookReadPermissions, from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    self.appDelegate.user = User(dic: self.dict);
                    self.getFBFriendsList();
                }
            })
        }
    }
    
    
    func getFBFriendsList(){
        let params = ["fields": "id, first_name, last_name, middle_name, name, email, picture"]
        FBSDKGraphRequest(graphPath: "me/friends", parameters: params).start { (connection, result , error) -> Void in
            
            if error != nil {
                print(error!)
            }
            else {
                print(result!)
                self.dict = result as! [String : AnyObject]
                // parse multiple friends to service request
                self.appDelegate.user?.friends = self.dict["friends"] as? String;
                let param = RequestGenerator.requestUserProfile(user: self.appDelegate.user!);
                let url = Constants.bsae_url + "user/profile";
                Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding:JSONEncoding.default).responseJSON { response in
                   // if let result = response.result.value {
                   //     let json = JSON(result)
                   //     if (json["response"] == "success") {
                            self.performSegue(withIdentifier: "segueHomeScreen", sender: nil)
                   //     }
                   // }
                }
            }
            }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

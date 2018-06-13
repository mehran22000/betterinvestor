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
    let defaults = UserDefaults.standard
    @IBOutlet var activitySpinner: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activitySpinner?.isHidden = true;
        
        if let userObject = UserDefaults.standard.value(forKey: "user") as? NSData {
            self.fbLoginBtn?.isHidden = true;
            self.activitySpinner?.isHidden = false;
            self.activitySpinner?.startAnimating();
            appDelegate.user = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data) as? User
            let fbDataManager = FbDataManager();
            fbDataManager.getFBUserData(completion: {
                self.performSegue(withIdentifier: "segueHomeScreen", sender: nil)
            })
        }
        else {
            self.performSegue(withIdentifier: "segueTutorial", sender: nil)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.activitySpinner?.isHidden = true;
        self.fbLoginBtn?.isHidden = false;
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
 
   
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
    
        self.activitySpinner?.isHidden = false;
        self.fbLoginBtn?.isHidden = true;
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: facebookReadPermissions, from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        let fbDataManager = FbDataManager();
                        fbDataManager.getFBUserData(completion: {
                            self.performSegue(withIdentifier: "segueHomeScreen", sender: nil)
                        })
                    }
                }
            }
        }
    }

}

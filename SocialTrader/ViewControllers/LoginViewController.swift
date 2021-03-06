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
import FacebookLogin

class LoginViewController: UIViewController {

    @IBOutlet var fbLoginBtn: UIButton?;
    var dict : [String : AnyObject]!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    @IBOutlet var activitySpinner: UIActivityIndicatorView?
    var fb_inprogress: Bool = false;
    
    // View Delegates - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activitySpinner?.isHidden = true;
        if let userObject = UserDefaults.standard.value(forKey: "user") as? NSData {
            self.fbLoginBtn?.isHidden = true;
            self.activitySpinner?.isHidden = false;
            self.activitySpinner?.startAnimating();
            
            appDelegate.user = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data) as? User
            let fbDataManager = FbDataManager();
            // loginButton.delegate = fbDataManager;
            
            fbDataManager.getFBUserData(completion: {
                self.performSegue(withIdentifier: "segueHomeScreen", sender: nil)
            })
        }
        else {
            self.performSegue(withIdentifier: "segueTutorial", sender: nil)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.fb_inprogress == false) {
            self.activitySpinner?.isHidden = true;
            self.fbLoginBtn?.isHidden = false;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // View Delegates - End

    // Facebook Delegates - Start
    let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
    
        self.activitySpinner?.isHidden = false;
        self.fbLoginBtn?.isHidden = true;
        self.fb_inprogress = true;
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: facebookReadPermissions, from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        let fbDataManager = FbDataManager();
                        fbDataManager.getFBUserData(completion: {
                            self.fb_inprogress = false;
                            self.performSegue(withIdentifier: "segueHomeScreen", sender: nil)
                        })
                    }
                }
                else {
                    self.fb_inprogress = false;
                    self.activitySpinner?.isHidden = true;
                    self.fbLoginBtn?.isHidden = false;
                }
            }
            else {
                self.fb_inprogress = false;
            }
        }
    }
    // Facebook Delegates - End

}

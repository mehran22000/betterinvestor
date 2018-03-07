//
//  RootNavigationControllerViewController.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-27.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON


class RootNavigationVC: UINavigationController {

    
    var dict : [String : AnyObject]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootNavigationController = self;
        self.setNavigationBarHidden(false, animated: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

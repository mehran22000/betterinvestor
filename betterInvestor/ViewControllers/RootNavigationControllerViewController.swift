//
//  RootNavigationControllerViewController.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-27.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class RootNavigationControllerViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rootNavigationController = self;
        
        if let userObject = UserDefaults.standard.value(forKey: "user") as? NSData {
            appDelegate.user = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data) as? User
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Master_View") as UIViewController
            self.setViewControllers([initialViewController], animated: false)
        }
        self.setNavigationBarHidden(true, animated: false)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//
//  TermsVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-06-05.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    @IBOutlet var scroller: UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller!.contentSize = CGSize(width: 340, height: 1000)
        scroller?.sizeToFit();
        scroller!.isScrollEnabled = true
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        
        // Do any additional setup after loading the view
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func termsBtnClicked() {
        self.dismiss(animated: true) {
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

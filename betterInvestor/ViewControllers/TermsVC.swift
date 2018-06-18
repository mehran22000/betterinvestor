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
    }

    override func viewDidLayoutSubviews() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func termsBtnClicked() {
        self.dismiss(animated: true) {
        }
    }

}

//
//  TermsVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-06-05.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class TermsVC: UIViewController {

    @IBOutlet weak var textView: UITextView?
    
    override func viewDidLoad() {
       super.viewDidLoad()
       textView?.text = NSLocalizedString("Terms", comment: "")
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

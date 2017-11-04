//
//  ViewController.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-10-19.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit
import GoogleMobileAds


class ViewController: UIViewController {
    
    @IBOutlet var viewBanner:GADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBanner?.adUnitID = "ca-app-pub-5267718216518748/5568296429";
        // self.viewBanner?.rootViewController?.delete(self);
        let gadRequest = GADRequest();
        gadRequest.testDevices = [kGADSimulatorID];
        self.viewBanner?.load(gadRequest);
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


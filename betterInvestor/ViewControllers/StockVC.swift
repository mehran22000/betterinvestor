//
//  StockVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-20.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class StockVC: UIViewController {
    
    var screenSize: CGRect?;
    var screenWidth, screenHeight:CGFloat?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize!.width
        self.screenHeight = screenSize!.height
        let width = Int(screenWidth!);
        
    }
}

//
//  StockHoldersVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-21.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class StockHoldersVC: UIViewController {
    
    @IBOutlet var segmentControlView: UISegmentedControl!
    @IBOutlet var tableView: UIView!
    var screenSize: CGRect?;
    var rankingVC : RankingTableVC?
    var screenWidth, screenHeight:CGFloat?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize!.width
        self.screenHeight = screenSize!.height
        
        // Ranking View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.rankingVC = storyboard.instantiateViewController(withIdentifier: "RankingVC") as? RankingTableVC
        self.addChildViewController(self.rankingVC!);
        self.tableView.addSubview((self.rankingVC?.view)!);
        
    }
}

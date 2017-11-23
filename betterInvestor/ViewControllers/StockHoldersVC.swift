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
        // let width = Int(screenWidth!);
        
        // Ranking View Controllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.rankingVC = storyboard.instantiateViewController(withIdentifier: "RankingVC") as? RankingTableVC
        // self.rankingVC?.view.frame = CGRect(x:0,y:0,width:width,height:175);
        self.addChildViewController(self.rankingVC!);
        self.tableView.addSubview((self.rankingVC?.view)!);
        
        //self.segmentControlView.frame = CGRect(x:self.segmentControlView.frame.origin.x, y:self.segmentControlView.frame.origin.y,width:self.segmentControlView.frame.size.width,height:20);
    }
}

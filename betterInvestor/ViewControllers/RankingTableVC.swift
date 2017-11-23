//
//  RankingTableVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-08.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class RankingTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var table: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.tableFooterView = UIView()
        table?.tableHeaderView?.isHidden = true;
    }
        
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }

    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let hView = UIView();
        hView.backgroundColor = UIColor.init(red: 113/255.0, green: 81/255.0, blue: 120/255.0, alpha: 1);
        hView.frame = CGRect(x: 0, y: 0, width: (table?.frame.size.width)!, height: 44);
        addSegmentControl(parentView: hView);
        return hView;
    }
    */
    
    
    func addSegmentControl(parentView: UIView) {
        
        let items = ["Friends", "All"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let tblWidth = (table?.frame.size.width)!;
        customSC.frame = CGRect(x: tblWidth/2 - tblWidth/4, y: 10, width: tblWidth/2, height: 20);
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.init(red: 113/255.0, green: 81/255.0, blue: 120/255.0, alpha: 1);
        customSC.tintColor = UIColor.white
        
        // Add target action method
        // customSC.addTarget(self, action: Selector("changeColor:"), for: .valueChanged)
        
        // Add this custom Segmented Control to our view
        parentView.addSubview(customSC)
    }
    
    func changeColor(){
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell;
        return cell;
    }


}

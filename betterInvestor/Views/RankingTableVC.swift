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
    }
        
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell;
       
        
     //   cell.symbolLbl?.text = stocks[indexPath.row];
     //   cell.performanceBtn?.titleLabel?.text = "%10";
        return cell;
        
    }


}

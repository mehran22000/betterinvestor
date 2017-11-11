//
//  GlobalRankingTableVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-09.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class GlobalRankingTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let hView = UIView()
        hView.backgroundColor = UIColor.darkGray;
        
        let hTitle = UILabel(frame: CGRect(x:0, y:0, width:(table?.frame.size.width)!, height:30));
        hTitle.text = "Global";
        hTitle.textColor = UIColor.white;
        hTitle.font = hTitle.font.withSize(18);
        hTitle.textAlignment = .center;
        hView.addSubview(hTitle);
        
        return hView;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalRankingCell", for: indexPath) as! GlobalRankingCell;
        return cell;
    }
    
    
}


//
//  ProductTableView.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-25.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class ProductVC: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 44;
        }
        else {
            return 44;
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        switch (indexPath.row){
            case 0:
                cell.nameLbl?.text = "$20,000 in-app Cash";
                cell.buyBtn?.setTitle("$0.99", for: UIControlState.normal);
            case 1:
                cell.nameLbl?.text = "$50,000 in-app Cash";
                cell.buyBtn?.setTitle("$1.99", for: UIControlState.normal);
        case 2:
                cell.nameLbl?.text = "$100,000 in-app Cash";
                cell.buyBtn?.setTitle("$2.99", for: UIControlState.normal);
            
            default:
                break
            }
        return cell;
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.statusBarStyle = .lightContent
        self.tableView!.tableFooterView = UIView()
        
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

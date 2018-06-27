//
//  ReferVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-26.
//  Copyright © 2017 Ron. All rights reserved.
//


import UIKit

class ReferVC: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row){
        case 0:
            return 88;
        default:
            return 44;
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsCell", for: indexPath) ;
            return cell;
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReferCell", for: indexPath) as! ReferCell
            switch (indexPath.row){
            case 0:
                cell.nameLbl?.text = "Messages";
                cell.iconImageView?.image = UIImage(named: "messages_icon");
            case 1:
                cell.nameLbl?.text = "Messages";
                cell.iconImageView?.image = UIImage(named: "messages_icon");
            case 2:
                cell.nameLbl?.text = "Facebook";
                cell.iconImageView?.image = UIImage(named: "fb_icon");
            case 3:
                cell.nameLbl?.text = "Twitter";
                cell.iconImageView?.image = UIImage(named: "twitter_icon");
            default:
                break
            }
            return cell;
        }
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


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
        return 3;
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
            case 1:
                cell.nameLbl?.text = "Messages";
                cell.iconImageView?.image = UIImage(named: "messages_icon");
            case 2:
                cell.nameLbl?.text = "Email";
                cell.iconImageView?.image = UIImage(named: "email_icon");
            default:
                break
            }
            return cell;
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 1:
            self.sendMessage();
        case 2:
            self.sendEmail();
        default:
            break;
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
    
    @IBAction func backButtonClicked(){
        self.dismiss(animated: true) {
        }
    }
    
    func sendEmail() {
        let subject = "Some subject"
        var body = "Hi buddy, I'd invite you to download Social Trader app so we can see who is better in stock trading."
        body = body + "https://itunes.apple.com/us/app/social-trader/id1395523145?ls=1&mt=8"
        let coded = "mailto:blah@blah.com?subject=\(subject)&body=\(body)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let emailURL: NSURL = NSURL(string: coded!) {
            if UIApplication.shared.canOpenURL(emailURL as URL) {
                UIApplication.shared.open((emailURL as URL), options: [:], completionHandler: nil)
            }
            
        }
    }
    
    func sendMessage() {
        var body = "Hi buddy, I'd invite you to download Social Trader app so we can see who is better in stock trading."
        body = body + "https://itunes.apple.com/us/app/social-trader/id1395523145?ls=1&mt=8"
        UIApplication.shared.open(URL(string: "sms:&body=" + body)!, options: [:], completionHandler: nil)
    }
    
}


//
//  ReferVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-26.
//  Copyright © 2017 Ron. All rights reserved.
//


import UIKit
import MessageUI

class ReferVC: UITableViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var composeVC : MFMailComposeViewController?
    var selCellIndexPth : IndexPath?
    var isModal: Bool = false;
    
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
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            return cell;
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.init(red: 133/255.0, green: 103/255.0, blue: 139/255.0, alpha: 1);
        self.selCellIndexPth = indexPath;
        
        switch (indexPath.row) {
        case 1:
            self.sendMessage();
        case 2:
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            self.sendEmail();
        default:
            break;
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.statusBarStyle = .lightContent
        self.tableView!.tableFooterView = UIView()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MFMailComposeViewController.canSendMail() {
            self.composeVC = MFMailComposeViewController()
            if (self.composeVC != nil ) {
                self.composeVC!.mailComposeDelegate = self
            }
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonClicked(){
        if (self.isModal == true) {
            self.dismiss(animated: true) {
            }
        }
        else {
            self.navigationController?.popViewController(animated: true);
        }
    }

    
    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
           // showMailServiceErrorAlert()
        return
        }
    
        let subject = "Try Social Trader iOS App"
        var body = "Hi buddy, I'd invite you to download Social Trader app so we can see who is better in stock trading."
        body = body + "\n https://itunes.apple.com/us/app/social-trader/id1395523145?ls=1&mt=8"
        
        composeVC!.setSubject(subject)
        composeVC!.view.tintColor = UIColor.black;
        composeVC!.setMessageBody(body, isHTML: false)
        composeVC!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black];
        self.present(composeVC!, animated: true, completion: nil)
    }
    
    
    
    func sendMessage() {
        let messageVC = MFMessageComposeViewController()
        var body = "Hi buddy, I'd invite you to download Social Trader app so we can see who is better in stock trading."
        body = body + "https://itunes.apple.com/us/app/social-trader/id1395523145?ls=1&mt=8"
        
        messageVC.body = body
        messageVC.recipients = [] // Optionally add some tel numbers
        messageVC.messageComposeDelegate = self
        messageVC.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black];
        present(messageVC, animated: true, completion: nil)
        
    }
    
    // MARK: - Message Delegate method
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue:
            print("message canceled")
        case MessageComposeResult.failed.rawValue :
            print("message failed")
            
        case MessageComposeResult.sent.rawValue :
            print("message sent")
            self.rewardCredit()
        
        default:
            break
        }
        
        let cell = self.tableView.cellForRow(at: self.selCellIndexPth!)
        cell?.contentView.backgroundColor = UIColor.init(red: 45/255.0, green: 0/255.0, blue: 65/255.0, alpha: 1);
        
        controller.dismiss(animated: true) {
        }
    }
 
    func mailComposeController(_ controller: MFMailComposeViewController,didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("message canceled")
        case MFMailComposeResult.failed.rawValue :
            print("message failed")
        case MFMailComposeResult.sent.rawValue :
            print("message sent")
            self.rewardCredit()
        default:
            break
        }
        
        let cell = self.tableView.cellForRow(at: self.selCellIndexPth!)
        cell?.contentView.backgroundColor = UIColor.init(red: 45/255.0, green: 0/255.0, blue: 65/255.0, alpha: 1);
        
        controller.dismiss(animated: true) {
        }
 
    }
    
    func rewardCredit () {
        let credit = Credit();
        credit.requestOrder(user: self.appDelegate.user!, source: "referral", amount: 1000)
        
        credit.requestCredit(successCompletion: { (title:String, msg: String) in
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }) { (title:String, msg: String) in
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true,completion: nil)
        }
    }
 
}


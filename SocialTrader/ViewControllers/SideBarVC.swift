//
//  SideBarNC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-23.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class SideBarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView?
    let nc = NotificationCenter.default
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // View Delegates - Start
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.statusBarStyle = .lightContent
        self.tableView!.tableFooterView = UIView()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    // View Delegates - End
    
    
    func showAlert() {
        let alertController = UIAlertController(title: "Sign Out", message: "Do you want to sign out?", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: signOutNotification)
        alertController.addAction(defaultAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func signOutNotification(alert: UIAlertAction!) {
        self.dismiss(animated: false) {
           self.nc.post(name:Notification.Name(rawValue:"signout_request"),object: nil,userInfo: nil)
        }
    }
    
    // TableView Delegates - Start
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 60;
        }
        else {
            return 44;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if (indexPath.row == 0){
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! MenuHeaderCell;
            headerCell.fname?.text = appDelegate.user?.first_name;
            headerCell.lname?.text = appDelegate.user?.last_name;
            headerCell.selectionStyle = UITableViewCellSelectionStyle.none
            
            if let url = URL(string: (appDelegate.user?.pictureUrl)!) {
                headerCell.photo?.contentMode = .scaleAspectFit
                headerCell.photo?.layer.cornerRadius = 10.0
                headerCell.photo?.clipsToBounds = true
                downloadImage(url: url,imageView: headerCell.photo!)
            }
        
            return headerCell;
        }
        else {
            switch (indexPath.row){
            
            /*
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "menuCreditCell", for: indexPath) as! MenuTableViewCell
                cell.titleLbl?.text = "Add Credit";
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell;
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "menuReferCell", for: indexPath) as! MenuTableViewCell
                cell.titleLbl?.text = "Invite your friend";
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell;
            */
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "menuLogOutCell", for: indexPath) as! MenuTableViewCell
                cell.titleLbl?.text = "Sign out";
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell;
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "menuAboutAppCell", for: indexPath) as! MenuTableViewCell
                cell.titleLbl?.text = "About App";
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell;
            default:
                let cell = UITableViewCell();
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
            /*
             case 1:
             performSegue(withIdentifier: "productVCSegue", sender: nil)
             
             case 2:
             performSegue(withIdentifier: "referVCSegue", sender: nil)
             */
        case 1:
            showAlert();
        case 2:
            performSegue(withIdentifier: "aboutAppSegue", sender: nil)
            
        default:
            break
        }
    }
    // Tableview Delegates - End
    

    
    // Axillary
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView:UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    
}

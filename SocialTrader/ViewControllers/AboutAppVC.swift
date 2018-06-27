//
//  AboutAppVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-06-07.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class AboutAppVC: UITableViewController {

    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.statusBarStyle = .lightContent
        self.tableView!.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Tableview

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 140;
        }
        if (indexPath.row == 1){
            return 110;
        }
        else {
            return 88;
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell =  UITableViewCell();
        
        switch (indexPath.row){
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell", for: indexPath)
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "CreditCell", for: indexPath)
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCell", for: indexPath)
            
        default:
            break
        }
        return cell;
    }
    
    // MARK: User Interaction
    @IBAction func backButtonClicked(){
        self.dismiss(animated: true) {
        }
    }
}

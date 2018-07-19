//
//  ProductTableView.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-25.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit

class ProductVC: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        IAPHandler.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IAPHandler.shared.iapProducts.count;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = IAPHandler.shared.iapProducts[indexPath.row].priceLocale
        
        let priceStr = numberFormatter.string(from: IAPHandler.shared.iapProducts[indexPath.row].price)
        cell.nameLbl?.text = IAPHandler.shared.iapProducts[indexPath.row].localizedDescription;
        cell.priceLbl?.text = priceStr;
        cell.contentView.backgroundColor = UIColor.init(red: 111/255.0, green: 82/255.0, blue: 121/255.0, alpha: 1);
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.init(red: 133/255.0, green: 103/255.0, blue: 139/255.0, alpha: 1);
        
        IAPHandler.shared.purchaseMyProduct(index: indexPath.row, success: {
            
            var msg: String?
            let title = "Successful Purchase"
            if (indexPath.row == 0) {
                msg = NSLocalizedString("Purchase_Confirmed_20K", comment: "")
            }
            if (indexPath.row == 1) {
                msg = NSLocalizedString("Purchase_Confirmed_50K", comment: "")
            }
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true,completion: nil)
            
            if let user = self.appDelegate.user {
                user.requestUserProfile {
                    self.tableView.reloadData();
                }
            }
            
        }) {
            let msg = NSLocalizedString("Purchase_Failed", comment: "")
            let title = "Unsuccessful Purchase"
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true,completion: nil)
            self.tableView.reloadData();
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
}

//
//  BuySellVCViewController.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-31.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BuySellVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var position: Position?
    var symbol: String?
    var isBuy: Bool?
    var total: Double?
    var quote: Double?
    var quantity: Int?
    var textField: UITextField?;
    var totalLbl: UILabel?
    var trxFee = 1.0;
    var isKeyboardShown: Bool?
    var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.tap = UITapGestureRecognizer(target: self, action: #selector(BuySellVC.dismissKeyboard))
        self.symbol = appDelegate.selectedStock?.key;
        self.isKeyboardShown = false;
        
    }
    
    @objc func keyboardWillAppear() {
        self.isKeyboardShown = true;
        view.addGestureRecognizer(self.tap!)
        
    }
    
    @objc func keyboardWillDisappear() {
        self.isKeyboardShown = false;
        view.removeGestureRecognizer(self.tap!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        if (self.isKeyboardShown == true) {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.position = appDelegate.user?.portfolio?.getPosition(_symbol: appDelegate.selectedStock!.key);
        
        if (isBuy == true) {
            self.title = "Buy"
        }
        else {
            self.title = "Sell"
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        
        var cell: TrxInfoCell = TrxInfoCell();
        var actionCell: TrxActionCell = TrxActionCell();
        var inputCell: TrxInputCell = TrxInputCell();
        
        
        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! TrxInfoCell ;
            cell.titleLbl?.text = "Symbol"
            cell.subtitleLbl?.text = self.symbol;
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! TrxInfoCell ;
            cell.titleLbl?.text = "Unit Price"
            let quoteStr = appDelegate.market?.quotes[(appDelegate.selectedStock?.key.lowercased())!];
            self.quote = quoteStr!.price;
            cell.subtitleLbl?.text = String(format:"$%.2f",self.quote!);
        case 2:
            inputCell = tableView.dequeueReusableCell(withIdentifier: "cellInput", for: indexPath) as! TrxInputCell;
            inputCell.titleLbl?.text = "Quantity"
            self.textField = inputCell.inputTxtField!;
            
            self.textField?.addTarget(self, action: #selector(BuySellVC.textFieldDidChange(_:)),
                                for: UIControlEvents.editingChanged)

        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! TrxInfoCell ;
            cell.titleLbl?.text = "Fee"
            cell.subtitleLbl?.text = "$1.00";
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! TrxInfoCell ;
            cell.titleLbl?.text = "Total"
            if (self.quantity != nil) {
                
                if (isBuy == true) {
                    self.total = Double(self.quantity!) * self.quote! + self.trxFee;
                }
                else {
                    self.total = Double(self.quantity!) * self.quote! - self.trxFee;
                }
                
                
                cell.subtitleLbl?.text = String(format:"$%.2f",self.total!);
            }
            self.totalLbl = cell.subtitleLbl;
        case 5:
            actionCell = tableView.dequeueReusableCell(withIdentifier: "cellAction", for: indexPath) as! TrxActionCell;
            actionCell.titleLbl?.text = "Confirm";
        case 6:
            actionCell = tableView.dequeueReusableCell(withIdentifier: "cellAction", for: indexPath) as! TrxActionCell;
            actionCell.titleLbl?.text = "Cancel";
            
        default:
            return cell;
        }
        
        return cell
    }
    
    @IBAction func cancelButtonClicked(){
        self.appDelegate.selectedStock = nil;
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
            case 5:
            
                if (isBuy == true) {
                    self.executeBuy();
                }
                else {
                    self.executeSell();
                }
            
            case 6:
                self.navigationController?.popViewController(animated: true);
            default:
                return;
        
        }
        
    }
    
    func executeBuy(){
    
        let param = RequestGenerator.requestOrder(user: self.appDelegate.user!,
                                                     symbol: appDelegate.selectedStock!.key as NSString!,
                                                     name: appDelegate.selectedStock!.name as NSString!,
                                                     qty: self.quantity!,
                                                     price: self.quote!,
                                                     fee: self.trxFee);
        
        let url = Constants.bsae_url + "user/portfolio/";
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding:JSONEncoding.default).responseJSON { response in
                if let result = response.result.value {
                   let json = JSON(result)
                   if (json["status"] == "200") {
                    self.appDelegate.user?.fetchPortfolio(completion: {
                    })
                        let msg = "Buy order confirmed";
                        let alert = UIAlertController(title: "Successful Buy", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                        self.navigationController?.popViewController(animated: true);
                        }))
                        self.present(alert, animated: true,completion: nil)
                 }
            }
        }
    }
    
    func executeSell() {
        let param = RequestGenerator.requestOrder(user: self.appDelegate.user!,
                                                symbol: appDelegate.selectedStock!.key as NSString!,
                                                name: appDelegate.selectedStock!.name as NSString!,
                                                   qty: self.quantity!,
                                                 price: self.quote!,
                                                   fee: self.trxFee);
        
        let url = Constants.bsae_url + "user/portfolio/";
        Alamofire.request(url, method: HTTPMethod.put, parameters: param, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let json = JSON(result)
                if (json["status"] == "200") {
                    self.appDelegate.user?.fetchPortfolio(completion: {
                
                    })
                    let msg = "Sell order confirmed";
                    let alert = UIAlertController(title: "Successful Sell", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                        self.navigationController?.popViewController(animated: true);
                    }))
                    self.present(alert, animated: true, completion: nil);
                }
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true;
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let str = textField.text!
        self.quantity = Int(str);
        
        if (isBuy == true) {
            self.total = Double(self.quantity!) * self.quote! + self.trxFee;
        }
        else {
            self.total = Double(self.quantity!) * self.quote! - self.trxFee;
        }
        
        self.totalLbl?.text = String(format:"$%.2f",self.total!);
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        return;
    }

}




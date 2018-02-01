//
//  BuySellVCViewController.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-31.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class BuySellVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var position: Position?
    var isBuy: Bool?
    var total: Double?
    var quote: Double?
    var quantity: Int?
    var textField: UITextField?;
    var totalLbl: UILabel?
    var trxFee = 1.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BuySellVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.position = appDelegate.user?.portfolio?.getPosition(_symbol: appDelegate.selectedStock!.key);
        
    
        if (isBuy! == true) {
            self.title = "Buy"
        }
        else {
            self.title = "Sell"
        }
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
            cell.subtitleLbl?.text = appDelegate.selectedStock?.key;
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
                self.total = Double(self.quantity!) * self.quote! + self.trxFee;
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
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true;
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let str = textField.text!
        self.quantity = Int(str);
        self.total = Double(self.quantity!) * self.quote! + self.trxFee;
        self.totalLbl?.text = String(format:"$%.2f",self.total!);
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        return;
    }

}




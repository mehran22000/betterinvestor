//
//  StockVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-20.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class StockVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var position: Position?
    var trxIsBuy: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"portfolio_updated"),
                       object:nil, queue:nil) {
                        notification in
                        self.tableView.reloadData();
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.position = appDelegate.user?.portfolio?.getPosition(_symbol: appDelegate.selectedStock!.key);
        self.title = appDelegate.selectedStock?.key.uppercased();
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        
        var cell: StockInfoCell = StockInfoCell();
        var actionCell: StockActionCell = StockActionCell();
        
        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! StockInfoCell ;
            cell.titleLbl?.text = "Full Name"
            cell.subtitleLbl?.text = appDelegate.selectedStock?.name;
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! StockInfoCell ;
            cell.titleLbl?.text = "Last Trade"
            let quote = appDelegate.market?.quotes[(appDelegate.selectedStock?.key.lowercased())!];
            cell.subtitleLbl?.text = String(format:"$%.2f",(quote?.price)!);
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! StockInfoCell ;
            cell.titleLbl?.text = "Own"
            cell.subtitleLbl!.text = String(describing: self.position!.qty);
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! StockInfoCell ;
            cell.titleLbl?.text = "Cost"
            cell.subtitleLbl?.text = String(format:"$%.2f",self.position!.cost);
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) as! StockInfoCell ;
            cell.titleLbl?.text = "Gain / Lost"
            cell.subtitleLbl?.text = String(format:"$%.2f",self.position!.gain);
        case 5:
            actionCell = tableView.dequeueReusableCell(withIdentifier: "cellAction", for: indexPath) as! StockActionCell;
            actionCell.leftIcon?.image = UIImage(named: "buy_stock");
            actionCell.titleLbl?.text = "Buy";
        case 6:
            actionCell = tableView.dequeueReusableCell(withIdentifier: "cellAction", for: indexPath) as! StockActionCell;
            actionCell.leftIcon?.image = UIImage(named: "sell_stock");
            actionCell.titleLbl?.text = "Sell";
        case 7:
            actionCell = tableView.dequeueReusableCell(withIdentifier: "cellAction", for: indexPath) as! StockActionCell;
            actionCell.leftIcon?.image = UIImage(named: "holders");
            actionCell.titleLbl?.text = "Other Holders";
        
        default:
            cell = StockInfoCell();
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func cancelButtonClicked(){
        self.appDelegate.selectedStock = nil;
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row{
        case 5:
            self.trxIsBuy = true;
            performSegue(withIdentifier: "segueTrx", sender: nil)
        case 6:
            self.trxIsBuy = false;
            performSegue(withIdentifier: "segueTrx", sender: nil)
        case 7:
            performSegue(withIdentifier: "segueHolders", sender: nil)
        default:
            return;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if(segue.identifier == "segueTrx") {
            
            let buySellVC = (segue.destination as! BuySellVC);
            if (self.trxIsBuy == true) {
                buySellVC.isBuy = true;
            }
            else {
                buySellVC.isBuy = false;
            }
        }
        
    }
    
    
}

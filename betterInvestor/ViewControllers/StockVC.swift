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
    @IBOutlet var symbolLable: UILabel!
    @IBOutlet var nameLable: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var position: Position?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.position = appDelegate.user?.portfolio?.getPosition(_symbol: appDelegate.selectedStock!.key);
        self.title = appDelegate.selectedStock?.key;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        
        var cell: UITableViewCell = UITableViewCell();
        var actionCell: StockActionCell = StockActionCell();
        
        switch (indexPath.row) {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) ;
            cell.textLabel?.text = "Full Name"
            cell.detailTextLabel?.text = appDelegate.selectedStock?.name;
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) ;
            cell.textLabel?.text = "Last Trade"
            let quote = appDelegate.market?.quotes[(appDelegate.selectedStock?.key.lowercased())!];
            cell.detailTextLabel?.text = String(format:"$%.2f",(quote?.price)!);
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) ;
            cell.textLabel?.text = "Own"
            cell.detailTextLabel!.text = String(describing: self.position!.qty);
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) ;
            cell.textLabel?.text = "Cost"
            cell.detailTextLabel?.text = String(format:"$%.2f",self.position!.cost);
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "cellInfo", for: indexPath) ;
            cell.textLabel?.text = "Gain / Lost"
            cell.detailTextLabel?.text = String(format:"$%.2f",self.position!.gain);
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
            cell = UITableViewCell();
        }
    
        return cell
    }
    
    @IBAction func cancelButtonClicked(){
        self.appDelegate.selectedStock = nil;
        self.navigationController?.popViewController(animated: true);
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

//
//  FriendPortfolioVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-03-07.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMobileAds


class FriendPortfolioVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // User's Friend Record
    var user: User?
    
    @IBOutlet var portfolioTableView: UITableView!
    
    // Admob
    // @IBOutlet var viewBanner:GADBannerView?
    
    var screenSize: CGRect?;
    var screenWidth, screenHeight:CGFloat?;
    var portfolioHeight: Int?
    var yAdView: Int?
    var yPortfolio: Int?
    var marketUpdated = false;
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }

    var performance_btn_mode = Gain_Mode.gain;
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.user?.first_name
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize!.width
        self.screenHeight = screenSize!.height
        
        portfolioTableView?.tableFooterView = UIView()
        
        if (self.user != nil) {
            self.user?.requestPortfolio(completion: {
                self.appDelegate.market.addToStockList(portfolio: self.user!.portfolio, completion: {
                    self.marketUpdated = true;
                    self.user?.portfolio.calculateGain();
                    self.portfolioTableView.reloadData();
                })
            })
        }
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.statusBarStyle = .lightContent
       // self.addAdMob()
    }
    
    
    // MARK: User Interaction
    @IBAction func performanceBtnClicked () {
        if (self.performance_btn_mode == Gain_Mode.gain) {
            self.performance_btn_mode = Gain_Mode.gain_precentage;
        }
        else {
            self.performance_btn_mode = Gain_Mode.gain;
        }
        self.portfolioTableView.reloadData()
    }
    
    @objc func sideMenuClicked(){
        performSegue(withIdentifier: "segueSideMenu", sender: nil);
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "segueSideMenu", sender: nil);
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    
    // MARK: Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row == 0){
            return 120;
        }
        else if (indexPath.row == 1){
            return 150;
        }
        else {
            return 50;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let portfolio = self.user?.portfolio {
            return portfolio.positions.count + 2;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let portfolio = self.user?.portfolio;
        var gain: Double = 0;
        var gain_precentage: Double = 0;
        var gain_str = "-";
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        let formattedCash = numberFormatter.string(from: NSNumber(value:(self.user?.portfolio.cash)!))
        let formattedStockValue = numberFormatter.string(from: NSNumber(value:(portfolio!.total_stock_value)))
        let formattedGain = numberFormatter.string(from: NSNumber(value:(portfolio!.total_gain)))
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell;
            cell.photo.image = self.user?.pic;
            cell.photo.contentMode = .scaleAspectFit
            cell.photo.layer.cornerRadius = 10.0
            cell.photo.clipsToBounds = true
            return cell;
        }
        
        else if (indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! PortfolioSummaryCell;
            cell.cashLbl?.text = formattedCash!;
            cell.stockLbl?.text = formattedStockValue;
            cell.totalGainLbl?.text = formattedGain! + "(" + String(format:"%.2f",portfolio!.total_gain_precentage) + "%)" ;
            
            if (user?.global_rank != nil) {
                cell.rankGlobalLbl?.text = String(describing: user!.global_rank!);
            }
            return cell;
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
            var price_str = "-";
            
            if let position = portfolio?.positions[indexPath.row-2] {
                let quote = self.appDelegate.market.quotes[(position.symbol)];
                cell.symbolLbl?.text = position.symbol.uppercased();
            
                if (quote != nil) {
                    price_str = String(format:"%.2f",quote!.price);
                    gain = position.gain
                    gain_precentage = position.gain_precentage
                    cell.priceLbl?.text = price_str;
                }
            
                if (performance_btn_mode == Gain_Mode.gain_precentage){
                    gain_str = String(format:"%.0f",gain_precentage) + "%";
                }
                else {
                    gain_str = String(format:"%.2f",gain);
                }
            }
            
            if (gain >= 0) {
                gain_str = "+" + gain_str;
                cell.performanceBtn.backgroundColor = UIColor.init(red: 167/255.0, green: 225/255.0, blue: 113/255.0, alpha: 1);
            }
            else {
                cell.performanceBtn.backgroundColor = UIColor.init(red: 255/255.0, green: 163/255.0, blue: 164/255.0, alpha: 1);
            }
            cell.performanceBtn?.setTitle(gain_str, for: UIControlState.normal)
            
            return cell;
        }
    }
    
    /*
     func addAdMob(){
     // Place AdMob at the bottom of the screen
     let adFrame = CGRect (x: 0, y: self.yAdView!, width: Int(screenWidth!), height: Constants.adViewHeight);
     let bannerView = GADBannerView.init(frame: adFrame);
     bannerView.backgroundColor = UIColor.init(red: 43/255.0, green: 8/255.0, blue: 60/255.0, alpha: 1);
     bannerView.adUnitID = "ca-app-pub-5267718216518748/5568296429";
     let gadRequest = GADRequest();
     gadRequest.testDevices = [kGADSimulatorID];
     bannerView.rootViewController = self;
     bannerView.load(gadRequest);
     self.view.addSubview(bannerView);
     }
     */
}

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
    
    // User Ranking Record
    var user: User?
    
    // Portfolio
    @IBOutlet var portfolioTableView: UITableView!
    
    // Admob
    @IBOutlet var viewBanner:GADBannerView?
    
    // Sub Views Coordination
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.user?.first_name
        
        // Replace Menu icon with close
        // navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"next"), style: .plain, target: self, action: #selector(sideMenuClicked))
        
        // navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize!.width
        self.screenHeight = screenSize!.height
        
        portfolioTableView?.tableFooterView = UIView()
        
        // Set Observers
        /*
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        
        nc.addObserver(forName:Notification.Name(rawValue:"quotes_updated"),
                       object:nil, queue:nil) {
                        notification in
                        if (self.marketUpdated == true) {
                            self.user?.portfolio?.calculateGain();
                            self.portfolioTableView.reloadData();
                        }
        }
        
        nc.addObserver(forName:Notification.Name(rawValue:"portfolio_updated"),
                       object:nil, queue:nil) {
                        notification in
                        
                        let user_id = notification.userInfo?["user_id"] as? String;
                        if (user_id == self.user?.id) {
                            self.portfolioTableView.reloadData();
                        }
        }
        */
        
        self.user?.fetchPortfolio(completion: {
            self.appDelegate.market!.addToStockList(user: self.user!, completion: {
                self.marketUpdated = true;
                self.user?.portfolio?.calculateGain();
                self.portfolioTableView.reloadData();
            })
            
        })
    }
    
    
    @objc func sideMenuClicked(){
        performSegue(withIdentifier: "segueSideMenu", sender: nil);
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "segueSideMenu", sender: nil);
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        
        
        UIApplication.shared.statusBarStyle = .lightContent
       // self.portfolioHeight = Int(screenHeight!) - Constants.pageViewHeight - Constants.pageControlHeight - Constants.adViewHeight - Constants.segmentViewHeight;
        
       // self.yPortfolio = 0;
       // self.yAdView = yPageControlView! + Constants.pageControlHeight;
        let width = Int(screenWidth!);
        
       // self.portfolioTableView.frame = CGRect(x: 0, y: self.yPortfolio!, width: width, height: self.portfolioHeight!);
    
       // self.addAdMob()
    }
    
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
    
    
    @IBAction func performanceBtnClicked () {
        if (self.performance_btn_mode == Gain_Mode.gain) {
            self.performance_btn_mode = Gain_Mode.gain_precentage;
        }
        else {
            self.performance_btn_mode = Gain_Mode.gain;
        }
        self.portfolioTableView.reloadData()
    }
    
    // Page View Methods - End
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0){
            return 150;
        }
        else {
            return 50;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let portfolio = self.user?.portfolio {
            return (portfolio.positions?.count)! + 1;
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
        let formattedCash = numberFormatter.string(from: NSNumber(value:(self.user?.portfolio?.cash)!))
        let formattedStockValue = numberFormatter.string(from: NSNumber(value:(portfolio!.total_stock_value)))
        let formattedGain = numberFormatter.string(from: NSNumber(value:(portfolio!.total_gain)))
        
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! PortfolioSummaryCell;
            cell.cashLbl?.text = formattedCash!;
            cell.stockLbl?.text = formattedStockValue;
            cell.totalGainLbl?.text = formattedGain! + "(" + String(format:"%.2f",portfolio!.total_gain_precentage) + "%)" ;
            
            if (user?.global_rank != nil) {
                cell.rankGlobalLbl?.text = String(describing: user!.global_rank!);
            }
            
            return cell;
            // cell.symbolLbl?.text = "TOTAL";
            // gain = portfolio!.total_gain;
            // cell.priceLbl?.text = "";
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
            var price_str = "-";
            let position = portfolio!.positions![indexPath.row-1];
            let quote = self.appDelegate.market?.quotes[(position.symbol)];
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
}

//
//  ViewController.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-10-19.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Charts
import SideMenu
import Alamofire
import SwiftyJSON

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Portfolio
    @IBOutlet var portfolioTableView: UITableView!
    
    // Page Views
    @IBOutlet var segmentControlView: UISegmentedControl!
    @IBOutlet var pageViewHolder: UIView!
    @IBOutlet var segmentView: UIView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var pageControlView: UIView!
    
    var rankingVC : RankingTableVC?
    var pichartView: UIView?
    var linechartView: UIView?
    var pageViewIndex: Int?
    
    // Admob
    @IBOutlet var viewBanner:GADBannerView?
    
    // Sub Views Coordination
    var screenSize: CGRect?;
    var screenWidth, screenHeight:CGFloat?;
    var portfolioHeight: Int?
    var yAdView: Int?
    var yPortfolio: Int?
    var ySegmentView: Int?
    var yPageView: Int?
    var yPageControlView: Int?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Portfolio"
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"menu"), style: .plain, target: self, action: #selector(sideMenuClicked))
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        
        
        SideMenuManager.default.menuFadeStatusBar = false;
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize!.width
        self.screenHeight = screenSize!.height
        
        portfolioTableView?.tableFooterView = UIView()
        
        // Swipe Guesture Recognition
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        // Set Observers
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        nc.addObserver(forName:Notification.Name(rawValue:"quotes_updated"),
                       object:nil, queue:nil) {
                        notification in
                        self.portfolioTableView.reloadData();
        }
        
        // reset selectedStock
        appDelegate.selectedStock = nil;
        
        
        fetchPortfolio();
        
    }
    
    
    @objc func sideMenuClicked(){
        performSegue(withIdentifier: "segueSideMenu", sender: nil);
    }
    
    
    @objc func addButtonClicked(){
        self.navigationController?.isNavigationBarHidden = true;
        performSegue(withIdentifier: "segueSymbolSearch", sender: nil);
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.portfolioHeight = Int(screenHeight!) - Constants.pageViewHeight - Constants.pageControlHeight - Constants.adViewHeight - Constants.segmentViewHeight;
        
        self.yPortfolio = 0;
        self.ySegmentView = portfolioHeight;
        self.yPageView = self.ySegmentView! + Constants.segmentViewHeight;
        self.yPageControlView = self.yPageView! + Constants.pageViewHeight;
        self.yAdView = yPageControlView! + Constants.pageControlHeight;
        let width = Int(screenWidth!);
        
        self.portfolioTableView.frame = CGRect(x: 0, y: self.yPortfolio!, width: width, height: self.portfolioHeight!);
        
        self.pageViewHolder.frame = CGRect(x:0,y:self.yPageView!,width:width,height:Constants.pageViewHeight);
    
        
        // Ranking View Controllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.rankingVC = storyboard.instantiateViewController(withIdentifier: "RankingVC") as? RankingTableVC
        self.rankingVC?.view.frame = CGRect(x:0,y:0,width:width,height:Constants.pageViewHeight);
        self.addChildViewController(self.rankingVC!);
        
        // PiChart Demo
        self.pichartView = HalfPieChartViewController.init().view;
        self.pichartView?.frame = CGRect(x:0,y:0,width:width,height:Int(screenHeight!));
        
        // LineChart Demo
        self.linechartView = LineChart1ViewController.init().view;
        self.linechartView?.frame = CGRect(x:0,y:0,width:width,height:Constants.pageViewHeight);
        
        
        // Default Page
        self.pageViewIndex = 0;
        self.pageViewHolder.addSubview((self.rankingVC?.view)!);
        self.addSegmentControl();
        self.addPageControl();
        self.addAdMob()
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
    
    func addPageControl() {
        let width = Int(screenWidth!);
        self.pageControlView.frame = CGRect (x: 0, y: self.yPageControlView!, width: width, height: Constants.pageControlHeight);
        self.view.addSubview(self.pageControlView);
    }
    
    func addSegmentControl () {
        let width = Int(screenWidth!);
        
        switch self.pageViewIndex! {
            
        case 0:
            self.segmentControlView.setTitle("Friends", forSegmentAt: 0);
            self.segmentControlView.setTitle("All", forSegmentAt: 1);
        case 1:
            self.segmentControlView.setTitle("Gain", forSegmentAt: 0);
            self.segmentControlView.setTitle("Loss", forSegmentAt: 1);
        case 2:
            self.segmentControlView.setTitle("Month", forSegmentAt: 0);
            self.segmentControlView.setTitle("All", forSegmentAt: 1);
        default:
            print ("Error: Page Index incorrect");
        }
        
        self.segmentControlView.selectedSegmentIndex = 0;
        self.segmentView.frame = CGRect(x: 0, y: self.ySegmentView!, width: width, height: Constants.segmentViewHeight);
        self.segmentControlView.frame = CGRect(x: Int(width/2 - width/4), y: 5, width: width/2, height: Constants.segmentControlHeight);
        
    }
    

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
            self.pageViewIndex = self.pageViewIndex! + 1;
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
            self.pageViewIndex = self.pageViewIndex! - 1;
        }
        else {
            print("Neighter Swipe Left nor Right")
        }
        
        if (self.pageViewIndex == -1){
            self.pageViewIndex = 2;
        }
        
        if (self.pageViewIndex == 3){
            self.pageViewIndex = 0;
        }
        
        switch pageViewIndex! {
                case 0:
                    self.pageControl.currentPage = 0;
                    self.pageViewHolder.addSubview((self.rankingVC?.view)!);
                case 1:
                    self.pageControl.currentPage = 1;
                    self.pageViewHolder.addSubview(self.pichartView!);
                case 2:
                    self.rankingVC?.view.removeFromSuperview();
                    self.pageControl.currentPage = 2;
                    self.pageViewHolder.addSubview(self.linechartView!);
                default:
                    print ("Error: Page Index incorrect");
        }
        self.addSegmentControl();
        
        self.addPageControl();
        
        
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            self.pageViewHolder.pageAnimation(leftToRight:true);
        }
        else {
            self.pageViewHolder.pageAnimation(leftToRight:false);
        }
        
        self.addAdMob();
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let portfolio = appDelegate.user?.portfolio {
            return (portfolio.positions?.count)! + 1;
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
        let portfolio = appDelegate.user?.portfolio;
        let market = appDelegate.market;
        var gain: Double = 0;
        var gain_str = "-";
        
        if (indexPath.row == 0){
            cell.symbolLbl?.text = "TOTAL";
            gain = portfolio!.total_gain;
        }
        else {
            var price_str = "-";
            let position = portfolio!.positions![indexPath.row-1];
            let quote = market?.quotes[(position.symbol)];
            cell.symbolLbl?.text = position.symbol.uppercased();
    
            if (quote != nil) {
                price_str = String(format:"%.2f",quote!.price);
                gain = (position.gain)
                cell.priceLbl?.text = price_str;
            }
        }

        gain_str = String(format:"%.2f",gain);
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
    
    
    func fetchPortfolio() {
        let url = Constants.bsae_url + "user/portfolio/"+(appDelegate.user?.id)!;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == "200") {
                    ResponseParser.parseUserPortfolio(json: jsonDic,user: self.appDelegate.user!);
                    self.appDelegate.market = Market.init();
                    self.portfolioTableView.reloadData();
                    self.fetchSymbols();
                }
            }
        }
    }
    
    func fetchSymbols() {
        
        let symbol_version = UserDefaults.standard.value(forKey: "symbols_version") as! String;
        
        let url = Constants.bsae_url + "market/stock/symbols/version/"+symbol_version;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == "200") {
                    ResponseParser.parseSymbols(json: jsonDic);
                }
            }
        }
    }
    
    
}

extension UIView {
    func pageAnimation(duration: TimeInterval = 0.5, completionDelegate: AnyObject? = nil, leftToRight:Bool) {
        // Create a CATransition object
        let leftToRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            leftToRightTransition.delegate = delegate
        }
        
        leftToRightTransition.type = kCATransitionPush
        if (leftToRight == true){
            leftToRightTransition.subtype = kCATransitionFromLeft
        }
        else {
            leftToRightTransition.subtype = kCATransitionFromRight
        }
        leftToRightTransition.duration = duration
        leftToRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        leftToRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(leftToRightTransition, forKey: "leftToRightTransition")
    }
}

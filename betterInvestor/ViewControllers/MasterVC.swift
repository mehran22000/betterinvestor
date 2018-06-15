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
    var pageViewIndex: Int = 0;
    
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
    
    // Timer
    var refreshTimer: Timer!
    
    
    @objc func refreshQuote () {
        print ("refreshQuote called");
        self.appDelegate.market?.fetchStockPrice (completion: {
            self.appDelegate.user?.portfolio.calculateGain()
            self.portfolioTableView.reloadData();
            
          //  if self.isVisible(view: self.view){
          //       self.refreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.refreshQuote), userInfo: nil, repeats: false);
          //  }
        })
    }
    
    
    public func isVisible(view: UIView) -> Bool {
        
        if view.window == nil {
            return false
        }
        
        var currentView: UIView = view
        while let superview = currentView.superview {
            
            if (superview.bounds).intersects(currentView.frame) == false {
                return false;
            }
            
            if currentView.isHidden {
                return false
            }
            
            currentView = superview
        }
        
        return true
    }
    
    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }
    
    
    var performance_btn_mode = Gain_Mode.gain;
    
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
       
        /*
        nc.addObserver(forName:Notification.Name(rawValue:"quotes_updated"),
                       object:nil, queue:nil) {
                        notification in
                        self.appDelegate.user?.portfolio?.calculateGain();
                        self.portfolioTableView.reloadData();
        }
        */
        
        nc.addObserver(forName:Notification.Name(rawValue:"portfolio_updated"),
                       object:nil, queue:nil) {
                        notification in
                        self.portfolioTableView.reloadData();
        }
        
        
        nc.addObserver(forName:Notification.Name(rawValue:"signout_request"),
                       object:nil, queue:nil) {
                        notification in
                        self.signOut()
        }
        
        // reset selectedStock
        appDelegate.selectedStock = nil;
        
        appDelegate.masterVC = self;
        
        
    }
    
    
    @objc func sideMenuClicked(){
        performSegue(withIdentifier: "segueSideMenu", sender: nil);
    }
    
    
    @objc func addButtonClicked(){
        self.navigationController?.isNavigationBarHidden = true;
        performSegue(withIdentifier: "segueSymbolSearch", sender: nil);
    }
    
    func signOut (){
        UserDefaults.standard.removeObject(forKey: "user");
        self.navigationController?.popViewController(animated: true);
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
      //  self.refreshTimer.invalidate();
      //  self.refreshTimer = nil;
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
        
        
        // self.refreshTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.refreshQuote), userInfo: nil, repeats: true);
        
        let user = self.appDelegate.user;
        fetchSymbols (completion: {
            user?.fetchPortfolio(completion: {
                self.appDelegate.market = Market.init(portfolio: (user?.portfolio)!)
                self.appDelegate.market?.fetchStockPrice (completion: {
                    user?.portfolio.calculateGain()
                    self.portfolioTableView.reloadData();
                    user?.fetchGainHistory (completion:{
                        user?.fetchRanking(global: false, count: 10, completion: {self.rankingVC?.table?.reloadData()})
                    })
                })
            })
        })
        

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
    
    
    @IBAction func performanceBtnClicked () {
        if (self.performance_btn_mode == Gain_Mode.gain) {
            self.performance_btn_mode = Gain_Mode.gain_precentage;
        }
        else {
            self.performance_btn_mode = Gain_Mode.gain;
        }
        self.portfolioTableView.reloadData()
    }
    
    
    // Page View Methods
   
    @IBAction func segmentControlChanged(_ sender: AnyObject) {
        
        switch self.pageViewIndex
        {
            case 0:
                
                switch segmentControlView.selectedSegmentIndex
                {
                case 0:
                    self.rankingVC?.screenMode = RankingTableVC.ScreenMode.Friends;
                    self.rankingVC?.fetchFriendsRanking()
                case 1:
                    self.rankingVC?.screenMode = RankingTableVC.ScreenMode.All;
                    self.rankingVC?.fetchGlobalRanking()
                default:
                    break
                }
        
            case 1:
        
                switch segmentControlView.selectedSegmentIndex
                {
                    case 0:
                        switchPageView(viewIndex: self.pageViewIndex, mode: 0)
                    case 1:
                        switchPageView(viewIndex: self.pageViewIndex, mode: 1)
                    default:
                        break
                }
        
            case 2:
                
                switch segmentControlView.selectedSegmentIndex
                {
                    case 0:
                        switchPageView(viewIndex: self.pageViewIndex, mode: 0)
                    case 1:
                        switchPageView(viewIndex: self.pageViewIndex, mode: 1)
                    default:
                        break
                }
            
            
            default:
                break;
            
        }
    }
        
        
        
        
    

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
    
        // find pageViewIndex
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            self.pageViewIndex = self.pageViewIndex + 1;
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.right {
            self.pageViewIndex = self.pageViewIndex - 1;
        }
        
        
        if (self.pageViewIndex == -1){
            self.pageViewIndex = 2;
        }
        
        if (self.pageViewIndex == 3){
            self.pageViewIndex = 0;
        }
        
        
        self.switchPageView(viewIndex: self.pageViewIndex, mode:0)
        
        self.addSegmentControl();
        
        self.addPageControl();
        
        
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            self.pageViewHolder.pageAnimation(leftToRight:true);
        }
        else {
            self.pageViewHolder.pageAnimation(leftToRight:false);
        }
        
    }
    
    
    func switchPageView(viewIndex:Int, mode:Int){
        let width = Int(screenWidth!);
        
        switch viewIndex {
        case 0:
            self.pageControl.currentPage = 0;
            self.pageViewHolder.addSubview((self.rankingVC?.view)!);
      
        case 1:
            self.pageControl.currentPage = 1;
            let pichartVC = HalfPieChartViewController.init();
            if (mode == 0){
                pichartVC.isGainMode = true;
            }
            else {
                pichartVC.isGainMode = false;
            }
            self.pichartView = pichartVC.view;
            self.pichartView?.frame = CGRect(x:0,y:0,width:width,height:Int(screenHeight!));
            self.pageViewHolder.addSubview(self.pichartView!);
            
        case 2:
            // self.rankingVC?.view.removeFromSuperview();
            self.pageControl.currentPage = 2;
            let linechartVC = LineChart1ViewController.init();
            if (mode == 0){
                linechartVC.isMonthMode = true;
            }
            else {
                linechartVC.isMonthMode = false;
            }
            self.linechartView = linechartVC.view;
            self.pageViewHolder.addSubview(self.linechartView!);
            
        default:
            print ("Error: Page Index incorrect");
        }
    }
    
    
    func addSegmentControl () {
        let width = Int(screenWidth!);
        
        switch self.pageViewIndex {
            
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
    
    
    // Page View Methods - End
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row > 0){
            if let portfolio = appDelegate.user?.portfolio {
                let position = portfolio.positions[indexPath.row-1]
                self.appDelegate.selectedStock = Symbol(key: position.symbol, name: position.name);
                performSegue(withIdentifier: "segueStockVC", sender: nil)
            }
        }
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
            return 160;
        }
        else {
            return 50;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let portfolio = appDelegate.user?.portfolio {
            if (portfolio.positions.count > 0) {
                return portfolio.positions.count + 1;
            }
            else {
                return 2;
            }
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let portfolio = appDelegate.user?.portfolio;
        let market = appDelegate.market;
        var gain: Double = 0;
        var gain_precentage: Double = 0;
        var gain_str = "-";
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.currency
        
        var formattedCash = "", formattedStockValue = "", formattedGain = "";
        if let cash = appDelegate.user?.portfolio.cash {
            formattedCash = numberFormatter.string(from: NSNumber(value:cash))!
        }
        
        if let stockValue = portfolio?.cash {
            formattedStockValue = numberFormatter.string(from: NSNumber(value:(stockValue)))!
        }
        
        if let totalGain = portfolio?.total_gain {
            formattedGain = numberFormatter.string(from: NSNumber(value:(totalGain)))!
        }
        
        
    
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! PortfolioSummaryCell;
            cell.cashLbl?.text = formattedCash;
            cell.stockLbl?.text = formattedStockValue;
            cell.totalGainLbl?.text = formattedGain + "(" + String(format:"%.2f",portfolio!.total_gain_precentage) + "%)" ;
            cell.rankFrinedsLbl?.text = "--"
            if (appDelegate.user?.global_rank != nil)
            {
                if (appDelegate.user!.global_rank! > 0) {
                    cell.rankGlobalLbl?.text = String(describing: appDelegate.user!.global_rank!);
                }
            }
            
            if (appDelegate.user?.friends_rank != nil)
            {
                if (appDelegate.user!.friends_rank! > 0) {
                    cell.rankFrinedsLbl?.text = String(describing: appDelegate.user!.friends_rank!);
                }
            }
            
            return cell;
            // cell.symbolLbl?.text = "TOTAL";
            // gain = portfolio!.total_gain;
            // cell.priceLbl?.text = "";
        }
        else {
            
            if (portfolio?.positions.count == 0){
                let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyPortfolioCell", for: indexPath);
                return cell;
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
                var price_str = "-";
                let position = portfolio?.positions[indexPath.row-1];
                let quote = market?.quotes[(position?.symbol)!];
                cell.symbolLbl?.text = position?.symbol.uppercased();
    
                if (quote != nil) {
                    price_str = String(format:"%.2f",quote!.price);
                    gain = (position?.gain)!
                    gain_precentage = (position?.gain_precentage)!
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
    
    /*
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
    */
    func fetchSymbols(completion:@escaping () -> Void) {
        
        let symbol_version = UserDefaults.standard.value(forKey: "symbols_version") as! String;
        
        let url = Constants.bsae_url + "market/stock/symbols/version/"+symbol_version;
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == "200") {
                    ResponseParser.parseSymbols(json: jsonDic);
                }
                completion();
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

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
import Amplify
import AWSMobileClient
import AmplifyPlugins


class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Portfolio
    @IBOutlet var portfolioTableView: UITableView!
    
    // Page Views
    @IBOutlet weak var segmentControlView: UISegmentedControl!
    @IBOutlet weak var pageViewHolder: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageControlView: UIView!
    //  @IBOutlet weak var activitySpinner: UIActivityIndicatorView?
    
    var rankingVC : RankingTableVC?
    var pichartView: UIView?
    var linechartView: UIView?
    var pageViewIndex: Int = 0;
    var is_fetching_data: Bool = true;
    
    // Admob
    @IBOutlet var bannerView:GADBannerView?;
    
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
    
    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }
    
    var performance_btn_mode = Gain_Mode.gain;
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // View Delegates - Start
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Portfolio"
       
        setNavItems();

        SideMenuManager.default.menuFadeStatusBar = false;
        portfolioTableView?.tableFooterView = UIView()
        appDelegate.masterVC = self;
        
        
        // Swipe Guesture Recognition
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        
        // Set Observers
        let nc = NotificationCenter.default // Note that default is now a property, not a method call
        
        
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
        
    }
    
    func setNavItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"menu"), style: .plain, target: self, action: #selector(sideMenuClicked))
        
        let uiBusy = UIActivityIndicatorView(activityIndicatorStyle: .white)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        if (self.is_fetching_data == false){
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        }
        else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uiBusy)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize!.width
        self.screenHeight = screenSize!.height
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.portfolioHeight = Int(screenHeight!) - Constants.pageViewHeight - Constants.pageControlHeight - Constants.adViewHeight - Constants.segmentViewHeight;
        
        self.yPortfolio = 0;
        self.ySegmentView = portfolioHeight;
        self.yPageView = self.ySegmentView! + Constants.segmentViewHeight;
        self.yPageControlView = self.yPageView! + Constants.pageViewHeight - self.pageControlAdjustment() - Constants.adViewHeight;
        
        
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
        self.addAdMob()
        
        // Core Data Load
        let user = self.appDelegate.user;
        let market = self.appDelegate.market
        market.requestSymbols (completion: {
            user?.requestPortfolio(completion: {
                market.setPortfolio(portfolio: (user?.portfolio)!)
                market.fetchStockPrice (completion: {
                    user?.portfolio.calculateGain()
                    self.portfolioTableView.reloadData();
                    user?.requestGainHistory (completion:{
                        user?.requestRanking(global: false, count: 10, completion:{
                            self.getS3PhotoList()});
                        self.is_fetching_data = false;
                        self.setNavItems();
                    })
                })
            })
        })
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       // self.addPageControl();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // View Delegates - End
    
    // View Navigations - Start
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if(segue.identifier == "segueStockVC") {
            let stockVC = (segue.destination as! StockVC);
            if let portfolio = appDelegate.user?.portfolio {
                let position = portfolio.positions[portfolioTableView.indexPathForSelectedRow!.row-1]
                stockVC.symbol = Symbol(key: position.symbol, name: position.name);
            }
        }
    }
    // View Navigations - End
    
    // TableView Delegates - Start
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
        
        if let stockValue = portfolio?.total_stock_value {
            formattedStockValue = numberFormatter.string(from: NSNumber(value:(stockValue)))!
        }
        
        if let totalGain = portfolio?.total_gain {
            formattedGain = numberFormatter.string(from: NSNumber(value:(totalGain)))!
        }
        
        
        if (indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! PortfolioSummaryCell;
            cell.selectionStyle = .none;
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
                let quote = market.quotes[(position?.symbol)!];
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
    
    @IBAction func performanceBtnClicked () {
        if (self.performance_btn_mode == Gain_Mode.gain) {
            self.performance_btn_mode = Gain_Mode.gain_precentage;
        }
        else {
            self.performance_btn_mode = Gain_Mode.gain;
        }
        self.portfolioTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row > 0){
            performSegue(withIdentifier: "segueStockVC", sender: nil)
        }
    }
    
    // TableView Delegates - End
    
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
        /*
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
        */
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
        
       // self.view.addSubview(self.segmentControlView);
        
    }
    
    func addPageControl() {
        let width = Int(screenWidth!);
        self.pageControlView.frame = CGRect (x: 0, y: self.yPageControlView!, width: width, height: Constants.pageControlHeight);
        self.view.addSubview(self.pageControlView);
    }
    // Page View Methods - End
    
    
    func pageControlAdjustment() -> Int {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
              case 1136: // iPhone 5 or 5S or 5C
                return 10;
              case 1334: // iPhone 6/6S/7/8
                return 10;
              case 1920, 2208: // iPhone 6+/6S+/7+/8+
                return 15;
            case 2436: // iPhone X
                return 55;
            default: // Unknown
                print("unknown")
                return 0;
            }
        }
        return 0;
    }
    
    // Amplify
    
    func getS3PhotoList() {
        var aws_valid_keys =  Dictionary<String,Bool>();
        Amplify.Storage.list { event in
            switch event {
            case let .completed(listResult):
                print("Completed")
                listResult.items.forEach { item in
                    print("Key: \(item.key)")
                    aws_valid_keys[item.key] = true;
                }
                self.rankingVC?.aws_valid_keys = aws_valid_keys;
                DispatchQueue.main.async { // Correct
                    self.rankingVC?.table?.reloadData()
                }
            case let .failed(storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            case let .inProcess(progress):
                print("Progress: \(progress)")
            default:
                break
            }
        }
    }
    

    // AdMobile
    
    func addAdMob(){
        self.bannerView!.adUnitID = "ca-app-pub-5267718216518748/5568296429";
        self.bannerView!.rootViewController = self;
        self.bannerView!.load(GADRequest());
    }
    
    /*
    func addAdMob(){
        // Place AdMob at the bottom of the screen
        let adFrame = CGRect (x: 0, y: self.yAdView!, width: Int(screenWidth!), height: Constants.adViewHeight);
        //let bannerView = GADBannerView.init(frame: adFrame);
        self.bannerView = GADBannerView.init(frame: adFrame);
        self.bannerView!.backgroundColor = UIColor.init(red: 43/255.0, green: 8/255.0, blue: 60/255.0, alpha: 1);
        // bannerView.adUnitID = "ca-app-pub-5267718216518748/5568296429";
        // Test unitID
        self.bannerView!.adUnitID = "ca-app-pub-3940256099942544/2934735716";
        let gadRequest = GADRequest();
        gadRequest.testDevices = [kGADSimulatorID];
        self.bannerView!.rootViewController = self;
        self.bannerView!.load(gadRequest);
        self.view.addSubview(self.bannerView!);
    }
    */
    
}

// Axillary
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

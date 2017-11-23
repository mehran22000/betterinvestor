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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
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
        self.addAdMob();
        self.addPageControl();
        
    }
    
    func addAdMob(){
        // Place AdMob at the bottom of the screen
        let adFrame = CGRect (x: 0, y: self.yAdView!, width: Int(screenWidth!), height: Constants.adViewHeight);
        let bannerView = GADBannerView.init(frame: adFrame);
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
        self.addAdMob();
        self.addPageControl();
        
        
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            self.pageViewHolder.pageAnimation(leftToRight:true);
        }
        else {
            self.pageViewHolder.pageAnimation(leftToRight:false);
        }
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
        return Stub.symbols.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
        let sym = Stub.symbols[indexPath.row];
        let price = Stub.sym_desc[indexPath.row];
        let performance = Stub.sym_performance_precentage[indexPath.row];
        
        cell.symbolLbl?.text = sym;
        cell.performanceBtn?.setTitle(performance, for: UIControlState.normal)
        cell.priceLbl?.text = price;
        
        let ch_plus = CharacterSet(charactersIn: "+")
        if performance.rangeOfCharacter(from: ch_plus) != nil {
            cell.performanceBtn.backgroundColor = UIColor.init(red: 167/255.0, green: 225/255.0, blue: 113/255.0, alpha: 1);
        }
        else {
            cell.performanceBtn.backgroundColor = UIColor.init(red: 255/255.0, green: 163/255.0, blue: 164/255.0, alpha: 1);
        }
        
        if (sym == "TOTAL"){
            cell.backgroundColor = UIColor.init(red: 235/255.0, green: 246/255.0, blue: 255/255.0, alpha: 1);
        }
        return cell;
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

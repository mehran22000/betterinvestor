//
//  ViewController.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-10-19.
//  Copyright © 2017 Ron. All rights reserved.
//

import UIKit
import GoogleMobileAds


class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var viewBanner:GADBannerView?
    @IBOutlet var portfolioTableView: UITableView!
    @IBOutlet var pageViewHolder: UIView!
    @IBOutlet var pageControl: UIPageControl!
    
    let symbols = ["TOTAL",
                   "MSFT",
                   "INTC",
                   "APPLE",
                   "BP",
                   "VRX"];
    
    let sym_desc = ["CASH: $12,012 STOCKS: $6,432",
                    "50 x $70.21 (\u{2191} $0.12)",
                    "100 x $41.00 (\u{2193} $1.12)",
                    "10 x $172.76 (\u{2193} $3.12)",
                    "200 x $40.41 (\u{2191} $0.50)",
                    "500 x $15.78 (\u{2193} $0.25)"];
    
    let sym_performance_dollars = ["+ 1200",
                                   "- 432",
                                   "- 1234",
                                   "+ 600",
                                   "+ 10",
                                   "+ 144"];
    
    let sym_performance_precentage = ["+ 10%",
                                   "- 5%",
                                   "- 16%",
                                   "+ 8%",
                                   "+ 4%",
                                   "+ 22%"];
    var rankingViewIndex = 0;
    var freindsRankingVC : FriendsRankingTableVC?
    var globalRankingVC : GlobalRankingTableVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        self.viewBanner?.adUnitID = "ca-app-pub-5267718216518748/5568296429";
        // self.viewBanner?.rootViewController?.delete(self);
        let gadRequest = GADRequest();
        gadRequest.testDevices = [kGADSimulatorID];
        self.viewBanner?.load(gadRequest);
        
        // Initiate Ranking View Controllers
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.freindsRankingVC = storyboard.instantiateViewController(withIdentifier: "FriendsRankingVC") as? FriendsRankingTableVC
        self.freindsRankingVC?.view.frame = CGRect(x:0,y:0,width:400,height:200);
        self.addChildViewController(self.freindsRankingVC!);
        
        
        self.globalRankingVC = storyboard.instantiateViewController(withIdentifier: "GlobalRankingVC") as? GlobalRankingTableVC
        self.globalRankingVC?.view.frame = CGRect(x:0,y:0,width:400,height:200);
        self.addChildViewController(self.globalRankingVC!);
    
        self.pageViewHolder.addSubview((self.freindsRankingVC?.view)!);
        
        
        // Swipe Guesture Recognition
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        portfolioTableView?.tableFooterView = UIView()
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
            rankingViewIndex = rankingViewIndex + 1;
            if (rankingViewIndex == 1) {
                self.pageViewHolder.addSubview((self.globalRankingVC?.view)!);
                self.pageControl.currentPage = 1;
            }
            else if (rankingViewIndex == 2) {
                rankingViewIndex = 0;
                self.pageViewHolder.addSubview((self.freindsRankingVC?.view)!);
               self.pageControl.currentPage = 0;
            }
            self.pageViewHolder.pageAnimation(leftToRight:true);
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
            rankingViewIndex = rankingViewIndex - 1;
            
            if (rankingViewIndex == -1) {
                rankingViewIndex = 1;
                self.pageViewHolder.addSubview((self.globalRankingVC?.view)!);
                self.pageControl.currentPage = 1;
            }
            else if (rankingViewIndex == 0) {
                self.pageViewHolder.addSubview((self.freindsRankingVC?.view)!);
                self.pageControl.currentPage = 0;
            }
            self.pageViewHolder.pageAnimation(leftToRight:false);
            
            
            // self.pageViewHolder.addSubview(instanceFromNib(pageNo:rankingViewIndex));
            // self.pageViewHolder.pageAnimation(leftToRight:false);
        }
    }
    
    
    /*
    func instanceFromNib(pageNo:Int) -> UIView {
        let rankingTableVC = RankingTableVC();
        
        if (pageNo == 3){
            // let vc =  UINib(nibName: "RankingViews", bundle: nil).instantiate(withOwner: rankingTableVC, options: nil)[pageNo] as! UIViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RankingTableVC")
            vc.view.frame = CGRect(x:0,y:0,width:400,height:245);
            self.addChildViewController(vc);
            return vc.view;
        }
        else {
           return UINib(nibName: "RankingViews", bundle: nil).instantiate(withOwner: rankingTableVC, options: nil)[pageNo] as! UIView
        }
    }
    */
    
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
        return symbols.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
        let sym = symbols[indexPath.row];
        let price = sym_desc[indexPath.row];
        let performance = sym_performance_precentage[indexPath.row];
        
        cell.symbolLbl?.text = sym;
        cell.performanceBtn?.setTitle(performance, for: UIControlState.normal)
        cell.priceLbl?.text = price;
        
        let ch_plus = CharacterSet(charactersIn: "+")
        if performance.rangeOfCharacter(from: ch_plus) != nil {
            cell.performanceBtn.backgroundColor = UIColor.init(red: 7/255.0, green: 84/255.0, blue: 56/255.0, alpha: 1);
        }
        else {
            cell.performanceBtn.backgroundColor = UIColor.init(red: 214/255.0, green: 36/255.0, blue: 39/255.0, alpha: 1);
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

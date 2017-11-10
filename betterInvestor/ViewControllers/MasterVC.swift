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
    
    let stocks = ["AMZN","MSFT","INTC","APPLE","BP","VRX"];
    var rankingViewIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        self.viewBanner?.adUnitID = "ca-app-pub-5267718216518748/5568296429";
        // self.viewBanner?.rootViewController?.delete(self);
        let gadRequest = GADRequest();
        gadRequest.testDevices = [kGADSimulatorID];
        self.viewBanner?.load(gadRequest);
        
        
        // Page View
        self.pageViewHolder.addSubview(instanceFromNib(pageNo:rankingViewIndex));
        
        
        // Swipe Guesture Recognition
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
            rankingViewIndex = rankingViewIndex + 1;
            if (rankingViewIndex == 4) {
                rankingViewIndex = 0;
            }
            
            self.pageViewHolder.addSubview(instanceFromNib(pageNo:rankingViewIndex));
            self.pageViewHolder.pageAnimation(leftToRight:true);
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
            rankingViewIndex = rankingViewIndex - 1;
            if (rankingViewIndex == -1) {
                rankingViewIndex = 3;
            }
            
            self.pageViewHolder.addSubview(instanceFromNib(pageNo:rankingViewIndex));
            self.pageViewHolder.pageAnimation(leftToRight:false);
        }
    }
    
    
    
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
        return stocks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioCell", for: indexPath) as! PortfolioCell;
        cell.symbolLbl?.text = stocks[indexPath.row];
        cell.performanceBtn?.titleLabel?.text = "%10";
        return cell;
        
    }
    
    @IBAction func sayHelloClicked(){
        print("sayHelloClicked");
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

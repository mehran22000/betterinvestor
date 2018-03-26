//
//  HoldersVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-03-14.
//  Copyright © 2018 Ron. All rights reserved.
//


import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class HoldersVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var symbol: String?;
    var holders = NSMutableArray();
    
    enum ScreenMode {
        case Friends
        case All
    }
    
    
    @IBOutlet var table: UITableView?
    @IBOutlet var segmentControl: UISegmentedControl?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var screenMode: ScreenMode = ScreenMode.Friends
    
    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }
    
    var performance_btn_mode = Gain_Mode.gain;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.tableFooterView = UIView()
        table?.tableHeaderView?.isHidden = true;
        
        self.holders = NSMutableArray.init();
        
        self.screenMode = ScreenMode.All;
        self.fetchHolders {
            self.table?.reloadData();
        }
        
        self.title = self.symbol!.uppercased() + " Holders";
        self.segmentControl?.frame =  CGRect(x: (self.segmentControl?.frame.origin.x)!,
                                             y: (self.segmentControl?.frame.origin.y)!,
                                             width: (self.segmentControl?.frame.size.width)!, height: 20);
        
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        if (self.screenMode == ScreenMode.Friends){
            selected_user_rank = self.appDelegate.user?.friend_ranking![indexPath.row] as? Ranking;
        }
        else {
            selected_user_rank = self.appDelegate.user?.global_ranking![indexPath.row] as? Ranking;
        }
        
        performSegue(withIdentifier: "segueFriendPortfolio", sender: nil);
        */
        return;
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.holders.count);
        
        /*
        if ((self.screenMode == ScreenMode.Friends) && (self.appDelegate.user?.friend_ranking != nil)) {
            return (self.appDelegate.user?.friend_ranking?.count)!;
        }
        else if ((self.screenMode == ScreenMode.All) && (self.appDelegate.user?.global_ranking != nil)) {
            return (self.appDelegate.user?.global_ranking?.count)!;
        }
        else {
            return 0;
        }
        */
    }
    
    
    
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let hView = UIView();
     hView.backgroundColor = UIColor.init(red: 113/255.0, green: 81/255.0, blue: 120/255.0, alpha: 1);
     hView.frame = CGRect(x: 0, y: 0, width: (table?.frame.size.width)!, height: 44);
     addSegmentControl(parentView: hView);
     return hView;
     }
     */
    
    
    func addSegmentControl(parentView: UIView) {
        
        let items = ["Friends", "All"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let tblWidth = (table?.frame.size.width)!;
        customSC.frame = CGRect(x: tblWidth/2 - tblWidth/4, y: 10, width: tblWidth/2, height: 20);
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.init(red: 113/255.0, green: 81/255.0, blue: 120/255.0, alpha: 1);
        customSC.tintColor = UIColor.white
        
        // Add target action method
        // customSC.addTarget(self, action: #selector(RankingTableVC.segmentedValueChanged(_:)), for: .valueChanged)
        
        
        // Add this custom Segmented Control to our view
        parentView.addSubview(customSC)
    }
    
    
    @IBAction func switchMode(_ sender: AnyObject) {
        if (self.segmentControl?.selectedSegmentIndex == 0) {
            self.screenMode = ScreenMode.All
        }
        else {
            self.screenMode = ScreenMode.Friends
        }
        self.fetchHolders {
            self.table?.reloadData();
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var gain_str = "-";
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "holderCell", for: indexPath) as! HolderCell;
        
        /*
        let user: Ranking;
        if (self.screenMode == ScreenMode.Friends){
            user = self.appDelegate.user?.friend_ranking![indexPath.row] as! Ranking;
        }
        else {
            user = self.appDelegate.user?.global_ranking![indexPath.row] as! Ranking;
        }
        */
        
         // cell.rank.text = String(indexPath.row);
        let h = self.holders[indexPath.row] as! Holder;
        cell.username.text = h.first_name! + " " + h.last_name!;
        
        if (performance_btn_mode == Gain_Mode.gain_precentage){
            gain_str = String(format:"%.0f",(h.pos?.gain_precentage)!) + "%";
        }
        else {
            gain_str = String(format:"%.2f",(h.pos?.gain)!);
        }
        
        
        if (h.pos!.gain >= 0) {
            gain_str = "+" + gain_str;
            cell.performanceBtn.backgroundColor = UIColor.init(red: 167/255.0, green: 225/255.0, blue: 113/255.0, alpha: 1);
        }
        else {
            cell.performanceBtn.backgroundColor = UIColor.init(red: 255/255.0, green: 163/255.0, blue: 164/255.0, alpha: 1);
        }
        cell.performanceBtn?.setTitle(gain_str, for: UIControlState.normal)
        cell.position.text = "Positions:" + String(describing: h.pos!.qty);
        cell.globalRank.text = "Global Rank:" + String(describing: h.global_ranking!);
        
        
        if let url = URL(string: h.picUrl!) {
            cell.photo?.contentMode = .scaleAspectFit
            cell.photo?.layer.cornerRadius = 10.0
            cell.photo?.clipsToBounds = true
            downloadImage(url: url,imageView: cell.photo!, holder: h)
        }
       
        return cell;
    }
    
    /*
    func fetchFriendsRanking() {
        
        self.table?.reloadData();
        if (self.appDelegate.user?.friend_ranking == nil) {
            self.appDelegate.user?.fetchRanking(global: false, count: 100, completion: {
                self.table?.reloadData();
            })
        }
    }
    */
    

    func fetchHolders(completion:@escaping () -> Void) {
        
        var url: String;
        if (self.screenMode == ScreenMode.All) {
            url = Constants.bsae_url + "holders/stock/" + self.symbol! + "/global/true/userid/" + (self.appDelegate.user?.id)!;
        }
        else {
            url = Constants.bsae_url + "holders/stock/" + self.symbol! + "/global/false/userid/" + (self.appDelegate.user?.id)!;
        }
        
        Alamofire.request(url, method: HTTPMethod.get, encoding:JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let jsonDic = result as! NSDictionary
                if (jsonDic["status"] as! String == "200") {
                    self.holders = NSMutableArray();
                    ResponseParser.parseStockHolders(json: jsonDic, holders: self.holders);
                    completion();
                }
            }
        }
    }
    
    
    /*
    func fetchGlobalRanking() {
        
        self.table?.reloadData();
        if (self.appDelegate.user?.global_ranking == nil) {
            self.appDelegate.user?.fetchRanking(global: true, count: 100, completion: {
                self.table?.reloadData();
            })
        }
    }
    */
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView:UIImageView, holder: Holder) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                holder.photo = UIImage(data: data);
                imageView.image = holder.photo
            }
        }
    }
}


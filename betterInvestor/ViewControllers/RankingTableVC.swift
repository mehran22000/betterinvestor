//
//  RankingTableVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-08.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit

class RankingTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var selected_user_rank: Ranking?;
    
    
    enum ScreenMode {
        case Friends
        case All
    }

    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }
    
    
    var performance_btn_mode = Gain_Mode.gain;
    
    
    
    @IBOutlet var table: UITableView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var screenMode: ScreenMode = ScreenMode.Friends
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.tableFooterView = UIView()
        table?.tableHeaderView?.isHidden = true;
        
        if ((self.appDelegate.user) != nil) {
            self.fetchFriendsRanking();
        }
        
    }
        
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.screenMode == ScreenMode.Friends){
            selected_user_rank = self.appDelegate.user?.friend_ranking![indexPath.row] as? Ranking;
        }
        else {
            selected_user_rank = self.appDelegate.user?.global_ranking![indexPath.row] as? Ranking;
        }
        
        performSegue(withIdentifier: "segueFriendPortfolio", sender: nil);
        
        return;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        self.title = ""
        
        if(segue.identifier == "segueFriendPortfolio") {
            
            let friendPortfolioVC = (segue.destination as! FriendPortfolioVC);

            friendPortfolioVC.user = User.init(_id: (self.selected_user_rank?.user_id)!,
                                               _first_name: (self.selected_user_rank?.first_name)!,
                                               _last_name: (self.selected_user_rank?.last_name)!,
                                               _middle_name: "",
                                               _name: "",
                                               _email: "",
                                               _pictureUrl: (self.selected_user_rank?.photo_url)!,
                                               _friends: nil,
                                               _cash: 0,
                                               _pic: (self.selected_user_rank?.photo));
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((self.screenMode == ScreenMode.Friends) && (self.appDelegate.user?.friend_ranking != nil)) {
            return (self.appDelegate.user?.friend_ranking?.count)!;
        }
        else if ((self.screenMode == ScreenMode.All) && (self.appDelegate.user?.global_ranking != nil)) {
            return (self.appDelegate.user?.global_ranking?.count)!;
        }
        else {
            return 0;
        }
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
    
   

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell;
        
        let user: Ranking;
        if (self.screenMode == ScreenMode.Friends){
            user = self.appDelegate.user?.friend_ranking![indexPath.row] as! Ranking;
        }
        else {
            user = self.appDelegate.user?.global_ranking![indexPath.row] as! Ranking;
        }
        // cell.rank.text = String(indexPath.row);
        cell.username.text = String(describing: indexPath.row+1) + ". " + user.first_name! + " " + user.last_name!;
        
        var title: String;
        if (performance_btn_mode == Gain_Mode.gain_precentage){
            title = user.gain_pct! + "%";
        }
        else {
            title = "$" + user.gain!;
        }
        
        
        
        
        // cell.performanceBtn.setTitle(user.gain_pct! + "%", for: UIControlState.normal)
        
        cell.performanceBtn.setTitle(title, for: UIControlState.normal)
        
        
        if let url = URL(string: user.photo_url!) {
            cell.photo?.contentMode = .scaleAspectFit
            cell.photo?.layer.cornerRadius = 10.0
            cell.photo?.clipsToBounds = true
            downloadImage(url: url,imageView: cell.photo!, user_rank: user)
        }
        return cell;
    }

    func fetchFriendsRanking() {
        
        self.table?.reloadData();
        if (self.appDelegate.user?.friend_ranking == nil) {
            self.appDelegate.user?.fetchRanking(global: false, count: 100, completion: {
                self.table?.reloadData();
            })
        }
    }
    
    
    func fetchGlobalRanking() {
        
        self.table?.reloadData();
        if (self.appDelegate.user?.global_ranking == nil) {
            self.appDelegate.user?.fetchRanking(global: true, count: 100, completion: {
                self.table?.reloadData();
            })
        }
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView:UIImageView, user_rank: Ranking) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                user_rank.photo = UIImage(data: data);
                imageView.image = user_rank.photo
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
        self.table?.reloadData()
    }
    
    
}

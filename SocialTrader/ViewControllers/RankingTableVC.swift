//
//  RankingTableVC.swift
//  betterInvestor
//
//  Created by mehran najafi on 2017-11-08.
//  Copyright © 2017 Ron. All rights reserved.
//

import Foundation
import UIKit
import Amplify
import AWSMobileClient
import AmplifyPlugins


class RankingTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var selected_user_rank: Ranking?;
    var aws_valid_keys =  Dictionary<String,Bool>();
    
    enum ScreenMode {
        case Friends
        case All
    }

    enum Gain_Mode: String {
        case gain = "Gain"
        case gain_precentage = "Gain_Precentage"
    }
    
    var performance_btn_mode = Gain_Mode.gain;
    @IBOutlet weak var table: UITableView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var screenMode: ScreenMode = ScreenMode.Friends
    
    // View Delegates - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.tableFooterView = UIView()
        table?.tableHeaderView?.isHidden = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    // View Delegates - End
    
    // Tableview Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (self.screenMode == ScreenMode.Friends){
            if (indexPath.row == self.appDelegate.user?.friend_ranking.count) {
                performSegue(withIdentifier: "segueReferFriend", sender: nil);
            }
            else {
                selected_user_rank = self.appDelegate.user?.friend_ranking[indexPath.row] as? Ranking;
                performSegue(withIdentifier: "segueFriendPortfolio", sender: nil);
            }
        }
        else {
            selected_user_rank = self.appDelegate.user?.global_ranking[indexPath.row] as? Ranking;
            performSegue(withIdentifier: "segueFriendPortfolio", sender: nil);
        }
        
        
        return;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((self.screenMode == ScreenMode.Friends) && (self.appDelegate.user?.friend_ranking != nil)) {
            return (self.appDelegate.user?.friend_ranking.count)! + 1;
        }
        else if ((self.screenMode == ScreenMode.All) && (self.appDelegate.user?.global_ranking != nil)) {
            return (self.appDelegate.user?.global_ranking.count)!;
        }
        else {
            return 0;
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((self.screenMode == ScreenMode.Friends) && (indexPath.row == self.appDelegate.user?.friend_ranking.count)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteFriendCell", for: indexPath);
            cell.selectionStyle = UITableViewCellSelectionStyle.none;
            return cell;
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as! RankingCell;
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
        let rank: Ranking!;
        if (self.screenMode == ScreenMode.Friends){
            rank = self.appDelegate.user?.friend_ranking[indexPath.row] as! Ranking;
        }
        else {
            rank = self.appDelegate.user?.global_ranking[indexPath.row] as! Ranking;
        }
        cell.username.text = String(describing: indexPath.row+1) + ". " + rank.first_name! + " " + rank.last_name!;
        
        var title: String;
        if (performance_btn_mode == Gain_Mode.gain_precentage){
            title = rank.gain_pct! + "%";
        }
        else {
            title = "$" + rank.gain!;
        }
        
        cell.performanceBtn.setTitle(title, for: UIControlState.normal)
        if let url = URL(string: rank.photo_url!) {
            cell.photo?.contentMode = .scaleAspectFit
            cell.photo?.layer.cornerRadius = 10.0
            cell.photo?.clipsToBounds = true
            downloadImage(user_id: rank.user_id,imageView: cell.photo!, user_rank: rank)
        }
        else {
            cell.photo.image = nil;
        }
        return cell;
    }
    // Tableview Delegates End
    
    
    // Navigations Delegates - Start
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
                                               _realized: 0,
                                               _pic: (self.selected_user_rank?.photo));
        }
        else if(segue.identifier == "segueReferFriend") {
            let referVC = segue.destination as! ReferVC;
            referVC.isModal = false;
        }
    }
    // Navigations Delegates - End
    
    // User Interaction - Start
    @IBAction func performanceBtnClicked () {
        if (self.performance_btn_mode == Gain_Mode.gain) {
            self.performance_btn_mode = Gain_Mode.gain_precentage;
        }
        else {
            self.performance_btn_mode = Gain_Mode.gain;
        }
        self.table?.reloadData()
    }
    // User Interaction - End
    
    // Data Request - Start
    func fetchFriendsRanking() {
        self.appDelegate.user?.requestRanking(global: false, count: 100, completion: {
            self.table?.reloadData();
        })
    }
    
    func fetchGlobalRanking() {
        self.appDelegate.user?.requestRanking(global: true, count: 100, completion: {
                self.table?.reloadData();
        })
    }
    // Data Reques - End
    
    
    // Axillary
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    func downloadImage(user_id: String, imageView:UIImageView, user_rank: Ranking) {
        /*
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                user_rank.photo = UIImage(data: data);
                imageView.image = user_rank.photo
            }
        })
         */
        let key = user_id + ".jpg";
        if (self.aws_valid_keys[key] != nil) {
            Amplify.Storage.downloadData(key: key) { event in
                   switch event {
                   case let .completed(data):
                       print("Completed: \(data)")
                       DispatchQueue.main.async() {
                            user_rank.photo = UIImage(data: data);
                            imageView.image = user_rank.photo
                        }
                   case let .failed(storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                        DispatchQueue.main.async() {
                            user_rank.photo = UIImage(named: "no_photo");
                            imageView.image = UIImage(named: "no_photo");
                            
                        }
                   case let .inProcess(progress):
                       print("Progress: \(progress)")
                   default:
                       break
                   }
               }
        }
        else {
            DispatchQueue.main.async() {
                user_rank.photo = UIImage(named: "no_photo");
                imageView.image = UIImage(named: "no_photo");
                
            }
        }
        
    }
    
    
    
    
}

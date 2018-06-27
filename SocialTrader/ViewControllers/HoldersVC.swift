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
    
    var symbol = "";
    var h : Holders!
    
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
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        table?.tableFooterView = UIView()
        table?.tableHeaderView?.isHidden = true;
    
        self.screenMode = ScreenMode.All;
    
        self.title = self.symbol.uppercased() + " Holders";
        /*
        self.segmentControl?.frame =  CGRect(x: (self.segmentControl?.frame.origin.x)!,
                                             y: (self.segmentControl?.frame.origin.y)!,
                                             width: (self.segmentControl?.frame.size.width)!, height: 20);
        */
    
        let user_id = self.appDelegate.user?.id;
        self.h = Holders.init(symbol: self.symbol);
        h.requestHolders(justFriends: false, user_id:user_id) {
             self.table?.reloadData();
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Tableview
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.h != nil) {
            if (self.h?.holders != nil) {
                return self.h!.holders.count;
            }
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var gain_str = "-";
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "holderCell", for: indexPath) as! HolderCell;
        
        // cell.rank.text = String(indexPath.row);
        let h = self.h!.holders[indexPath.row] as! Holder;
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
        cell.position.text = "Positions:" + String(describing: h.pos.qty!);
        cell.globalRank.text = "Global Rank:" + String(describing: h.global_ranking!);
        
        
        if let url = URL(string: h.picUrl!) {
            cell.photo?.contentMode = .scaleAspectFit
            cell.photo?.layer.cornerRadius = 10.0
            cell.photo?.clipsToBounds = true
            downloadImage(url: url,imageView: cell.photo!, holder: h)
        }
        
        return cell;
    }
    
    
    // MARK: User Interaction
    @IBAction func performanceBtnClicked () {
        if (self.performance_btn_mode == Gain_Mode.gain) {
            self.performance_btn_mode = Gain_Mode.gain_precentage;
        }
        else {
            self.performance_btn_mode = Gain_Mode.gain;
        }
        self.table?.reloadData();
    }
    
    @IBAction func switchMode(_ sender: AnyObject) {
        self.h = Holders.init(symbol: self.symbol);
        let user_id = self.appDelegate.user?.id;
        if (self.segmentControl?.selectedSegmentIndex == 0) {
            self.screenMode = ScreenMode.All
            self.h?.requestHolders(justFriends: false, user_id: user_id , completion: {
                self.table?.reloadData()
            })
        }
        else {
            self.screenMode = ScreenMode.Friends
            self.h?.requestHolders(justFriends: true, user_id: user_id , completion:  {
                self.table?.reloadData()
            })
            
        }
    }
    

    
// Auxilary Functions
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


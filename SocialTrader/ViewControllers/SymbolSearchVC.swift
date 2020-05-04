//
//  SymbolSearchVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-26.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit
import GoogleMobileAds


class SymbolSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate  {

    @IBOutlet var tableView: UITableView!
    var symbols = NSArray();
    var filteredSymbols = NSMutableArray();
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let myActivityIndicator = UIActivityIndicatorView();
    var selectedSymbol: Symbol?;
    let searchController = UISearchController(searchResultsController: nil)
    var first_time_user: Bool?;
    
    // MARK: View Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        self.symbols = UserDefaults.standard.value(forKey: "symbols") as! NSArray;
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.showsCancelButton = true;
        searchController.searchBar.barStyle = .blackOpaque
        searchController.searchBar.barTintColor = UIColor.init(red: 111/255.0, green: 82/255.0, blue: 121/255.0, alpha: 1);
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.addAdMob()
        
        if (self.first_time_user == true) {
                   searchController.searchBar.text = "Apple";
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    // MARK: Tableview Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredSymbols.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        let _symbol = self.filteredSymbols[indexPath.row] as? NSDictionary;
        
        cell.textLabel?.text = _symbol?.object(forKey: "Symbol") as? String;
        cell.textLabel?.textColor = UIColor.white;
        cell.detailTextLabel?.text = _symbol?.object(forKey: "Name") as? String;
        cell.detailTextLabel?.textColor = UIColor.white;
        cell.backgroundColor = UIColor.init(red: 111/255.0, green: 82/255.0, blue: 121/255.0, alpha: 1);
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let _selectedSymbol = filteredSymbols[indexPath.row] as! NSDictionary;
        let sym = _selectedSymbol.object(forKey: "Symbol") as? String;
        let name = _selectedSymbol.object(forKey: "Name") as? String;
        
        self.selectedSymbol = Symbol(key: sym!, name: name!);
        self.displayActivityIndicator();
        self.appDelegate.market.fetchStockPrice(symbol: sym!) { (success) in
            self.hideActivityIndicator();
            if (success == true){
                self.performSegue(withIdentifier: "segueStockInfo", sender: nil)
            }
            else {
                let alertController = UIAlertController(title: "Connection Error", message: "Please try again", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if(segue.identifier == "segueStockInfo") {
            let stockVC = (segue.destination as! StockVC);
            stockVC.symbol = self.selectedSymbol;
        }
    }
    
    // MARK: User Interaction
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       self.navigationController?.popViewController(animated: true)
       self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredSymbols = NSMutableArray.init(array: self.symbols)
        } else {
            filteredSymbols = NSMutableArray();
            for symbol in self.symbols {
                let name = ((symbol as! NSDictionary).value(forKey: "Name") as! String).lowercased();
                let sym = ((symbol as! NSDictionary).value(forKey: "Symbol") as! String).lowercased();
                
                if (sym.contains(searchController.searchBar.text!.lowercased()) || name.contains(searchController.searchBar.text!.lowercased())) {
                    filteredSymbols.add(symbol);
                }
            }
        
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Axillary
    func displayActivityIndicator(){
        self.myActivityIndicator.center = view.center
        self.myActivityIndicator.hidesWhenStopped = true;
        self.myActivityIndicator.startAnimating()
        self.myActivityIndicator.activityIndicatorViewStyle = .whiteLarge;
        self.view.addSubview(myActivityIndicator)
    }
    
    func hideActivityIndicator(){
        self.myActivityIndicator.stopAnimating();
    }
    
    func addAdMob(){
        // Place AdMob at the bottom of the screen
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let yAdView = Int(screenHeight) - Constants.adViewHeight;
        let adFrame = CGRect (x: 0, y: yAdView, width: Int(screenWidth), height: Constants.adViewHeight);
        let bannerView = GADBannerView.init(frame: adFrame);
        bannerView.backgroundColor = UIColor.init(red: 43/255.0, green: 8/255.0, blue: 60/255.0, alpha: 1);
        bannerView.adUnitID = Constants.admob_id;
        let gadRequest = GADRequest();
        gadRequest.testDevices = [kGADSimulatorID];
        bannerView.rootViewController = self;
        bannerView.load(gadRequest);
        self.view.addSubview(bannerView);
    }
    
    
}

//
//  SymbolSearchVC.swift
//  betterInvestor
//
//  Created by mehran  on 2018-01-26.
//  Copyright © 2018 Ron. All rights reserved.
//

import UIKit

class SymbolSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate  {

    // Portfolio
    @IBOutlet var tableView: UITableView!
    var symbols = NSArray();
    var filteredSymbols = NSMutableArray();
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        
        self.symbols = UserDefaults.standard.value(forKey: "symbols") as! NSArray;
        
        

        
        
       // filteredSymbols = symbols
        
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
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
         // self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.navigationController?.navigationBar.isHidden = false;
    }
    
    
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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let _selectedSymbol = filteredSymbols[indexPath.row] as! NSDictionary;
        let sym = _selectedSymbol.object(forKey: "Symbol") as? String;
        let name = _selectedSymbol.object(forKey: "Name") as? String;
        
        appDelegate.selectedStock = Symbol(key: sym!, name: name!);
        //self.dismiss(animated: false, completion: nil);
        performSegue(withIdentifier: "segueStockInfo", sender: nil)
     
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       self.navigationController?.popViewController(animated: true)
       self.navigationController?.setNavigationBarHidden(false, animated: false)
        // self.dismiss(animated: true, completion: nil);
        
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
    
    
    
}

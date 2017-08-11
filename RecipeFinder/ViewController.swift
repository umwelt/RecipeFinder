//
//  ViewController.swift
//  RecipeFinder
//
//  Created by BMGH SRL on 11/08/2017.
//  Copyright © 2017 BMAGH SRL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
// Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    Properties
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    var recipies = [Recipe]()

    
    
    @IBOutlet var tableView: UITableView! {
        
        didSet {
            
            tableView.bounces = true
            tableView.backgroundColor = UIColor.white
            tableView.alwaysBounceHorizontal = false
            tableView.tableFooterView = UIView()
            
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.delegate = self
            
            tableView.tableHeaderView = searchController.searchBar
            
        }
    }

}


//MARK: Table View Delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // limit results to the las 20 items
        if recipies.count > 20 {
            return 20
        }
        
        return recipies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if let title = self.recipies[indexPath.row].title {
            //          trim() is sanitizing /n and empy spaces
            cell.textLabel?.text = title.trim()
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // dbug
        print(self.recipies[indexPath.row].description)
    }
    
    
}


//MARK: UISearchResultsUpdating delegate
extension ViewController:  UISearchResultsUpdating {
    
    // Called when the search bar's text or scope has changed or when the search bar becomes first responder.
    func updateSearchResults(for searchController: UISearchController) {
        
        let manager = RemoteDataManager()
        
        // Will test for contents | empty query
        if let query = searchController.searchBar.text, !query.isEmpty {
            
            // Will compose | sanitize query to URL
            let url = manager.encodeQueryParameters(with: query)! as URL
            
            manager.loadDataFromURL(url: url, completion: { (data, error) in
                
                //
                guard data != nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                manager.parsingData(recipies: self.recipies, data: data!, completion: { (recipies, error) in
                    
                    guard error == nil else {
                        return
                    }
                    
                    self.recipies = recipies!
                    // Update UI on mainThread
                    DispatchQueue.main.async { () -> Void in
                        self.tableView.reloadData()
                    }
                })
                
            })
        }
    }
    
}

//MARK: Search Bar delegate + utility functions
extension ViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, (text.isEmpty == false) {
        } else {
            resetData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetData()
    }
    
    private func resetData() {
        self.recipies.removeAll()
        self.tableView.reloadData()
    }
    
    
}


















//
//  StockViewController.swift
//  pare
//
//  Created by Ehi Airewele  on 7/27/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import Alamofire

class StockViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var stockView: UICollectionView!
    var stock: Stock?
    var searchController : UISearchController!
    
    var gainersArray: [Stock] = []
    var losersArray: [Stock] = []
    var moversArray: [Stock] = []
    
    
    var timer = Timer()
    
    var result = ""
    
    var timesArray = [String]()
    var valuesArray = [Double]()
    
    
    func countdown() {
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    
    
    func updateTime(symbol: String? = nil) {
        
        let gainers: [String] = getGainerSymbols()!
        let losers: [String] = getLoserSymbols()!
        
        for gainerSymbol in gainers {
            getSymbolInfo(symbol: gainerSymbol) { (Stock) in
                self.gainersArray.append(Stock)
                self.moversArray.append(Stock)
            }
            
        }
        
        for loserSymbol in losers {
            getSymbolInfo(symbol: loserSymbol) { (Stock) in
                self.losersArray.append(Stock)
                self.moversArray.append(Stock)
                
                if self.losersArray.count == losers.count {
                    self.stockView.reloadData()
                }
                
            }
            //only get 9 gainers, losers not 10
        }
    }
    
        func getSymbolInfo(symbol: String? = nil, completion: @escaping (Stock) -> Void) {
            NetworkRequest.instantiateStock(symbol: symbol!) { (Stock) in
                completion(Stock)
            }
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            updateTime()
            configureSearchController()
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            
        }
        
        func configureSearchController() {
            searchController = UISearchController(searchResultsController: nil)
            self.searchController.searchResultsUpdater = self
            self.searchController.dimsBackgroundDuringPresentation = false
            
            searchController.searchBar.placeholder = "Search..."
            self.searchController.delegate = self
            searchController.searchBar.sizeToFit()
            
            self.searchController = UISearchController(searchResultsController:  nil)
            
            self.searchController.searchBar.delegate = self
            
            self.searchController.hidesNavigationBarDuringPresentation = false
            
            self.navigationItem.titleView = searchController.searchBar
            
            self.definesPresentationContext = true
        }
        
        
        
        func getGainerSymbols () -> [String]? {
            let myURLString = "https://docs.google.com/spreadsheets/d/15ta-RCEJkfdAQaajjMKkHtsh49benIAremVKvOMKfGo/pub?gid=1507041037&single=true&output=tsv"
            
            if let myURL = URL(string: myURLString) {
                
                do {
                    let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                    let rows = myHTMLString.components(separatedBy: "\r\n")
                    var symbols : [String] = []
                    for (_, row) in rows.enumerated() {
                        for (j, item) in row.components(separatedBy: "\t").enumerated() {
                            let item = item.components(separatedBy: " ")
                            if j == 0 {
                                symbols.append(String(describing: item))
                            }
                        }
                    }
                    symbols.remove(at: 0)
                    symbols.remove(at: 1)
                    var filteredArray = [String]()
                    for symbol in symbols {
                        let itemString = String(describing: symbol)
                        let itemSeperated = itemString.components(separatedBy: ",")
                        let code = itemSeperated.first
                        let test = code?.replacingOccurrences(of: "[\"", with: " ").replacingOccurrences(of: "\"" , with: " ").trimmingCharacters(in: .whitespaces)
                        filteredArray.append(test!)
                    }
                    return filteredArray
                    
                } catch let error {
                    print("Error: \(error)")
                }
            }
            return nil
        }
        
        func getLoserSymbols () -> [String]? {
            let myURLString = "https://docs.google.com/spreadsheets/d/15ta-RCEJkfdAQaajjMKkHtsh49benIAremVKvOMKfGo/pub?gid=1816177020&single=true&output=tsv"
            
            if let myURL = URL(string: myURLString) {
                
                do {
                    let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                    let rows = myHTMLString.components(separatedBy: "\r\n")
                    var symbols : [String] = []
                    for (_, row) in rows.enumerated() {
                        for (j, item) in row.components(separatedBy: "\t").enumerated() {
                            let item = item.components(separatedBy: " ")
                            if j == 0 {
                                symbols.append(String(describing: item))
                            }
                        }
                    }
                    symbols.remove(at: 0)
                    symbols.remove(at: 1)
                    var filteredArray = [String]()
                    for symbol in symbols {
                        let itemString = String(describing: symbol)
                        let itemSeperated = itemString.components(separatedBy: ",")
                        let code = itemSeperated.first
                        let test = code?.replacingOccurrences(of: "[\"", with: " ").replacingOccurrences(of: "\"" , with: " ").trimmingCharacters(in: .whitespaces)
                        filteredArray.append(test!)
                    }
                    
                    return filteredArray
                    
                } catch let error {
                    print("Error: \(error)")
                }
            }
            return nil
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let identifier = segue.identifier {
                if identifier == "ShowIndividualStock" {
                    let indexPath = stockView.indexPathsForSelectedItems?.first
                    
                    
                    print(indexPath)
                    
                    //                let stock = Stock[indexPath!.item]
                    let individualStockViewController = segue.destination as! IndividualStockViewController
                    individualStockViewController.stock = moversArray[(indexPath?.row)!]
                    //                individualStockViewController.stock = stock
                }
            }
        }
        
    }
    
    
    extension StockViewController: UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return moversArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchlistStockViewCell", for: indexPath) as! StockViewCell
            
            let watchListStock = moversArray[indexPath.item]
            cell.nameLabel.text = "(\(watchListStock.symbol))\(watchListStock.companyName)"
            cell.priceLabel.text = "$\(watchListStock.price)"
            cell.stockLogo.image = watchListStock.logo
            
            //        NetworkRequest.getAverages(symbol: watchListStock.symbol) { (dict: [String : Double]) in
            //            let timesArray = Array(dict.keys)
            //            let valueArray = Array(dict.values)
            //
            //            cell.setChart(dataPoints: timesArray, values: valueArray)
            //
            //        }
            //cell.setChart(dataPoints: timesArray, values: valuesArray)
            // cell.lineChartView.setNeedsDisplay()
            
            return cell
            
        }
        
    }
    
    extension StockViewController: UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            
        }
        
        
        
}

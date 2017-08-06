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
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseAuthUI

typealias FIRUser = FirebaseAuth.User

class StockViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var firstSecondSegmented: UISegmentedControl!
    @IBOutlet weak var stockView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var stock: Stock?
    let positiveGreen = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    let negativeRed = UIColor(red: 250/255.0, green: 92/255.0, blue: 120/255.0, alpha: 1.0)
    
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
        
//        guard let authUI = FUIAuth.defaultAuthUI()
//            else{return}
//        
//        Auth.auth().signInAnonymously() { (user, error) in
//            let isAnonymous = user!.isAnonymous
//            let uid = user!.uid
//            let userDict = ["uid": uid]
//            //            "stock1": "AAPL", "stock2": "MSFT", "stock3": "TSLA"
//            let ref = Database.database().reference().child("users").child((user?.uid)!)
//            ref.updateChildValues(userDict)
//        }
        
        let gainers: [String] = getGainerSymbols()!
        let losers: [String] = getLoserSymbols()!
        DispatchQueue.global(qos: .userInitiated).async {
            for gainerSymbol in gainers {
                
                self.getSymbolInfo(symbol: gainerSymbol) { (Stock) in
                    self.gainersArray.append(Stock)
                    self.moversArray.append(Stock)
                }
            }
            
            for loserSymbol in losers {
                self.getSymbolInfo(symbol: loserSymbol) { (Stock) in
                    self.losersArray.append(Stock)
                    self.moversArray.append(Stock)
                    DispatchQueue.main.async {
                        if self.losersArray.count == losers.count {
                            self.stockView.reloadData()
                            self.spinner.stopAnimating()
                        }
                    }
                }
                //only get 9 gainers, losers not 10
            }
            
        }
    }
    func getSymbolInfo(symbol: String? = nil, completion: @escaping (Stock) -> Void) {
        NetworkRequest.instantiateStock(symbol: symbol!) { (Stock) in
            completion(Stock!)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        
        updateTime()
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
                //
                //                Auth.auth().signInAnonymously() { (user, error) in
                //                    let isAnonymous = user!.isAnonymous
                //                    let uid = user!.uid
                //                    let userDict = ["uid": uid,
                //                                    "stock1": "AAPL", "stock2": "MSFT", "stock3": "TSLA"]
                //                    let ref = Database.database().reference().child("users").child((user?.uid)!)
                //                    ref.updateChildValues(userDict)
                //                }
                
                
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
        cell.nameLabel.text = watchListStock.companyName
        if (watchListStock.isPositive) {
            cell.priceLabel.text = "$\(watchListStock.price) (\(watchListStock.changePercent)%)"
            cell.priceLabel.textColor = positiveGreen
        } else {
            cell.priceLabel.textColor = negativeRed
        }
        cell.logoImage.image = watchListStock.logo
        cell.symbolLabel.text = watchListStock.symbol
        
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
extension StockViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
        guard let user = user
            else {return}
        
//        let startingStocks = ["AAPL", "MSFT", "TSLA"]
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot) {
                print("Welcome back")
            } else {
                guard let firUser = Auth.auth().currentUser else {return}
                UserService.create(firUser, completion: { (user) in
                    guard let user = user else {return}
                    
                    print("You're already following: AAPL, MSFT and TSLA!")
                })
                
            }
        })
        
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                User.setCurrent(user)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        }
        
    }
}
   







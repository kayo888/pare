//
//  DiscoverViewController.swift
//  pare
//
//  Created by Ehi Airewele  on 7/28/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
//hi abid, how are you doin'.
// who are you
//oh
//im you. in the future, abid of christmas future
// why are you here
//to stop you from making a terrible mistake

class DiscoverViewController: UIViewController {
    let currentUser = Auth.auth().currentUser!
    
    @IBOutlet weak var discoverView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    var newsArray = [NewsItem]()
    var basedOnArray = [Stock]()
    var basedOnArray2 = [Stock]()
    var topRecArray = [Stock]()
    var following = ["AAPL", "MSFT", "TSLA", "AMZN"]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getNews () -> Void {
        NetworkRequest.getMarketNews(completion: { (newsItems) in
            self.newsArray = newsItems
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowNews" {
                let indexPath = discoverView.indexPathForSelectedRow?.first
                
                let news = newsArray[indexPath!]
                let newsViewController = segue.destination as! NewsViewController
                newsViewController.url = news.url
            } else if identifier == "ShowStockRec" {
                let indexPath = discoverView.indexPathForSelectedRow
                
                let individualStockViewController = segue.destination as! IndividualViewController
                let stock = topRecArray[(indexPath?.row)!]
                individualStockViewController.stock = stock
//                NetworkRequest.instantiateStock(symbol: symbol, completion: { (Stock) in
//                    individualStockViewController.stock = Stock
//                })
            } else if identifier == "ShowStockBased" {
                let indexPath = discoverView.indexPathForSelectedRow
                
                let individualStockViewController = segue.destination as! IndividualViewController
                let stock = basedOnArray[(indexPath?.row)!]
                individualStockViewController.stock = stock
//                NetworkRequest.instantiateStock(symbol: symbol, completion: { (Stock) in
//                    individualStockViewController.stock = Stock
//                })
            } else {
                let indexPath = discoverView.indexPathForSelectedRow
                
                let individualStockViewController = segue.destination as! IndividualViewController
                let stock = basedOnArray2[(indexPath?.row)!]
                individualStockViewController.stock = stock
//                NetworkRequest.instantiateStock(symbol: symbol, completion: { (Stock) in
//                    individualStockViewController.stock = Stock
//                })
            }
        }
    }
}
extension DiscoverViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 2
        default:
            fatalError("Error: unexpected section.")
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTVCell", for: indexPath) as! NewsTVCell
            
            cell.controller = self
            cell.newsArray = newsArray
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecTVCell", for: indexPath) as! RecTVCell
            
            cell.controller = self
            cell.topRecArray = topRecArray
            cell.following = following
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasedOnTVCell", for: indexPath) as! BasedOnTVCell
            cell.basedOnArray = basedOnArray
            cell.following = following
            let random = Int(arc4random_uniform(UInt32(following.count)))
            cell.random = random
            
            cell.controller = self
            cell.titleLabel.text = "Because you follow \(following[random])"
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasedOnTwoTVCell", for: indexPath) as! BasedOnTwoTVCell
            cell.basedOnArray = basedOnArray2
            cell.following = following
            let random = Int(arc4random_uniform(UInt32(following.count)))
            cell.random = random
            
            cell.controller = self
            cell.titleLabel.text = "Because you follow \(following[random])"
            
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectorsTVCell", for: indexPath) as! SectorsTVCell
            cell.controller = self
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
        
        
    }
}












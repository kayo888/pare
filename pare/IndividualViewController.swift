//
//  IndividualStockViewController.swift
//
//
//  Created by Ehi Airewele  on 7/17/17.
//
//
// THIS IS ERIC'S PROJECT

import UIKit
import Charts

/*
 let profitMargin: Double
 
 let description: String
 let website: String
 let CEO: String
 */
class IndividualViewController: UIViewController {
    var symbol: String?
    var stock: Stock?
    
    @IBOutlet weak var individualStockView: UITableView!
    
    let positiveGreen = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    let negativeRed = UIColor(red: 250/255.0, green: 92/255.0, blue: 120/255.0, alpha: 1.0)
    
    var yVals1: [ChartDataEntry] = []
    var months = [String]()
    var values = [Double]()
    var stats = [Double]()
    var info = [String]()
    var about = ""
    var newsArray = [NewsItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NetworkRequest.instantiateStock(symbol: (symbol)!, completion: { (input) in
//            self.stock = input
            if let stock = stock {

                NetworkRequest.getNews(symbol: (stock.symbol)) { (newsItems: [NewsItem]) in
                    
                    self.newsArray = newsItems
                    
                    DispatchQueue.main.async {
                        self.individualStockView.reloadData()
                    }
                    
                }
                NetworkRequest.allCompany(symbol: (stock.symbol), completion: { (description, site, ceo) in
                    self.about = description
                })
            }
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowNews" {
                
                let indexPath = individualStockView.indexPathForSelectedRow?.first
                
                let news = newsArray[indexPath!]
                let newsViewController = segue.destination as! NewsViewController
                newsViewController.url = news.url
            }
        }
    }
}

extension IndividualViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 2
        case 5:
            return 1
        default:
            fatalError("Error: unexpected section.")
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockAttributesCell", for: indexPath) as! StockAttributesCell
            
            cell.nameLabel.text = stock!.companyName
            cell.priceLabel.text = "$\(String(describing: stock!.price)) (\(String(describing: stock?.changePercent))%)"
            
            if (stock!.isPositive) {
                cell.priceLabel.textColor = positiveGreen
            } else {
                cell.priceLabel.textColor = negativeRed
            }
            cell.logo.image = stock!.logo
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitle("Following", for: .selected)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraphViewCell", for: indexPath) as! GraphViewCell
            let dispathgroup = DispatchGroup()
            dispathgroup.enter()
            
            cell.stock = stock
            NetworkRequest.getMonthAverages(symbol: (stock!.symbol)) { (values: [Double]) in
                let months: [String] = ["January", "April", "August", "December"]
                
                cell.setChart(dataPoints: months, values: values)
            
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
            cell.stock = stock
            cell.newsArray = newsArray
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsViewCell", for: indexPath) as! StatsViewCell
            cell.stock = stock
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoViewCell", for: indexPath) as! InfoViewCell
            cell.stock = stock
            
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutViewCell", for: indexPath) as! AboutViewCell
            
            cell.aboutLabel.text = "ABOUT"
            cell.descriptionLabel.text = about
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
}
extension IndividualViewController: UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNews", sender: self)
    }
    
    
}











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

class IndividualViewController: UIViewController {
    var stock: Stock?
    var newsArray = [NewsItem]()
    
    
    //    protocol IndividualStockViewController: class {
    //        func didTapFollowButton(_ followButton: UIButton)
    //    }
    
    @IBOutlet weak var individualStockView: UITableView!
    
    let positiveGreen = UIColor(red: 62.0/255.0, green: 189.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    let negativeRed = UIColor(red: 250/255.0, green: 92/255.0, blue: 120/255.0, alpha: 1.0)
    
    var yVals1: [ChartDataEntry] = []
    var months = [String]()
    var values = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stock = stock {
            
            NetworkRequest.getNews(symbol: stock.symbol) { (newsItems: [NewsItem]) in
                
                self.newsArray = newsItems
                
                DispatchQueue.main.async {
                    self.individualStockView.reloadData()
                }
            }
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func getNews () -> Void {
        let symbol = stock?.symbol
        if let symbol = symbol {
            NetworkRequest.getNews(symbol: symbol) { (newsItems: [NewsItem]) in
                
                self.newsArray = newsItems
                
            }
        } else {
            print("symbol is nil")
        }
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
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockAttributesCell", for: indexPath) as! StockAttributesCell
            cell.nameLabel.text = stock?.companyName
            cell.priceLabel.text = "\(String(describing: stock?.price)) (\(String(describing: stock?.changePercent))%)"
            if (stock?.isPositive)! {
                cell.priceLabel.textColor = positiveGreen
            } else {
                cell.priceLabel.textColor = negativeRed
            }
            cell.logo.image = stock?.logo
            cell.followButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.followButton.setTitle("Follow", for: .normal)
            cell.followButton.setTitle("Following", for: .selected)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraphViewCell", for: indexPath) as! GraphViewCell
            let dispathgroup = DispatchGroup()
            dispathgroup.enter()
            
            NetworkRequest.getMonthAverages(symbol: (stock?.symbol)!) { (dict: [String : Double]) in
                self.months = Array(dict.keys)
                self.values = Array(dict.values)
                
                let monthsRevised: [String] = [self.months[0], self.months[3], self.months[7], self.months[11]]
                
                cell.setChart(dataPoints: monthsRevised, values: self.values)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
}
extension IndividualViewController: UITableViewDelegate {
    
    
}
extension IndividualViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        let newsCollection = newsArray[indexPath.item]
        cell.headlineLabel.text = newsCollection.headline
        cell.newsImage.image = #imageLiteral(resourceName: "Sample Scene.png")
        
        return cell
    }
    
}

extension IndividualViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNews", sender: self)
        
    }
    
    
}











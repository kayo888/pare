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
    
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var recLabel: UILabel!
    
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var basedOnCollectionView: UICollectionView!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    @IBOutlet weak var sectorsCollectionView: UICollectionView!
    
    let sectors = ["Consumer Discretionary", "Energy", "Consumer Staples", "Financials", "Health Care", "Industrials", "Information Technology", "Materials", "Real Estate", "Telecommunications Services", "Utilities"]
    
    let sectorImages = [UIImage(named: "Consumer Discretionary")!, UIImage(named: "Energy")!, UIImage(named: "Consumer Staples"), UIImage(named: "Financials"), UIImage(named: "Health Care"), UIImage(named: "Industrials"), UIImage(named: "Information Technology"), UIImage(named: "Materials"), UIImage(named: "Real Estate"), UIImage(named: "Telecommunications"), UIImage(named: "Utilities")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsCollectionView.delegate = self as UICollectionViewDelegate
        newsCollectionView.dataSource = self
        
        basedOnCollectionView.delegate = self as UICollectionViewDelegate
        basedOnCollectionView.dataSource = self
        
        recommendationsCollectionView.dataSource = self
        recommendationsCollectionView.delegate = self as UICollectionViewDelegate
        
        
    }
    var newsArray = [NewsItem]()
    var basedOnArray = [RecommendedStock]()
    var basedOnArray2 = [RecommendedStock]()
    var topRecArray = [RecommendedStock]()
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowNews" {
                
                let indexPath = newsCollectionView.indexPathsForSelectedItems?.first
                
                let news = newsArray[indexPath!.item]
                let newsViewController = segue.destination as! NewsViewController
                newsViewController.url = news.url
            } else if identifier == "ShowStock" {
                let indexPath = basedOnCollectionView.indexPathsForSelectedItems?.first
                
                let individualStockViewController = segue.destination as! IndividualViewController
                let symbol = basedOnArray[(indexPath?.row)!].symbol
                
                NetworkRequest.instantiateStock(symbol: symbol, completion: { (Stock) in
                    individualStockViewController.stock = Stock
                })
            } else if identifier == "ShowRecommendedStock" {
                let indexPath = recommendationsCollectionView.indexPathsForSelectedItems?.first
                
                let individualStockViewController = segue.destination as! IndividualViewController
                let symbol = topRecArray[(indexPath?.row)!].symbol
                
                NetworkRequest.instantiateStock(symbol: symbol, completion: { (Stock) in
                    individualStockViewController.stock = Stock
                })
            } else if identifier == "ShowSector" {
                let indexPath = sectorsCollectionView.indexPathsForSelectedItems?.first
                
                let sectorView = segue.destination as! SectorViewController
                let sector = sectors[(indexPath?.row)!]
                
                sectorView.sector = sector
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let random = Int(arc4random_uniform(UInt32(following.count)))
        
        NetworkRequest.filterSectors(symbol: following[random]) { (tests: [String]) in
            for test in tests {
                NetworkRequest.instantiateRecommendedStock(symbol: test, completion: { (recommend: RecommendedStock?) in
                    self.basedOnArray.append(recommend!)
                })
            }
        }
        NetworkRequest.filterSectors(symbol: following[random]) { (tests: [String]) in
            for test in tests {
                NetworkRequest.instantiateRecommendedStock(symbol: test, completion: { (recommend: RecommendedStock?) in
                    self.basedOnArray2.append(recommend!)
                })
            }
        }
        
        NetworkRequest.topRecommendations(symbols: following) { (tops: [String]) in
            for top in tops {
                NetworkRequest.instantiateRecommendedStock(symbol: top, completion: { (topRec: RecommendedStock?) in
                    self.topRecArray.append(topRec!)
                })
                
            }
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.sectorsCollectionView { return 2 }
        else { return newsArray.count }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.newsCollectionView {
            let cell: DiscoverNewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as! DiscoverNewsCell
            
            let newsCollection = newsArray[indexPath.item]
            cell.title.text = newsCollection.headline
            //            cell.newsImage.image = newsCollection.url
            
            return cell
        } else if collectionView == self.recommendationsCollectionView {
            let cell: DiscoverNewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationsCell", for: indexPath) as! DiscoverNewsCell
            
            let recommendations = topRecArray[indexPath.item]
            cell.title.text = recommendations.symbol
            cell.image.image = recommendations.logo
            
            return cell
        } else if collectionView == self.basedOnCollectionView {
            let cell: DiscoverNewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasedOnCell", for: indexPath) as! DiscoverNewsCell
            //                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! HeaderCollectionReusableView
            
            let based = basedOnArray[indexPath.item]
            cell.title.text = based.symbol
            cell.image.image = based.logo
            //            header.headerLabel.text = "Because You Follow \()"
            
            return cell
        } else if collectionView == self.sectorsCollectionView {
            let cell: DiscoverNewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectorCell", for: indexPath) as! DiscoverNewsCell
            
            let sector = sectors[indexPath.item]
            cell.title.text = sector
            let sectorImage = sectorImages[indexPath.item]
            cell.image.image = sectorImage
            
            return cell
        } else {
            let cell: DiscoverNewsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasedOn2Cell", for: indexPath) as! DiscoverNewsCell
            
            let based = basedOnArray[indexPath.item]
            cell.title.text = based.symbol
            cell.image.image = based.logo
            
            return cell

        }
    }
}

extension DiscoverViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNews", sender: self)
        
    }
    
}
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.sectorsCollectionView {
            let size = CGSize(width: 135, height: 135)
            
            return size
        } else {
            let size = CGSize(width: 140, height: 155)
            
            return size
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.sectorsCollectionView {
            return 9
        } else {
            return 6
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.sectorsCollectionView {
            return 4
        } else {
            
            return 1.5
        }
    }
    
    
}










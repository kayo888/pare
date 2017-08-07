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
    let sectorImages = [UIImage(named: "#imageLiteral(resourceName: "Consumer Discretionary")"), UIImage(named: "#imageLiteral(resourceName: "Energy")"), UIImage(named: "#imageLiteral(resourceName: "Consumer Staples")"), UIImage(named: "#imageLiteral(resourceName: "Financials")"), UIImage(named: "#imageLiteral(resourceName: "Health Care")"), UIImage(named: "#imageLiteral(resourceName: "Industrials")"), UIImage(named: "#imageLiteral(resourceName: "Information Tech")"), UIImage(named: "#imageLiteral(resourceName: "Materials")"), UIImage(named: "#imageLiteral(resourceName: "Real Estate")"), UIImage(named: "#imageLiteral(resourceName: "Telecommunications")"), UIImage(named: "#imageLiteral(resourceName: "Utilities")")]
    
    
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
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! HeaderCollectionReusableView
            
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
        }
    }
}

extension DiscoverViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNews", sender: self)
        
    }
    
}













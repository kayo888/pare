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
    
    @IBOutlet weak var collectionView: CollectionView!
    let collectionViewNews = UICollectionView()
    let collectionViewTop = UICollectionView()
    let collectionViewBased = UICollectionView()
    let newsViewIdentifier = "News"
    let topViewIdentifier = "Top Recommendations"
    let basedViewIdentifier = "Based On"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewTop.delegate = self
        collectionViewTop.dataSource = self
        
        collectionViewNews.delegate = self
        collectionViewNews.dataSource = self
        
        collectionViewBased.delegate = self
        collectionViewBased.dataSource = self
        
        self.view.addSubview(collectionViewNews)
        self.view.addSubview(collectionViewTop)
        self.view.addSubview(collectionViewBased)
        // Do any additional setup after loading the view.
    }
    var newsArray = [NewsItem]()
    var recommended = [Stock]()
    var following = [String]()

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
                
                let indexPath = collectionView.indexPathsForSelectedItems?.first
                
                let news = newsArray[indexPath!.item]
                let newsViewController = segue.destination as! NewsViewController
                newsViewController.url = news.url
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NetworkRequest.filterSectors(symbol: "AAPL") { (tests: [String]) in
            for test in tests {
                NetworkRequest.instantiateStock(symbol: test, completion: { (recommend: Stock?) in
                    self.recommended.append(recommend!)
                    print(self.recommended)
                })
            }
            
        }
    }
}
extension DiscoverViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewNews {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            
            let newsCollection = newsArray[indexPath.item]
            cell.headlineLabel.text = newsCollection.headline
            cell.newsImage.image = #imageLiteral(resourceName: "Sample Scene.png")
            
            return cell
        } else if collectionView == self.collectionViewTop{
            let cell = collectionView
        }
        
        
        
    }
}

extension DiscoverViewController: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNews", sender: self)
        
    }

}

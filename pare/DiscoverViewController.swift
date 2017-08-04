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
    //let currentUser = Auth.auth().currentUser!
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var topRecCollectionView: UICollectionView!
    @IBOutlet weak var basedOnCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    override func viewDidAppear(_ animated: Bool) {
        var recommended: [Stock] = []
        NetworkRequest.filterSectors(symbol: "AAPL") { (tests: [String]) in
            for test in tests {
                NetworkRequest.instantiateStock(symbol: test, completion: { (recommend: Stock?) in
                    recommended.append(recommend!)
                    print(recommended)
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
        <#code#>
    }
}

extension DiscoverViewController: UICollectionViewDelegate{}

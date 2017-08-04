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
    
    override func viewDidAppear(_ animated: Bool) {
        
        //NetworkRequest.filterSectors(symbol: "AAPL") { (test: [Stock]) in
        
        
        
        guard let jsonURL = Bundle.main.url(forResource: "symbol + sector", withExtension: "json") else {
            return
        }
        
        //        DispatchQueue.global(qos: .userInitiated).sync {
        let jsonData = try! Data(contentsOf: jsonURL)
        let sectorData = JSON(data: jsonData)
        let allStockData = sectorData["results"].arrayValue
        let dispatchGroup = DispatchGroup()
        
        
    /**
        
     HELLO EHI!
         THIS IS ABID.
         THIS IS HOW WE TAKE OVER THE WORLD
         FSOCIETY
         
         MR ROBOT IS A GREAT SHOW
         
         GO MAKE AN ENUM OF ALL THE SECTORS
         
         THEN GET SECTORS INSTEAD OF SYMBOLS FIRST
         
         
         
         let thisSECOTR = stock["EICS"].stringValue

         SWITCH CASE OR IF STATMENTS FOR SECTORS 
         
         HAVE AN ARRAY FOR EACH SECTOR
         
         APPEND JSON ACCORDING TO WHICH SECOTOR IT IS
         
         SO YOUR ARRAYS WILL BE OF TYPE JSON
         
         ONCE YOUVE GONE THROUGH ALLSTOCKDATA
         
         FOR EACH SECTOR (ARRAY)IN SECTORS OR NUMBER OF SECTORS PROLLY 4
         
         INSTANTIATE STOCK
         
         BUT DONT MAKE LIKE ONE FOR LOOP FOR ALL OF THEM
         
         INSTANTIATE STOCK FOR EACH
ADD TO BG ARRAY OF ALL STOCK
         //WHILE (ALLSTOCK ARRAYCOUN != SECTORARRAY.COUNT) {
         CHANGE FOR GIT
         }
         
         
         
         
         
         
         let thisSymbol = stock["Ticker symbol"].stringValue

        
        */
        
        var symbols = [Stock]()
//        let dispatchGroup = DispatchGroup()
        for stock in allStockData {
            dispatchGroup.enter()
            let thisSymbol = stock["Ticker symbol"].stringValue
            /*dispatchGroup.enter()
             //            instantiateStock(symbol: thisSymbol, completion: { (Stock) in
             allStocks.append(Stock!)
             dispatchGroup.leave()
             })*/

            NetworkRequest.instantiateStock(symbol: thisSymbol, completion: { (price) in
//                print(price)
//                sts = price.0
                symbols.append(price!)
                print(symbols.count)
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            print("The symbols count is : ", symbols.count)
        }
        
    }
    //   print(test)
    //}
    //}
}
//extension DiscoverViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
//
//extension DiscoverViewController: UICollectionViewDelegate{}

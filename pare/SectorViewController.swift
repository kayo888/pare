//
//  SectorViewController.swift
//  pare
//
//  Created by Ehi Airewele  on 8/7/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SectorViewController: UICollectionViewController {
    var sector: String?
    var sectorStocks = [WatchlistStock]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sector = sector {
            NetworkRequest.getSectorStocks(sector: sector, completion: { (symbols: [String]) in
                
                for symbol in symbols {
                    NetworkRequest.instantiateWatchlistStock(symbol: symbol, completion: { (stock: WatchlistStock) in
                        self.sectorStocks.append(stock)
                    })
                }
                
            })
            
        }
        
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        return cell
    }
}













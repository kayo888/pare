//
//  StatsViewCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/7/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class StatsViewCell: UITableViewCell {
    @IBOutlet weak var statsCollectionView: UICollectionView!
    
    let statLabels = ["PREVIOUS CLOSE", "HIGH", "AVG VOL", "LOW", "MKT CAP", "52 WK HIGH", "P/E RATIO", "52 WK LOW"]
    var stats = [Double]()
    var stock: Stock?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        statsCollectionView.delegate = self as! UICollectionViewDelegate
        statsCollectionView.dataSource = self

        NetworkRequest.getAverages(symbol: (stock?.symbol)!, completion: { (averages: [Double]) in
            
            let low = averages.min()
            let high = averages.max()
            self.stats = [self.stock?.previousClose, high!, self.stock?.avgTotalVolume, low!, self.stock?.marketCap, self.stock?.week52High, self.stock?.peRatio, self.stock?.week52Low] as! [Double]
        })

        // Configure the view for the selected state
    }

}

extension StatsViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return statLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsViewCollectionCell", for: indexPath) as! StatsViewCollectionCell
        
        let statLabel = statLabels[indexPath.item]
        cell.statLabel.text = statLabel
        let stat = stats[indexPath.item]
        cell.stat.text = "\(stat)"
        
        return cell
    }
    
}
//extension













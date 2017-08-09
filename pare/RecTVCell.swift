//
//  RecTVCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/8/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class RecTVCell: UITableViewCell {
    var topRecArray = [Stock]()
    var following = [String]()
    var random: Int?
    var controller: UIViewController!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recommendationsCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        recommendationsCollection.delegate = self as UICollectionViewDelegate
        recommendationsCollection.dataSource = self as UICollectionViewDataSource
        
        NetworkRequest.topRecommendations(symbols: following) { (tops: [String]) in
            for top in tops {
                NetworkRequest.instantiateStock(symbol: top, completion: { (topRec: Stock?) in
                    self.topRecArray.append(topRec!)
                })
                
            }
        }
        
        // Configure the view for the selected state
    }
}
extension RecTVCell
: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return topRecArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        let rec = topRecArray[indexPath.item]
        cell.headlineLabel.text = rec.symbol
        cell.newsImage.image = rec.logo
        
        return cell
    }
    
}
extension RecTVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.performSegue(withIdentifier: "ShowStockRec", sender: self)
        
    }

}

extension RecTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 140, height: 155)
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}














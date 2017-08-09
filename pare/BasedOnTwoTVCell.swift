//
//  BasedOnTwoTVCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/8/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class BasedOnTwoTVCell: UITableViewCell {
    var basedOnArray = [Stock]()
    var following = [String]()
    var random: Int?
    var controller: UIViewController!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var basedTwoCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        basedTwoCollection.delegate = self as UICollectionViewDelegate
        basedTwoCollection.dataSource = self as UICollectionViewDataSource
        
        let random = Int(arc4random_uniform(UInt32(following.count)))
        
        NetworkRequest.filterSectors(symbol: following[random]) { (tests: [String]) in
            for test in tests {
                NetworkRequest.instantiateStock(symbol: test, completion: { (recommend: Stock?) in
                    self.basedOnArray.append(recommend!)
                })
            }
        }
        
        
        // Configure the view for the selected state
    }
    
}
extension BasedOnTwoTVCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.performSegue(withIdentifier: "ShowStockBased2", sender: self)
        
    }
    
}


extension BasedOnTwoTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return basedOnArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        let based = basedOnArray[indexPath.item]
        cell.headlineLabel.text = based.symbol
        cell.newsImage.image = based.logo
        
        return cell
    }


}
extension BasedOnTwoTVCell: UICollectionViewDelegateFlowLayout {
    
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




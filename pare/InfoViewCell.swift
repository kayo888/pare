//
//  InfoViewCellTableViewCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/8/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class InfoViewCell: UITableViewCell {
    @IBOutlet weak var infoCollectionView: UICollectionView!
    var stock: Stock?
    let infoLabels = ["WEBSITE", "CEO"]
    var info = [String]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        infoCollectionView.delegate = self as! UICollectionViewDelegate
        infoCollectionView.dataSource = self

        NetworkRequest.allCompany(symbol: (stock?.symbol)!, completion: { (description, site, ceo) in
            self.info = [site, ceo]
            
        })

        // Configure the view for the selected state
    }

}
extension InfoViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return infoLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoViewCollectionCell", for: indexPath) as! InfoViewCollectionCell
        
        let infoLabel = infoLabels[indexPath.item]
        cell.infoLabel.text = infoLabel
        let infor = info[indexPath.item]
        cell.info.text = "\(infor)"
        
        return cell
    }
    
}

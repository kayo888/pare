//
//  SectorsTVCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/8/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class SectorsTVCell: UITableViewCell {
    let sectors = ["Consumer Discretionary", "Energy", "Consumer Staples", "Financials", "Health Care", "Industrials", "Information Technology", "Materials", "Real Estate", "Telecommunications Services", "Utilities"]
    
    let sectorImages = [UIImage(named: "Consumer Discretionary")!, UIImage(named: "Energy")!, UIImage(named: "Consumer Staples"), UIImage(named: "Financials"), UIImage(named: "Health Care"), UIImage(named: "Industrials"), UIImage(named: "Information Technology"), UIImage(named: "Materials"), UIImage(named: "Real Estate"), UIImage(named: "Telecommunications"), UIImage(named: "Utilities")]
    var controller: UIViewController!

    
    @IBOutlet weak var sectorsCollection: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension SectorsTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectorsCollection", for: indexPath) as! SectorsCollection
        
        let sector = sectors[indexPath.item]
        cell.sectorTitle.text = sector
        let sectorImage = sectorImages[indexPath.item]
        cell.sectorImage.image = sectorImage
        
        return cell
    }

}
extension SectorsTVCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 135, height: 135)
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}










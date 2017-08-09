//
//  NewsTVCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/8/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class NewsTVCell: UITableViewCell {
    var newsArray = [NewsItem]()
    var controller: UIViewController!


    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        newsCollectionView.delegate = self as UICollectionViewDelegate
        newsCollectionView.dataSource = self as UICollectionViewDataSource
        // Configure the view for the selected state
    }

}
extension NewsTVCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        let newsCollection = newsArray[indexPath.item]
        cell.headlineLabel.text = newsCollection.headline
        
        return cell
    }
    
}

extension NewsTVCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.performSegue(withIdentifier: "ShowNews", sender: self)
        
    }
    
    
}













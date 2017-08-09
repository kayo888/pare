//
//  NewsTableViewCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/7/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    var stock: Stock?
    var newsArray = [NewsItem]()
    var controller: UIViewController!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        newsCollectionView.delegate = self
        newsCollectionView.dataSource = self
        
        
        // Configure the view for the selected state
    }
}


extension NewsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        
        let newsCollection = newsArray[indexPath.item]
        cell.headlineLabel.text = newsCollection.headline
//        cell.newsImage.image = #imageLiteral(resourceName: "Sample Scene.png")
        
        return cell
    }
    
}

extension NewsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.performSegue(withIdentifier: "ShowNews", sender: self)
        
    }
    
    
}


//
//  NewsTableViewCell.swift
//  pare
//
//  Created by Ehi Airewele  on 8/7/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

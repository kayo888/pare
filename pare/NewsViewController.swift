//
//  NewsViewController.swift
//  watchlist api
//
//  Created by Ehi Airewele  on 7/21/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    @IBOutlet weak var newsView: UIWebView!
    var url: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsView.loadRequest(URLRequest(url: url!))
        
    }
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
}
 

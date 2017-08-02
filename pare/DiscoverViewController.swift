//
//  DiscoverViewController.swift
//  pare
//
//  Created by Ehi Airewele  on 7/28/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseAuth

class DiscoverViewController: UIViewController {
    //let currentUser = Auth.auth().currentUser!
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var topRecCollectionView: UICollectionView!
    @IBOutlet weak var basedOnCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()  
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    override func viewDidAppear(_ animated: Bool) {
        
        NetworkRequest.filterSectors(symbol: "AAPL") { (test: [Stock]) in
            print(test)
        }
    }
    
}
//extension DiscoverViewController: UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
//
//extension DiscoverViewController: UICollectionViewDelegate{}

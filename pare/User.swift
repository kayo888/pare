//
//  User.swift
//  pare
//
//  Created by Ehi Airewele  on 8/1/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let stocksSymbolsFollowing: [String]
    
    init(uid: String, stocksSymbolsFollowing: String) {
        self.uid = uid
        self.stocksSymbolsFollowing = [stocksSymbolsFollowing]
    }
    
}

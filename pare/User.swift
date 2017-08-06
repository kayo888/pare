//
//  User.swift
//  pare
//
//  Created by Ehi Airewele  on 8/1/17.
//  Copyright © 2017 Ehi Airewele . All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


class User: NSObject {
    let uid: String
    var isFollowed = false
//    let stockSymbolsFollowing: [String]
    
    init(uid: String) {
        self.uid = uid
//        self.stockSymbolsFollowing = stocksSymbolsFollowing
        super.init()
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any]
//            , let stockSymbolsFollowing = dict["stockSymbolsFollowing"] as? [String]
            else { return nil }
        
        self.uid = snapshot.key
//        self.stockSymbolsFollowing = stockSymbolsFollowing
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: uid) as? String
//        ,let stockSymbolsFollowing = aDecoder.decodeObject(forKey: self.stockSymbolsFollowing) as? [String]
        else { return nil }
        
        self.uid = uid
//        self.stockSymbolsFollowing = stockSymbolsFollowing
        
        super.init()
    }
    
    private static var _current: User?
    
    // 2
    static var current: User {
        // 3
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        // 4
        return currentUser
    }
    
    // MARK: - Class Methods
    
    // 5
    static func setCurrent(_ user: User) {
        _current = user
    }
    
    
}
extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: uid)
//        aCoder.encode(stockSymbolsFollowing, forKey: stockSymbolsFollowing[0])
//        aCoder.encode(stockSymbolsFollowing, forKey: stockSymbolsFollowing[1])
//        aCoder.encode(stockSymbolsFollowing, forKey: stockSymbolsFollowing[2])
    }
    
}


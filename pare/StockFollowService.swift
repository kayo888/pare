////
////  FollowService.swift
////  pare
////
////  Created by Ehi Airewele  on 8/4/17.
////  Copyright © 2017 Ehi Airewele . All rights reserved.
////
//
//import Foundation
//import FirebaseDatabase
//
//struct StockFollowService {
//    
//    private static func followStock(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
//        let currentUID = User.current.uid
//        let followData = ["followers/\(user.uid)/\(currentUID)" : true,
//                          "following/\(currentUID)/\(user.uid)" : true]
//        
//        // 2
//        let ref = Database.database().reference()
//        ref.updateChildValues(followData) { (error, _) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }
//            
//            // 3
//            success(error == nil)
//        }
//    }
//    private static func unfollowStock(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
//        let currentUID = User.current.uid
//        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
//        // http://stackoverflow.com/questions/38462074/using-updatechildvalues-to-delete-from-firebase
//        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
//                          "following/\(currentUID)/\(user.uid)" : NSNull()]
//        
//        let ref = Database.database().reference()
//        ref.updateChildValues(followData) { (error, ref) in
//            if let error = error {
//                assertionFailure(error.localizedDescription)
//            }
//            
//            success(error == nil)
//        }
//    }
//    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
//        if isFollowing {
//            followStock(followee, forCurrentUserWithSuccess: success)
//        } else {
//            unfollowStock(followee, forCurrentUserWithSuccess: success)
//        }
//    }
//    static func isStockFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
//        let currentUID = User.current.uid
//        let ref = Database.database().reference().child("followers").child(user.uid)
//        
//        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
//            if let _ = snapshot.value as? [String : Bool] {
//                completion(true)
//            } else {
//                completion(false)
//            }
//        })
//    }
//    
//}

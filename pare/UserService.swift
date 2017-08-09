////
////  UserService.swift
////  pare
////
////  Created by Ehi Airewele  on 8/4/17.
////  Copyright © 2017 Ehi Airewele . All rights reserved.
////
//
//import Foundation
//import FirebaseAuth.FIRUser
//import FirebaseDatabase
//
//struct UserService {
//    
//    static func create(_ firUser: FIRUser, completion: @escaping (User?) -> Void) {
//        
//        let userAttrs = ["uid": firUser.uid] 
//        
//        Auth.auth().signInAnonymously() { (user, error) in
//            let isAnonymous = firUser.isAnonymous
//            let uid = firUser.uid
//            
//            let ref = Database.database().reference().child("users").child(uid)
//            
//            ref.updateChildValues(userAttrs) { (error, ref) in
//                if let error = error {
//                    assertionFailure(error.localizedDescription)
//                    return completion(nil)
//                }
//                
//                ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                    let user = User(snapshot: snapshot)
//                    completion(user)
//                })
//            }
//        }
//    }
//    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
//        let ref = Database.database().reference().child("users").child(uid)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let user = User(snapshot: snapshot) else {
//                return completion(nil)
//            }
//            
//            completion(user)
//        })
//    }
//    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
//        let currentUser = User.current
//        // 1
//        let ref = Database.database().reference().child("users")
//        
//        // 2
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
//                else { return completion([]) }
//            
//            // 3
//            let users =
//                snapshot
//                    .flatMap(User.init)
//                    .filter { $0.uid != currentUser.uid }
//            
//            // 4
//            let dispatchGroup = DispatchGroup()
//            users.forEach { (user) in
//                dispatchGroup.enter()
//                
//                // 5
//                FollowService.isUserFollowed(user) { (isFollowed) in
//                    user.isFollowed = isFollowed
//                    dispatchGroup.leave()
//                }
//            }
//            
//            // 6
//            dispatchGroup.notify(queue: .main, execute: {
//                completion(users)
//            })
//        })
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}

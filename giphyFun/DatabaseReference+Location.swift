//
//  DatabaseReference+Location.swift
//  Makestagram
//
//  Created by Sky Xu on 7/17/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DatabaseReference {
    enum MGLocation {
        case root
        case gifs(uid: String)
        case showGif(uid: String, postKey: String)
        

        case users
        case showUser(uid: String)
        
        
        func asDatabaseReference() -> DatabaseReference {
            let root = Database.database().reference()
            
            switch self {
            case .root:
                return root
                
            case .users:
                return root.child("users")
                
            case .showUser(let uid):
                return root.child("users").child(uid)
                
            case .gifs(let uid):
                return root.child("gifs").child(uid)
                
            case let .showGif(uid, gifKey):
                return root.child("posts").child(uid).child(gifKey)
                
            }
        }
    }
    
    static func toLocation(_ location: MGLocation) -> DatabaseReference {
        return location.asDatabaseReference()
    }
}


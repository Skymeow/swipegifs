//
//  Gif.swift
//  giphyFun
//
//  Created by Sky Xu on 7/22/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Gif {
    var key: String?
    let gifURL: String
    let gifHeight: CGFloat
    
    init(gifURL: String, gifHeight: CGFloat) {
        self.gifURL = gifURL
        self.gifHeight = gifHeight
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            //the dict["gifURL"] is the placeholder name of model in firebase
        let gifURL = dict["gifURL"] as? String,
        let gifHeight = dict["gifHeight"] as? CGFloat
        else { return nil }
        
        self.gifURL = gifURL
        self.gifHeight = gifHeight
        
    }
    var dictValue: [String : Any] {
        //the "gifURL" in return is the placeholder name of model in firebase
        return ["gifURL" : gifURL,
                "gifHeight" : gifHeight]
    }
    
    
}

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
    var dictValue: [String : Any] {
        return ["gif_url" : gifURL,
                "gif_height" : gifHeight]
    }
    
}

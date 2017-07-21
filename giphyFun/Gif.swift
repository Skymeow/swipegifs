//
//  Gif.swift
//  giphyFun
//
//  Created by Sky Xu on 7/20/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//


import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class Gif: NSObject {
    
    let gifUrl: String
    let gifHeight: CGFloat
    
    init(gifUrl: String, gifHeight: CGFloat) {
        self.gifUrl = gifUrl
        self.gifHeight = gifHeight
    }



}

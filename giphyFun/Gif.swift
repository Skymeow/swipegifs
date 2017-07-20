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
    
    let imageURL: String
    let imageHeight: CGFloat
    
    init(imageURL: String, imageHeight: CGFloat) {
        self.imageURL = imageURL
        self.imageHeight = imageHeight
    }



}

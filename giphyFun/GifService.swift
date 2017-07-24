//
//  GifService.swift
//  giphyFun
//
//  Created by Sky Xu on 7/22/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON
import SwiftGifOrigin
import Alamofire
import AlamofireImage

struct GifService {

    static func create(forURLString urlString: String, aspectHeight: CGFloat) {
        let currentUser = User.current
        let gif = Gif(gifURL: urlString, gifHeight: aspectHeight)
        let aspectHeight = 320

        let dict = gif.dictValue
        let gifRef = Database.database().reference().child("gifs").child(currentUser.uid).childByAutoId()
        gifRef.updateChildValues(dict)
}
    
    static func giveGifUrl(completion: @escaping (String) -> Void) {
        let apiString = "https://api.giphy.com/v1/gifs/random"
        
        let headers = ["api_key":"0e52cc9383e148cd84b0c1c1bbfd0705"]
        
        Alamofire.request(apiString, method:.get, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let Data = json["data"]["image_url"]
                    completion(Data.rawString()!)
                }
            case .failure(let error):
                print(error)
                completion("")
            }
        }

    }


}

//
//  ViewController.swift
//  giphyFun
//
//  Created by Sky Xu on 7/20/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import SwiftGifOrigin
import Alamofire
import AlamofireImage

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        let label = gestureRecognizer.view!
        
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        
        let scale = min(abs(100 / xFromCenter), 1)
        
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
        
        
        label.transform = stretchAndRotation
        
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            
            var acceptedOrRejected = ""
            
            if label.center.x < 100 {
                print("not chosen")
                updateImage()
                
            } else if label.center.x > self.view.bounds.width - 100 {
                print("chosen")
                updateImage()
                // acceptedOrRejected = "accepted"
                
            }
            
            
            rotation = CGAffineTransform(rotationAngle: 0)
            
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
            
            
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }
    //end wasDragged function
    
    
    //start call random gif api
    func updateImage() {
        let apiString = "https://api.giphy.com/v1/gifs/random"
        
        let headers = ["api_key":"0e52cc9383e148cd84b0c1c1bbfd0705"]
        
        let request = Alamofire.request(apiString, method:.get, headers: headers).validate().responseJSON() { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    let Data = json["data"]["image_url"]
                    if var string = Data.rawString() {
                        let gif = UIImage.gif(url: string)
                        //self.imageView.af_setImage(withURL: URL(string: string)!)
                       self.imageView.image = gif
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }

    //end calling api
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(gesture)
        
        updateImage()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

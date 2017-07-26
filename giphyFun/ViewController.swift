//
//  ViewController.swift
//  giphyFun
//
//  Created by Sky Xu on 7/20/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//
import Foundation
import UIKit
import Kingfisher
import SwiftyJSON
import SwiftGifOrigin
import Alamofire
import AlamofireImage
import AVFoundation

class ViewController: UIViewController {
  
    
    @IBAction func savedGifButtonTapped(_ sender: UIButton) {
        
    }
    @IBOutlet weak var savedGifButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    //make  a property for url to be used in create service
    var currentUrl: String?
    var myAudioPlayer = AVAudioPlayer()
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        print(currentUrl)
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
                acceptedOrRejected = "rejected"
            } else if label.center.x > self.view.bounds.width - 100 {
                print("chosen")
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected == "accepted" {
                GifService.giveGifUrl(completion: self.update)
                
                GifService.create(forURLString: currentUrl!, aspectHeight: 320)
                playAudio()
                
            } else if acceptedOrRejected == "rejected" {
               GifService.giveGifUrl(completion: self.update)
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
            label.transform = stretchAndRotation
            
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
        }
        
    }
    //end wasDragged function
    
    func update(_ urlString: String?){
        self.currentUrl = urlString
        var gif = UIImage.gif(url: self.currentUrl!)
        //self.imageView.af_setImage(withURL: URL(string: string)!)
        self.imageView.image = gif
    }

    func playAudio() {
        let myFilePathString = Bundle.main.path(forResource: "bartlaf3",ofType:"mp3")
        if let myFilePathString = myFilePathString
        {
            let myFilePathURL = NSURL(fileURLWithPath: myFilePathString)
            do{
                try myAudioPlayer = AVAudioPlayer(contentsOf: myFilePathURL as URL)
                myAudioPlayer.play()
            }catch
            {
                print("error")
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //for print fonts
        
        for family: String in UIFont.familyNames
            
        {
            
            print("\(family)")
            
            for names: String in UIFont.fontNames(forFamilyName: family)
                
            {
                
                print("== \(names)")
                
            }
            
        }
        let rect = CGRect(origin: CGPoint(x: 10,y: 10), size: CGSize(width: 400, height: 100))

        let label: UILabel = UILabel(frame: rect)
        label.textAlignment = NSTextAlignment.center
        label.text = "Everybody loves gifs!"
        label.font = UIFont(name: "gloriahallelujah", size: 35)
        label.backgroundColor = UIColor.white
        self.view.addSubview(label)
        
        view.backgroundColor = UIColor.gray
        //end of calling fonts
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(gesture)
        
        GifService.giveGifUrl(completion: self.update)
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

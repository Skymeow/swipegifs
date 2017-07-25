//
//  SavedGifViewController.swift
//  giphyFun
//
//  Created by Sky Xu on 7/24/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
import SwiftGifOrigin
class SavedGifViewController: UITableViewController {
        
    var user: User!
    var gifs = [Gif]()
    var savedGifRef: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        UserService.getGifs(for: User.current) { (gifs) in
            self.gifs = gifs
            print(gifs)
            self.tableView.reloadData()
        }
        
    }
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath)
        //cell.backgroundColor = .red
        let gif = gifs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath) as! PostImageCell
        let gifURLString = UIImage.gif(url: gif.gifURL)
        cell.myImageView!.image = gifURLString
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let gif = gifs[indexPath.row]
        
        return gif.gifHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

//cause we are using tableview, instead of UIview, so we don't need this extension of datasource and delegate
//extension SavedGifViewController: UITableViewDataSource










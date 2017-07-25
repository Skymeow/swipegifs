//
//  SavedGifViewController.swift
//  giphyFun
//
//  Created by Sky Xu on 7/24/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit
import FirebaseDatabase
class SavedGifViewController: UITableViewController {
    
    var user: User!
    var gifs = [Gif]()
    var savedGifRef: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.getGifs(for: User.current) { (gifs) in
            self.gifs = gifs
            print(gifs)
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell", for: indexPath)
        cell.backgroundColor = .red
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

//cause we are using tableview, instead of UIview, so we don't need this extension of datasource and delegate
//extension SavedGifViewController: UITableViewDataSource










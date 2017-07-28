//
//  NewChatViewController.swift
//  giphyFun
//
//  Created by Sky Xu on 7/27/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class NewChatViewController: UIViewController {

    var following = [User]()
    var selectedUser: User?
    var existingChat: Chat?
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        // check there's selected user to message
        guard let selectedUser = selectedUser else { return }
        //disable nextButton to prevent user tap it multi times
        sender.isEnabled = false
        ChatService.checkForExistingChat(with: selectedUser) { (chat) in
            sender.isEnabled = true
            self.existingChat = chat
            //segue to chatViewController
            self.performSegue(withIdentifier: "toChat", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        
        UserService.following { [weak self] (following) in
            self?.following = following
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension NewChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatUserCell") as! NewChatUserCell
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: NewChatUserCell, at indexPath: IndexPath) {
        let follower = following[indexPath.row]
        cell.textLabel?.text = follower.username
        
        if let selectedUser = selectedUser, selectedUser.uid == follower.uid {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

// for selecting and deselect user
extension NewChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get a ref to the viewcell at the selected indexpath
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // keep track of selecting user
        selectedUser = following[indexPath.row]
        cell.accessoryType = .checkmark
        nextButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // get a ref to viewcell when another cell is selcted and the previous will be deselected
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }
}
// navigation
extension NewChatViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "toChat", let destination = segue.destination as? ChatViewController, let selectedUser = selectedUser {
            let members = [selectedUser, User.current]
            // if doesn't exist an existing chat, create a new chat using the memebrs of chat
            destination.chat = existingChat ?? Chat(members: members)
        }
    }
}







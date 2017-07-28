//
//  Message.swift
//  giphyFun
//
//  Created by Sky Xu on 7/26/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot
import JSQMessagesViewController
import JSQMessagesViewController.JSQMessage

class Message {
    var key: String?
    let content: String
    let timestamp: Date
    let sender: User
    //  initialization is delayed to runtime whenever the object is first referenced.
    lazy var jsqMessageValue: JSQMessage = {
        return JSQMessage(senderId: self.sender.uid,
                          senderDisplayName: self.sender.username,
                          date: self.timestamp,
                          text: self.content)
    }()    
    var dictValue: [String : Any] {
        let userDict = ["username" : sender.username,
                        "uid" : sender.uid]
        return ["sender" : userDict,
                "content" : content,
                "timestamp" : timestamp.timeIntervalSince1970]
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let username = userDict["username"] as? String
            else { return nil }
        
            self.key = snapshot.key
            self.content = content
            self.timestamp = Date(timeIntervalSince1970: timestamp)
            self.sender = User(uid: uid, username: username)
    }
    
    //add another init method to create a message given content as an argument
    init(content: String) {
        self.content = content
        self.timestamp = Date()
        self.sender = User.current
    }
}

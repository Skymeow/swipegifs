//
//  ChatListCell.swift
//  giphyFun
//
//  Created by Sky Xu on 7/27/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}

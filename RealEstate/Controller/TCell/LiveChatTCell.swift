//
//  LiveChatTCell.swift
//  RealEstate
//
//  Created by Himanshu Goyal on 15/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

enum MessageCellType {
    case attendee, host
}


class LiveChatTCell: UITableViewCell {
    
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    func update(message: Message) {
        if message.type == .host{
            self.imgTick.isHidden = false
        }else{
            self.imgTick.isHidden = true
        }
        self.lblUserName.text = message.userName
        self.lblMessage.text = message.text
        self.imgUser.setImageWith(url: message.userImageUrl, placeholder: "profile_photo_iPhone")
    }
}

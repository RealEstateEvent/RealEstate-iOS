//
//  RecentChatMSgTCell.swift
//  RealEstate
//
//  Created by Amit Kumar on 16/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class RecentChatMsgTCell: UITableViewCell {
    static let identifier = "RecentChatMsgTCell"
    
    @IBOutlet weak var lblUnreadCount : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblRole : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var viewBG : UIView!

   

}

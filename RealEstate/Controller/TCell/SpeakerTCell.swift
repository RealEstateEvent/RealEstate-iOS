//
//  SpeakerTCell.swift
//  RealEstate
//
//  Created by Amit Kumar on 14/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class SpeakerTCell: UITableViewCell {
    static var identifier = "SpeakerTCell"

       @IBOutlet weak var imgView: UIImageView!
       @IBOutlet weak var lblName: UILabel!
       @IBOutlet weak var lblBio: UILabel!
       @IBOutlet weak var lblRole: UILabel!
       
       func configCellWith(_ obj:Speaker) {
           self.lblName.text = obj.fullName
           self.lblRole.text = obj.role
           self.imgView.setImageWith(url: obj.profilePicThumb, placeholder: nil)
           self.lblBio.text = obj.desscription
       }
}

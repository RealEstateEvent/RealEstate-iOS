//
//  AttendeeTCell.swift
//  RealEstate
//
//  Created by Amit Kumar on 08/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class AttendeeTCell: UITableViewCell {
    static let identifier = "AttendeeTCell"
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblRole : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    
    @IBOutlet weak var viewBG: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.imgView.cornerRadius = self.imgView.bounds.height / 2
            self.imgView.layoutSubviews()
        }
    }
    
    func configCellWith(_ obj:Attendee) {
        self.lblName.text = obj.fullName
        self.lblRole.text = obj.role
        self.imgView.setImageWith(url: obj.profilePicThumb, placeholder: nil)
    }
    
    func configCellWith(_ obj:Speaker) {
        self.lblName.text = obj.fullName
        self.lblRole.text = obj.role
        self.imgView.setImageWith(url: obj.profilePicThumb, placeholder: nil)
        self.viewBG.backgroundColor = .clear
        
    }
    
}

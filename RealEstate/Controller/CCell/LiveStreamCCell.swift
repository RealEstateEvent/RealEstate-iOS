//
//  LiveStreamCCell.swift
//  RealEstate
//
//  Created by Himanshu Goyal on 15/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class LiveStreamCCell: UICollectionViewCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var noVideoImage: UIImageView!
    @IBOutlet weak var noAudioImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(model: OnlineHostModel){
        self.usernameLabel.text = model.displayName
        if model.isVideoMuted{
            noVideoImage.isHidden = false
            noVideoImage.setImageWith(url: model.userimageURL, placeholder: "profile_photo_iPhone")
        }else{
            noVideoImage.isHidden = true
        }
        
        if model.isAudioMuted{
            self.noAudioImage.image = UIImage(named: "ic_Audio_Mute")
        }else{
            self.noAudioImage.image = UIImage(named: "ic_Audio_Unmute")
        }
    }
    
}

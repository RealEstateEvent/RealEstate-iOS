//
//  EventTCell.swift
//  RealEstate
//
//  Created by Amit Kumar on 06/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit
import OnlyPictures

class EventTCell: UITableViewCell {

    static var identifier = "EventTCell"
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDatePeriod: UILabel!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var imgViewsSpeakers: OnlyHorizontalPictures! {
        didSet {
            self.imgViewsSpeakers.delegate = self
            self.imgViewsSpeakers.dataSource = self
        }
    }
    
    var arrSpeakers = [Speaker]()
    
    
    func configCellWith(_ event: Event) {
        self.imgViewsSpeakers.countPosition = .right
        self.imgViewsSpeakers.alignment = .left
        self.imgViewsSpeakers.order = .ascending
        self.imgViewsSpeakers.isHiddenVisibleCount = false
        self.imgViewsSpeakers.textColorForCount = .gray
        self.imgViewsSpeakers.backgroundColorForCount = .lightText
        self.imgViewsSpeakers.fontForCount = AppFont.bold.font(size: 11)
        
        self.imgView?.setImageWith(url: event.coverPhoto)
        self.lblEventName.text = event.title
        self.lblDatePeriod.text = "\(event.startTime?.toStringDate() ?? "") - \(event.endTime?.toStringDate() ?? "")"
        self.arrSpeakers = event.speakerList
        self.imgViewsSpeakers.reloadData()
    }
}


extension EventTCell : OnlyPicturesDelegate, OnlyPicturesDataSource {
        func pictureView(_ imageView: UIImageView, didSelectAt index: Int) {
            
        }
        
        func numberOfPictures() -> Int {
            return self.arrSpeakers.count
        }
        
        func visiblePictures() -> Int {
            return 4
        }
        
        func pictureViews(_ imageView: UIImageView, index: Int) {
            imageView.setImageWith(url: self.arrSpeakers[index].profilePic,placeholder: "profile_photo_iPhone")
        }
        
        
        
    }

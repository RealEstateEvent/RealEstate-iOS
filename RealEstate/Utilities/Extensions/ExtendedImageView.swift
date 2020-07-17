//
//  ExtendedImageView.swift
//  RealEstate
//
//  Created by Amit Kumar on 02/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func setImageWith(url: String?, placeholder: String? = nil) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let strUrl = url else {
            self.image = UIImage.init(named: placeholder ?? "")
            return
        }
        guard let url = URL.init(string: strUrl) else {
            self.image = UIImage.init(named: placeholder ?? "")
            return
        }
        
        self.sd_setImage(with: url, placeholderImage: UIImage.init(named: placeholder ?? ""))
    }
}

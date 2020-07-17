//
//  ZoomableImageView.swift
//  MarketplaceMasterLuxury
//
//  Created by Amit Kumar on 30/04/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class ZoomableImageView: UIView {

    private let scrollView : UIScrollView = {
        let scroll = UIScrollView.init()
        return scroll
    }()
    
    private let imgView : UIImageView! = {
        let imgView = UIImageView.init()
        imgView.backgroundColor = .white
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var image : UIImage? {
        set {
            self.imgView?.image = newValue
        }
        get {
            return self.imgView?.image
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addSubview(self.scrollView)
        
        scrollView.maximumZoomScale = 6.0
        scrollView.minimumZoomScale = 1.0
        self.scrollView.delegate = self
        self.scrollView.addSubview(self.imgView)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        self.imgView.frame = self.bounds
    }
    

}


extension ZoomableImageView : UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
}

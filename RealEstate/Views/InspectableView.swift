//
//  InspectableView.swift
//  Beauty
//
//  Created by Ongraph on 23/08/19.
//  Copyright © 2019 Mobile Developer. All rights reserved.
//

import UIKit


extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable
    var shouldMaskToBounds: Bool {
        set {
            self.layer.masksToBounds = newValue
        }
        get {
            return self.layer.masksToBounds
        }
    }
    
    @IBInspectable
    var borderColor : UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor.init(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
    
    /** Rounds particular provided Corners. ONLY FOR IOS 11.0 and Later. **/
    
    func roundCornerMask(cornerRadius:CGFloat, _ cornerMask: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        if #available(iOS 11.0, *) {
            self.clipsToBounds = false
            self.layer.cornerRadius = cornerRadius
            self.layer.maskedCorners = cornerMask
        }
    }
    
    
    
    
}

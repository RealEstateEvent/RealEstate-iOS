//
//  ExtendedAlertController.swift
//  Umahro
//
//  Created by ONG_PC on 7/17/19.
//  Copyright © 2019 Ongraph. All rights reserved.
//

import UIKit



extension UIAlertController {
    var  appDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    static func openAlert(_ title: String?,
                          _ msg: String,
                          _ actions: [String],
                          _ style: UIAlertController.Style = .alert,
                          completion:@escaping ((Int)->Void) ) {
        
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: style)
        for (index,action) in actions.enumerated() {
            let tapAction = UIAlertAction.init(title: action, style: .default) { (action) in
                alertController.dismiss(animated: true, completion: {
                    completion(index)
                })
            }
            alertController.addAction(tapAction)
        }
        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func openAlertWithOk(_ title: String?,
                              _ msg: String,
                              _ action: String ,
                              completion:(()->Void)?) {
        
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        
            let tapAction = UIAlertAction.init(title: action , style: .default) { (action) in
                completion?()
                alertController.dismiss(animated: true, completion: {})
            }
            alertController.addAction(tapAction)
        
       UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func openAlertWithOk(_ title: String?,
                                _ msg: String,
                                _ action: String? ,in controller:UIViewController,
                                completion:(()->Void)?) {
        
        let alertController = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        if let action = action {
            let tapAction = UIAlertAction.init(title: action , style: .default) { (action) in
                completion?()
                alertController.dismiss(animated: true, completion: {})
            }
            alertController.addAction(tapAction)
        }
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showNotificationWith(_ msg: String) {
        AKHelper.showNotification(msg: msg)
    }
    
    static func showNotificationWith(msg: String, dismissAfter : TimeInterval = 2,completion:(()->())? = nil) {
        let alertController = UIAlertController.init(title: kAppName, message: msg, preferredStyle: .alert)
        
        kSharedAppDelegate?.topMostController?.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dismissAfter) {
            alertController.dismiss(animated: true, completion: completion)
        }
    }
    
}

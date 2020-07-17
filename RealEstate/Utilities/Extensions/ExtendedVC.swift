//
//  ExtededVC.swift
//  BeautyApp
//
//  Created by Ongraph on 26/08/19.
//  Copyright © 2019 Ongraph. All rights reserved.
//

import UIKit


extension UIViewController {
    static var storyBoardId: String {
        let classStr = NSStringFromClass(self.classForCoder())
        let components = classStr.components(separatedBy: ".")
        assert(components.count > 0, "Failed extract class name from \(classStr)")
        return components.last!
    }
    
    static func instantiate(from storyBoard:AppStoryboard)->Self {
        let story = UIStoryboard.init(name: storyBoard.rawValue, bundle: nil)
        return instantiateVC(from: story)
    }
    
    private class func instantiateVC<T:UIViewController>(from storyBaord: UIStoryboard ) -> T {
        let vc = storyBaord.instantiateViewController(withIdentifier: self.storyBoardId) as? T
        return vc!
    }
    
    func dispatchAfter(timeInterval time : TimeInterval, execute code : @escaping ()->Void)  {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            code()
        }
    }
    
    func dispatchAsyncInMain(code : @escaping ()->Void) {
        DispatchQueue.main.async {
            code()
        }
    }
    
    func loadChild(viewController vc: UIViewController,  in aView: UIView , completion:(()->Void)?) {
        self.addChild(vc)
        aView.addSubview(vc.view)
        vc.view.frame = aView.bounds
        vc.didMove(toParent: self)
        completion?()
    }
    
    func removeChildController() {
        for child in self.children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    
    func popToViewControllerWith<T:UIViewController>(type : T.Type) {
        for vc in self.navigationController?.viewControllers ?? [UIViewController]() {
            if vc.isKind(of: type) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    func removeVC() {
        for vc in self.children {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
    func addChildController(content: UIViewController, in aView : UIView?) {
        self.removeVC()
        addChild(content)
        
        if aView != nil {
            aView?.addSubview(content.view)
            content.view.frame = aView!.bounds
//            content.preferredContentSize.height = aView?.bounds.height ?? 0
        } else {
//            content.preferredContentSize.height = self.view.bounds.height
            content.view.frame = self.view.bounds
        }
        content.didMove(toParent: self)
    }
    
}


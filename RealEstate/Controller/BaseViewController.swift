//
//  BaseViewController.swift
//  MarketplaceMasterLuxury
//
//  Created by Ongraph on 12/03/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let leftBarButtonItem = UIBarButtonItem.init(image: nil, style: .plain, target: self, action: #selector(self.btnLeftTapped))
        leftBarButtonItem.title = "X"
        leftBarButtonItem.tintColor = .red
        self.navigationItem.leftBarButtonItems = [leftBarButtonItem]
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    @objc func btnLeftTapped() {
        if self.isBeingPresented {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

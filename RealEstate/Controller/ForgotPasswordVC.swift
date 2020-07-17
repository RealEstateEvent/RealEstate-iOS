//
//  ForgotPasswordVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 30/06/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var tfEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnSendTapped(_ sender: UIButton) {
        if (self.tfEmail.text ?? "").isEmpty {
            UIAlertController.showNotificationWith(ValidationMessages.kEmptyEmail)
        } else if !(self.tfEmail.text ?? "").isEmail {
            UIAlertController.showNotificationWith(ValidationMessages.kInvalidEmail)
        } else {
            let param = ["email":self.tfEmail.text ?? ""]
            AKNetworkManager.sharedManager.request(webService: .forgotPassword, param: param, method: .post) { (data) in
                let msg = AKHelper.getDictionary(from: data)?["message"] as? String
                UIAlertController.openAlertWithOk(kAppName, msg ?? "", "OK") {
                    self.navigationController?.popViewController(animated: true)
                }                
            }
        }
    }
    
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//
//  OTPVerificationVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 30/06/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class OTPVerificationVC: UIViewController {
    
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet var arrTf: [UITextField]!
    var isEmailUnVerified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = SharedClass.shared.user?.email {
            let text = "Please enter 5 digit code we just sent to \(email)"
            self.lblSubHeading.attributedText = text.getAttributedText(highlightedText: email)
        }
        
        for i in 0..<arrTf.count {
            self.arrTf[i].addTarget(self, action: #selector(self.textFieldValueDidChange(_:)), for: .editingChanged)
            self.arrTf[i].tag = i
        }
        
        if self.isEmailUnVerified {
            self.apiCallResendOTP()
        }
        
    }
    
    @IBAction func btnConfirmTapped(_ sender: UIButton) {
        let emptyArr = self.arrTf.filter{($0.text ?? "").isEmpty}
        if emptyArr.count > 0 {
            UIAlertController.showNotificationWith(ValidationMessages.kEmptyOtp)
        } else {
            var otp = ""
            self.arrTf.forEach { (textField) in
                otp.append(textField.text ?? "")
            }
            let intOTP = Int(otp) ?? 0
            let param = ["otp":intOTP]
            print("OTP IS :\(param)")
            AKNetworkManager.sharedManager.request(webService: .otpVerification, param: param, method: .patch) { (data) in
                SharedClass.shared.user?.isEmailVerified = true
                AppUserDefault.saveAndUpdateUser()
                let vc = ProfileVC.instantiate(from: .home)
                vc.isEditingEnabled = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnResendTapped(_ sender: UIButton) {
        
        self.apiCallResendOTP()
        self.arrTf.forEach { (textField) in
            textField.backgroundColor = .customTextFieldColor
            textField.text = ""
        }
    }
    
}

extension OTPVerificationVC  {
    
    @objc private func textFieldValueDidChange(_ sender: UITextField) {
        let text = sender.text
        if text?.count == 0 {
            sender.backgroundColor = .customTextFieldColor
            let nextIndex = sender.tag - 1
            if nextIndex > -1 {
                self.arrTf[nextIndex].becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        } else {
            sender.backgroundColor = .white
            let nextIndex = sender.tag + 1
            if nextIndex < self.arrTf.count {
                self.arrTf[nextIndex].becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        }
    }
    
    private func apiCallResendOTP() {
        AKNetworkManager.sharedManager.request(webService: .otpVerification, param: [:], method: .get) { (data) in
            let msg = AKNetworkManager.sharedManager.getMessage(from: data)
            UIAlertController.showNotificationWith(msg ?? "")
        }
    }
    
}

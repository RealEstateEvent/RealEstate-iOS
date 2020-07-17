//
//  SignupVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 30/06/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnViewPasswordTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            self.tfPassword.isSecureTextEntry = !sender.isSelected
        } else {
            self.tfConfirmPassword.isSecureTextEntry = !sender.isSelected
        }
    }
    
   
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        let user = SharedClass.shared.user
        user?.email = self.tfEmail.text
        user?.password = self.tfPassword.text
        let validationTuple = validateParams()
        if validationTuple.isValid {
            let param = [
                "email":user?.email ?? "",
                "password" : user?.password ?? "",
                "userType" : "attendee"
            ]
            AKNetworkManager.sharedManager.request(webService: .signup, param: param, method: .post) { (data) in
//                print("SIGN UP DATA:\(data)")
                let vc = OTPVerificationVC.instantiate(from: .registration)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            UIAlertController.showNotificationWith(validationTuple.errorMessage ?? "")
        }
    }
    
    @IBAction func btnSignInTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func validateParams()->(isValid:Bool, errorMessage :String?) {
        let user = SharedClass.shared.user
        if (user?.email ?? "").isEmpty {
            return (false, ValidationMessages.kEmptyEmail)
        } else if !(user?.email ?? "").isEmail {
            return (false, ValidationMessages.kInvalidEmail)
        } else if (user?.password ?? "").isEmpty {
            return (false, ValidationMessages.kEmptyPassword)
        } else if !(user?.password ?? "").isValidPassword {
            return (false, ValidationMessages.kInvalidPassword)
        } else if (self.tfConfirmPassword.text ?? "").isEmpty {
            return (false, ValidationMessages.kEmptyConfirmedPassword)
        } else if (self.tfConfirmPassword.text ?? "") !=  (user?.password ?? "") {
            return (false, ValidationMessages.kPasswordMismatch)
        } else {
            return (true,nil)
        }
    }
}



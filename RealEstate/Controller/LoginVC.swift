//
//  LoginVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 30/06/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnVisiblePasswordTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.tfPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        let vc = ForgotPasswordVC.instantiate(from: .registration)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnSignupTapped(_ sender: UIButton) {
        let vc = SignupVC.instantiate(from: .registration)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSigninTapped(_ sender: UIButton) {
        //validation
        let user = SharedClass.shared.user
        user?.email = self.tfEmail.text
        user?.password = self.tfPassword.text
        let validationTuple = validateParams()
        if validationTuple.isValid {
            let param = ["email":user?.email ?? "", "password":user?.password ?? ""]
            AKNetworkManager.sharedManager.request(webService: .login, param: param, method: .post) { (data) in
                let dict = AKHelper.getDictionary(from: data)
                if let data = dict?["data"] as? [String:Any] {
                    SharedClass.shared.user = User.init(json: data)
                    AppUserDefault.saveAndUpdateUser(SharedClass.shared.user?.toDictionary)
                    if !(SharedClass.shared.user?.isEmailVerified ?? false) {
                        let vc = OTPVerificationVC.instantiate(from: .registration)
                        vc.isEmailUnVerified = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        if !(SharedClass.shared.user?.isProfileSetup ?? false) {
                            let vc = ProfileVC.instantiate(from: .home)
                            vc.isEditingEnabled = true
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let storyBaord = UIStoryboard.init(name: AppStoryboard.home.rawValue, bundle: nil)
                            if let vc = storyBaord.instantiateInitialViewController() {
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            UIAlertController.showNotificationWith(validationTuple.errorMessage ?? "")
        }
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
        } else {
            return (true,nil)
        }
    }
    
}

//
//  ProfileVC.swift
//  RealEstate
//
//  Created by Amit Kumar on 30/06/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfRole: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    var isEditingEnabled = false
    var hasImagePicked = false
    private var bioDescription = "Your current profession or business and your role"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tvDescription.text = self.bioDescription
        
        self.setupView()
    }
    
    private func setupView() {
        self.btnEdit.isHidden = self.isEditingEnabled
        self.btnLogout.isHidden = self.isEditingEnabled
        self.btnSave.isHidden = !self.isEditingEnabled
        if (SharedClass.shared.user?.isProfileSetup ?? false) {
            self.prefillUI()
        } else {
            self.btnSave.setTitle("Save & continue", for: .normal)
        }
        
        if SharedClass.shared.user?.profilePic == nil || (SharedClass.shared.user?.profilePic ?? "").isEmpty {
            self.btnUploadImage.setImage(#imageLiteral(resourceName: "camera_icon_iPhone"), for: .normal)
        } else {
            if self.isEditingEnabled {
                self.btnUploadImage.setImage(#imageLiteral(resourceName: "edit_pencil_iPhone"), for: .normal)
            } else {
                self.btnUploadImage.setImage(#imageLiteral(resourceName: "unedit_pencil_iPhone"), for: .normal)
            }
        }
    }
    
    private func prefillUI() {
        let userInteractionEnabled : Bool
        userInteractionEnabled = self.isEditingEnabled
        self.btnUploadImage.isUserInteractionEnabled = userInteractionEnabled
        self.tfFirstName.isUserInteractionEnabled = userInteractionEnabled
        self.tfLastName.isUserInteractionEnabled = userInteractionEnabled
        self.tfRole.isUserInteractionEnabled = userInteractionEnabled
        self.tvDescription.isUserInteractionEnabled = userInteractionEnabled
        if self.isEditingEnabled == false  {
            let user = SharedClass.shared.user
            self.imgViewProfile.setImageWith(url: user?.profilePic, placeholder: "profile_photo_iPhone")
            self.tfFirstName.text = user?.firstName
            self.tfLastName.text = user?.lastName
            self.tfRole.text = user?.role
            self.btnSave.setTitle("Save", for: .normal)
            self.tvDescription.text = user?.bioDescription
        }
        
    }
    
    @IBAction func btnEditTapped(_ sender: UIButton) {
        self.isEditingEnabled = true
        self.setupView()
    }
    
    @IBAction func btnUploadImageTapped(_ sender: UIButton) {
        ImagePickerHelper.shared.showPickerController {[weak self] (images) -> (Void) in
            if let images = images {
                self?.imgViewProfile.image = images.first
                self?.hasImagePicked = true
            }
        }
    }
    
    @IBAction func btnLogoutTapped(_ sender: UIButton) {
        AKNetworkManager.sharedManager.request(webService: .logout, param: [:], method: .delete) { (data) in
            SharedClass.shared.logout()
        }
    }
    
    @IBAction func btnSaveNContinue(_ sender: Any) {
        if !(SharedClass.shared.user?.isProfileSetup ?? false) {
            if !self.hasImagePicked {
                UIAlertController.showNotificationWith(ValidationMessages.kEmptyImage)
            } else {
                self.apiCallUpdateProfile()
            }
        } else {
            self.apiCallUpdateProfile()
        }
    }
    
    private func validateField()->(isValid: Bool,msg:String?) {
         if (self.tfFirstName.text ?? "").isEmpty {
            return (false,ValidationMessages.kEmptyFirstName)
        } else if (self.tfLastName.text ?? "").isEmpty {
            return (false,ValidationMessages.kEmptyLastName)
        } else if (self.tfRole.text ?? "").isEmpty {
            return (false,ValidationMessages.kEmptyRole)
        } else if (self.tvDescription.text ?? "").isEmpty || (self.tvDescription.text == bioDescription) {
            return (false,ValidationMessages.kEmptyProfileDescription)
        } else {
            return (true,nil)
        }
    }
    
    func apiCallUpdateProfile() {
        let validationTuple = validateField()
        if validationTuple.isValid {
            let param = [
                "firstName": self.tfFirstName.text ?? "",
                "lastName" : self.tfLastName.text ?? "",
                "role" : self.tfRole.text ?? "",
                "description": self.tvDescription.text ?? ""
                ]
            
            var attachments = [Attachment]()
            if let image = self.imgViewProfile.image , self.hasImagePicked {
                let attachment = Attachment.init(self.tfFirstName.text, "profilepic", .image(image))
                attachments.append(attachment)
            }
            
            AKNetworkManager.sharedManager.requestMultiPart(webService: .editProfile, method: .patch, attachments: attachments, parameters: param) { (data) in
                if !(SharedClass.shared.user?.isProfileSetup ?? false)  {
                    let storyBaord = UIStoryboard.init(name: AppStoryboard.home.rawValue, bundle: nil)
                    if let vc = storyBaord.instantiateInitialViewController() {
                        let navigationVC = vc
                        kSharedAppDelegate?.window?.rootViewController = navigationVC
                        kSharedAppDelegate?.window?.makeKeyAndVisible()
                    }
                    let dict = AKHelper.getDictionary(from: AKHelper.getDictionary(from: data)?["data"])
                    AppUserDefault.saveAndUpdateUser(dict)
                } else {
                    let dict = AKHelper.getDictionary(from: AKHelper.getDictionary(from: data)?["data"])
                    AppUserDefault.saveAndUpdateUser(dict)
                    self.isEditingEnabled = false
                    self.setupView()
                }               
            }
            
        } else {
            UIAlertController.showNotificationWith(validationTuple.msg ?? "")
        }
    }
    
    
}

//extension ProfileVC : UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == self.bioDescription {
//            textView.text = ""
//            textView.textColor = .customTextFieldColor
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == "" {
//            textView.text = self.bioDescription
//            textView.textColor = .white
//        }
//    }
//}

//
//  ImagePickerHelper.swift
//  Awwvid4u
//
//  Created by fluper on 29/01/19.
//  Copyright © 2019 fluper. All rights reserved.
//


import Foundation
import UIKit
import MobileCoreServices
//import BSImagePicker
import Photos




var pickerCallBack:PickerImages = nil

typealias PickerImages = (([UIImage]?) -> (Void))?

class ImagePickerHelper: NSObject {
    
    private override init() {}
    static var shared : ImagePickerHelper = ImagePickerHelper()
    var picker = UIImagePickerController()
    
    // MARK:- Action Sheet
    
    func showActionSheet(withTitle title: String?, withAlertMessage message: String?, withOptions options: [String], handler:@escaping (_ selectedIndex: Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for strAction in options {
            let anyAction =  UIAlertAction(title: strAction, style: .default){ (action) -> Void in
                return handler(options.firstIndex(of: strAction)!)
            }
            alert.addAction(anyAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (action) -> Void in
            return handler(-1)
        }
        alert.addAction(cancelAction)
        presetImagePicker(pickerVC: alert)
        
    }
    
    // MARK: Public Method
    
    /**
     * Public Method for showing ImagePicker Controlller simply get Image
     * Get Image Object
     */
    
    func showPickerController(wantToPickMultipleImages: Bool = false, _ handler:PickerImages) {
        
        self.showActionSheet(withTitle: "Choose Option", withAlertMessage: nil, withOptions: ["Take Picture", "Open Gallery"]){ ( _ selectedIndex: Int) in
            switch selectedIndex {
            case 0:
                self.showCamera()
            case 1:
                print("PICK MANY IMAGES")
                self.openGallery()
            default:
                break
            }
        }
        
        pickerCallBack = handler
    }
    
    
    
    /**
     * Public Method for capture image from camera simply get Image
     * Get Image Object
     */
    
    func openCameraDirect(_ handler:PickerImages) {
        
        self.showCamera()
        
        pickerCallBack = handler
    }
    
    /**
     * Public Method for Picking image from Image Picker Controlller simply get Image
     * Get Image Object
     */
    
    func openGalleryDirect(_ handler:PickerImages) {
        
        self.openGallery()
        
        pickerCallBack = handler
    }
    
    
    // MARK:-  Camera
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .camera
//            picker.mediaTypes = [kUTTypeMovie as String]

            presetImagePicker(pickerVC: picker)
        } else {
            let alert = UIAlertController.init(title:nil, message:"Camera not available." , preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            kSharedAppDelegate?.topMostController?.present(alert, animated: true, completion: nil)
        }
        picker.delegate = self
        
    }
    
    
    
    // MARK:-  Gallery
    func openGallery() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        presetImagePicker(pickerVC: picker)
        picker.delegate = self
    }
    
    // MARK:- Show ViewController
    private func presetImagePicker(pickerVC: UIViewController) -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.present(pickerVC, animated: true, completion: {
            self.picker.delegate = self
        })
    }
    
    fileprivate func dismissViewController() -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Picker Delegate
extension ImagePickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        picker.dismiss(animated: true, completion: nil)
        pickerCallBack?([image])
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

enum MediaType:Int
{
    case image = 0, video = 1, none = 2
    
    init(rawValue: Int)
    {
        switch rawValue
        {
        case 0: self = .image
        case 1: self = .video
        default: self = .none
            
        }
    }
    
    var CameraMediaType:[String]
    {
        switch rawValue
        {
        case 0: return [(kUTTypeImage as String)]
        case 1: return [(kUTTypeMovie as String)]
        default: return [(kUTTypeImage as String),(kUTTypeMovie as String)]
            
        }
    }
}


extension ImagePickerHelper  {

    func getUIImage(asset: PHAsset) -> UIImage? {

        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in

            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    
}




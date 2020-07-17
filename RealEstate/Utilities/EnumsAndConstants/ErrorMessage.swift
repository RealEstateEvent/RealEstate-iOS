//
//  AppConstants.swift
//  MarketplaceMasterLuxury
//
//  Created by Ongraph on 03/01/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

struct ErrorMessage {
    
    static let kEmptyAddress = "Please enter address."
    static let kEmptyCountryCode = "Please Enter Country Code."
    static let kEmptyMobileNumber = "Please enter mobile number."
    static let kInvalidMobileNumber = "Please enter a valid mobile number."
    static let kEmptyDate = "Please select date."
    static let kNoDataFound = "No Data found!"
    static let kUndefinedError = "Something went wrong. Please try again."
    static let kInternetError = "Internet connection lost.\nTry again with active internet connection."
    static let kEmptyMasterSign = "Master signature is required."
    static let kLogoutMessage = "Do you want to logout?"
    static let kEmptyBrand = "Please select brand"
    static let kEmptyModel = "Please select Model"
    static let kEmptySerial = "Please select serial number"
    static let kEmptyCondition = "Please select condition"
    static let kEmptyBracletLink = "Please select missing bracelet link"
    static let kEmptyAskingPrice = "Please enter asking price."

}

struct ValidationMessages {
    static let kEmptyUserName = "Please enter username."
    static let kEmptyEmail = "Please enter email."
    static let kInvalidEmail = "Please enter valid email."
    static let kEmptyPassword = "Please enter password."
    static let kInvalidPassword = "Please must contain atleat 6 charcters."
    static let kEmptyConfirmedPassword = "Please enter confirmed password."
    static let kPasswordMismatch = "Please enter confirmed password same as password."
    static let kEmptyOtp = "Some of the field is empty."
    static let kEmptyImage = "Please upload image."
    static let kEmptyFirstName = "Please enter first name."
    static let kEmptyLastName = "Please enter last name."
    static let kEmptyRole = "Please enter role."
    static let kEmptyProfileDescription = "Please enter your description"
}


struct SuccessMessage  {
    static let kSucessfullyUploadedWatchDetails = "Watch details uploaded succesfully. Please Wait for estimation."
}

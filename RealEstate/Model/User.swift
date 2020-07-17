//
//  User.swift
//  MarketplaceMasterLuxury
//
//  Created by Ongraph on 13/03/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation
import FTIndicator

typealias JSON = [String:Any]?


final class User  {
    var id: String?
    var userType : Int?
    var email : String?
    var password : String?
    var firstName : String?
    var lastName : String?
    var isProfileSetup : Bool?
    var isEmailVerified : Bool?
    var profilePic : String?
    var role : String?
    var bioDescription : String?
   
    
    init(json:JSON) {
        self.userType = json?["userType"] as? Int
        self.email = String.getString(json?["email"])
        self.password = String.getString(json?["password"])
        self.firstName = String.getString(json?["firstName"])
        self.lastName = String.getString(json?["lastName"])
        self.profilePic = String.getString(json?["profilePic"])
        self.role = String.getString(json?["role"])
        self.bioDescription = String.getString(json?["description"])
        if let otpVerified = json?["isEmailVerified"] as? Int {
            self.isEmailVerified = otpVerified.toBool
        }
        if let isProfileSet = json?["isProfileSetup"] as? Int {
            self.isProfileSetup = isProfileSet.toBool
        }
        self.id = String.getString(json?["_id"])
    }
    
    func updateModel(json: JSON) {
        self.id = json?["_id"] as? String
        self.userType = json?["userType"] as? Int
        self.email = String.getString(json?["email"])
        self.password = String.getString(json?["password"])
        self.firstName = String.getString(json?["firstName"])
        self.lastName = String.getString(json?["lastName"])
        self.profilePic = String.getString(json?["profilePic"])
        self.role = String.getString(json?["role"])
        self.bioDescription = String.getString(json?["description"])


        if let otpVerified = json?["isEmailVerified"] as? Bool {
            self.isEmailVerified = otpVerified
        }
        if let isProfileSet = json?["isProfileSetup"] as? Bool {
            self.isProfileSetup = isProfileSet
        }
    }
    
    init() {
    }
    
    var toDictionary : [String:Any] {
        var param = [String:Any]()
        param["email"] = self.email ?? ""
        param["userType"] = self.userType ?? ""
        param["password"] = self.password ?? ""
        param["firstName"] = self.firstName ?? ""
        param["lastName"] = self.lastName ?? ""
        param["isEmailVerified"] = self.isEmailVerified?.toInt
        param["isProfileSetup"] = self.isProfileSetup?.toInt
        param["profilePic"] = self.profilePic ?? ""
        param["role"] = self.role ?? ""
        param["description"] = self.bioDescription ?? ""
        param["_id"] = self.id ?? ""
        return param
    }
}


//
//  AppUserDefault.swift
//  MarketplaceMasterLuxury
//
//  Created by Ongraph on 14/03/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

class AppUserDefault  {
    static var userKey = "User"
    static var authToken = "AuthToken"
    static func saveAndUpdateUser(_ json: [String:Any]? = SharedClass.shared.user?.toDictionary) {
        if let user = SharedClass.shared.user {
            user.updateModel(json: json)
            let archiveObject = NSKeyedArchiver.archivedData(withRootObject: user.toDictionary)
            UserDefaults.standard.set(archiveObject, forKey: userKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var currentUser : User? {
        guard let data = UserDefaults.standard.value(forKey: userKey) as? Data else {
            return nil
        }
        let json = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String:Any]
        return User.init(json: json)
    }
    
    static func removeCurrentUser() {
        SharedClass.shared.user = User()
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: authToken)
        UserDefaults.standard.synchronize()
    }
    
    static func setAuth(token : String?){
        if let auth = token {
            UserDefaults.standard.setValue(auth, forKey: authToken)
            UserDefaults.standard.synchronize()
        }
    }
    static func getAuthToken()-> String? {
        let token = UserDefaults.standard.value(forKey: authToken) as? String
        return token
    }
}

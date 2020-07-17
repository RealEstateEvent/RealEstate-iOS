//
//  ShareClass.swift
//  Sail
//
//  Created by Amit Kumar on 02/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

final class SharedClass {
    static var shared = SharedClass.init()
    var user: User?
    
    private init(){
//        self.user = User.init()
        if let user = AppUserDefault.currentUser {
            self.user = user
        } else {
            self.user = User.init()
        }
    }
    
    func logout(){
        kSharedAppDelegate?.redirectToSignIn()
    }

}

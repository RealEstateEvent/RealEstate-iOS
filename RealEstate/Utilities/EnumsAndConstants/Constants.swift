//
//  Constants.swift
//  MarketplaceMasterLuxury
//
//  Created by Ongraph on 12/03/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import UIKit


let kBaseURL = "https://realestatecon.herokuapp.com/api/"



var kSharedRootController : UIViewController? {
    set {
        UIApplication.shared.windows.first?.rootViewController = newValue
    }
    get  {
        return UIApplication.shared.windows.first?.rootViewController
    }
}

let kSharedAppDelegate = UIApplication.shared.delegate as? AppDelegate


let kAppName = Bundle.main.infoDictionary!["CFBundleName"] as! String
var kSharedAuthToken : String? {
    AppUserDefault.getAuthToken()
}


typealias PostJSON = [String:Any]



var kSharedUniqueDeviceId : String {
    UIDevice.current.identifierForVendor!.uuidString
}
 

enum AppFont : String {
    case extraBold = "NunitoSans-ExtraBold"
    case semiBold = "NunitoSans-SemiBold"
    case light = "NunitoSans-Light"
    case bold = "NunitoSans-Bold"
    case regular = "NunitoSans-Regular"
    func font(size:CGFloat = 16)-> UIFont {
        return UIFont.init(name: self.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

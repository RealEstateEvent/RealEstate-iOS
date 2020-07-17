//
//  WebService.swift
//  MarketplaceMasterLuxury
//
//  Created by Ongraph on 12/03/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

enum WebService : String {
    case signup = "user/signup"
    case login = "user/login"
    case forgotPassword = "user/forgetpass"
    case otpVerification = "user/email_confirmation"
    case editProfile = "user/profile"
    case logout = "user/logout"
    case allUpcomingEvents = "event/all?isPast=false&"
    case allPastEvents = "event/all?isPast=true&"
    case myUpcomingEvents = "event/my?isPast=false&"
    case myPastEvents = "event/my?isPast=true&"
    case eventDetail = "event?"
    case bookEvent = "event/book?"
    
    case watchDetails = "WatchDetails"
    case getAllModelWithBrands = "brand_id"
    case getAllSerialWithModel = "model_id"
    case uploadWatchDetails = "staff/upload_images"
    case changeLanguage = "Staff/set_language"
    case changeNotificationStatus = "Staff/set_notifications"
    
}

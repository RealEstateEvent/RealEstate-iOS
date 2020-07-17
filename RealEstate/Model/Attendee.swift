//
//  Attendee.swift
//  RealEstate
//
//  Created by Amit Kumar on 09/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

class Attendee {
    var firstName : String?
    var lastName : String?
    var email : String?
    var profilePicThumb : String?
    var profilePic : String?
    var role: String?
    var id: String?

    var fullName : String? {
        return "\(self.firstName ?? "") \(self.lastName ?? "")"
    }
    
    init(with json: PostJSON? ) {
        self.firstName = json?["firstName"] as? String
        self.lastName = json?["lastName"] as? String
        self.email = json?["email"] as? String
        self.role = String.getString(json?["role"])
        self.profilePic = json?["profilePic"] as? String
        self.profilePicThumb = json?["profilePicThumb"] as? String
        self.id = String.getString(json?["id"])
    }
}

class AttendeeWrapperModel {
    var attendees = [Attendee]()
    var totalCount = 0
    init(_ json: PostJSON?) {
        let arrAttendee =  AKHelper.getArrayOfDict(from: json?["docs"])?.map{Attendee.init(with: $0)}
        if let attendees = arrAttendee {
            self.attendees = attendees
        }
        self.totalCount = String.getString(json?["total"]).toInt ?? 0
    }
}

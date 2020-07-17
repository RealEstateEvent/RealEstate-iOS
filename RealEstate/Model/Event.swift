//
//  Event.swift
//  RealEstate
//
//  Created by Amit Kumar on 07/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

class Event {
    
    var event_id: String?
    var title : String?
    var startTime : String?
    var endTime : String?
    var coverPhoto : String?
    var coverPhotoThumb : String?
    var desscription : String?
    var isBooked : Bool!

    
    
    var speakerList = [Speaker]()
    var agendaList = [Agenda]()
    var attendeeList : AttendeeWrapperModel?
    
    init(with json: PostJSON?) {
        self.event_id = json?["event_id"] as? String
        self.title = json?["title"] as? String
        self.startTime = String.getString(json?["startTime"])
        self.endTime = String.getString(json?["endTime"])
        self.coverPhoto = json?["coverPhoto"] as? String
        let speakers =  AKHelper.getArrayOfDict(from: json?["speakerList"])?.map{Speaker.init(with: $0)}
        if let speakers = speakers {
            self.speakerList = speakers
        }
        let arrAgenda =  AKHelper.getArrayOfDict(from: json?["agendaList"])?.map{Agenda.init($0)}
        if let arrAgenda = arrAgenda {
            self.agendaList = arrAgenda
        }
        self.attendeeList = AttendeeWrapperModel.init(AKHelper.getDictionary(from: json?["attendeeList"]))
        self.coverPhotoThumb = String.getString(json?["coverPhotoThumb"])
        self.desscription = String.getString(json?["description"])
        self.isBooked = String.getString(json?["isBooked"]).toInt?.toBool
    }
}

class Speaker {    
    
    var firstName : String?
    var lastName : String?
    var email : String?
    var userType : String?
    var profilePicThumb : String?
    var profilePic : String?
    var id: String?
    var speakerType : String?
    var role: String?
    var desscription : String?

    var fullName : String? {
        return "\(self.firstName ?? "") \(self.lastName ?? "")"
    }
    
    init(with json: PostJSON? ) {
        self.id = (json?["id"] as? String) ?? (json?["_id"] as? String)
        self.firstName = json?["firstName"] as? String
        self.lastName = json?["lastName"] as? String
        self.email = json?["email"] as? String
        self.userType = String.getString(json?["userType"])
        self.profilePic = json?["profilePic"] as? String
        self.profilePicThumb = json?["profilePicThumb"] as? String
        self.speakerType = json?["speakerType"] as? String
        self.role = json?["role"] as? String
        self.desscription = json?["description"] as? String
    }
}

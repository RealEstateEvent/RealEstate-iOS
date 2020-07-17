//
//  Agenda.swift
//  RealEstate
//
//  Created by Amit Kumar on 09/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

class Agenda {
    var startTime : String?
    var endTime : String?
    var speakers = [Speaker]()
    var format : String?
    var title : String?
    var desscription : String?
    var id: String?
    
    init(_ json: PostJSON?) {
        self.startTime = String.getString(json?["startTime"])
        self.endTime = String.getString(json?["endTime"])
        let speakers =  AKHelper.getArrayOfDict(from: json?["speakers"])?.map{Speaker.init(with: $0)}
        if let speakers = speakers {
            self.speakers = speakers
        }
        self.format = String.getString(json?["format"])
        self.title = String.getString(json?["title"])
        self.desscription = String.getString(json?["description"])
        self.id = String.getString(json?["id"])
    }
}

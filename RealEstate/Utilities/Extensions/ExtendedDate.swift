//
//  ExtendedDate.swift
//  RealEstate
//
//  Created by Amit Kumar on 07/07/20.
//  Copyright © 2020 Ongraph. All rights reserved.
//

import Foundation

extension Date {
    func toStringWith(format: String)-> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = format
        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
}

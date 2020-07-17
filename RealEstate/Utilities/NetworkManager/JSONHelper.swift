//
//  AKHelper.swift
//  Sail
//
//  Created by Amit Kumar on 29/10/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

class  JSONHelper {
    static func getDictionary(from any: Any?) -> [String:Any] {
        guard let dict = any as? [String:Any] else {
            return [:]
        }
        return dict
    }
    static func getArrayOfDict(from any: Any?) -> [[String:Any]] {
        guard let arr = any as? [[String:Any]] else {
            return [[:]]
        }
        return arr
    }
}

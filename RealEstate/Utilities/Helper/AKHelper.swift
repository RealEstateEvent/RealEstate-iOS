 //
 //  AKHelper.swift
 //  MarketplaceMasterLuxury
 //
 //  Created by Ongraph on 12/03/20.
 //  Copyright © 2020 Ongraph. All rights reserved.
 //
 
 import Foundation
 import FTIndicator
 
 final class AKHelper {
    
    static func getDictionary(from any: Any?) -> [String:Any]? {
        guard let dict = any as? [String:Any] else {
            return nil
        }
        return dict
    }
    static func getArrayOfDict(from any: Any?) -> [[String:Any]]? {
        guard let arr = any as? [[String:Any]] else {
            return nil
        }
        return arr
    }
    
    static func showNotification(msg : String) {
        DispatchQueue.main.async {
            FTIndicator.showNotification(withTitle:kAppName , message: msg)
        }
    }
    
    
    static func timeIntervalString(startTimeStamp stTime:String,endTimeStamp  edTime : String)->String? {
        let dblStartTime = TimeInterval(stTime) ?? 0.0
        let dblEndTime = TimeInterval(edTime) ?? 0.0
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        let formatted = formatter.string(from: dblEndTime - dblStartTime)
        print("Formatted Time interval:\(formatted ?? "")")
        return formatted
    }
    
    
 }

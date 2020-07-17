//
//  ExtendedString.swift
//  Sail
//
//  Created by Amit Kumar on 29/10/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

extension String {
    static func getString(_ message : Any?)-> String {
        guard let str = message as? String else {
            guard let str = message as? NSNumber else {
                guard let str = message as? Bool else {
                    return ""
                }
                return str ? "1":"0"
            }
            return str.stringValue
        }
        return str
    }
    
    func convert(currentFormat : String, desiredFormat:String?) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = currentFormat
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        dateFormatter.dateFormat = desiredFormat ?? "yyyy-MM-dd"
        let newStringDate = dateFormatter.string(from: date)
        return newStringDate
    }
    
//    func isValidEmail() -> Bool {
//        // here, `try!` will always succeed because the pattern is valid
//        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
//        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
//    }
    
}


extension String {

    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }

    //Validate Email

    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    //validate Password
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil){

                if(self.count>=6 && self.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var toInt : Int? {
        return Int(self)
    }
    
    func getAttributedText(highlightedText : String )-> NSAttributedString {
        let strNumber: NSString = self as NSString
        let range = (strNumber).range(of: highlightedText)
        let attributedString = NSMutableAttributedString.init(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.customGoldenColor, range: range)
        return attributedString
    }
    
    func timeStampToDate()->Date? {
        if let dblTime = TimeInterval(self) {
            let date = Date.init(timeIntervalSince1970: dblTime)
            return date
        }
        return nil
    }
    
    func toStringDate(_ format: String = "MMM d")->String? {
        let date = self.timeStampToDate()
        let str = date?.toStringWith(format: format)
        return str
    }
    
}

//
//  AgoraChatManager.swift
//  AgoraChat
//
//  Created by Himanshu Goyal on 18/06/20.
//  Copyright © 2020 Himanshu. All rights reserved.
//

import Foundation
import UIKit
import AgoraRtmKit


enum LoginStatus {
    case online, offline
}

enum OneToOneMessageType {
    case normal, offline
}

class AgoraDetails: NSObject {
    static let id = "6c24e76a922840c4b8b31a3bf54069b9"
}

class AgoraRtm: NSObject {
    static let kit = AgoraRtmKit(appId: AgoraDetails.id, delegate: nil)
    static var current: String?
    static var status: LoginStatus = .offline
    static var oneToOneMessageType: OneToOneMessageType = .normal
    static var offlineMessages = [String: [AgoraRtmMessage]]()
    
    static func updateKit(delegate: AgoraRtmDelegate) {
        guard let kit = kit else {
            return
        }
        kit.agoraRtmDelegate = delegate
    }
    
    static func add(offlineMessage: AgoraRtmMessage, from user: String) {
        guard offlineMessage.isOfflineMessage else {
            return
        }
        var messageList: [AgoraRtmMessage]
        if let list = offlineMessages[user] {
            messageList = list
        } else {
            messageList = [AgoraRtmMessage]()
        }
        messageList.append(offlineMessage)
        offlineMessages[user] = messageList
    }
    
    static func getOfflineMessages(from user: String) -> [AgoraRtmMessage]? {
        return offlineMessages[user]
    }
    
    static func removeOfflineMessages(from user: String) {
        offlineMessages.removeValue(forKey: user)
    }
}

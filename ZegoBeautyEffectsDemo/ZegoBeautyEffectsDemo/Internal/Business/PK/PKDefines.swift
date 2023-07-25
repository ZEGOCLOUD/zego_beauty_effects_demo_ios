//
//  PKDefines.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/7/6.
//

import Foundation

public enum PKProtocolType: UInt, Codable {
    // start pk
    case startPK = 91000
    // end pk
    case endPK = 91001
    // resume pk
    case resume = 91002
}

public enum RoomPKState {
    case isNoPK
    case isRequestPK
    case isStartPK
}

enum SEIType: UInt {
    case deviceState
}

class PKInfo: NSObject {
    
    var pkUser: UserInfo
    var pkRoom: String
    
    var seq: Int = 0
    var hostUserID: String = ""
    
    init(user: UserInfo, pkRoom: String) {
        self.pkUser = user
        self.pkRoom = pkRoom
    }
    
    func getPKStreamID() -> String {
        return "\(pkRoom)_\(pkUser.id)_main_host"
    }
    
}

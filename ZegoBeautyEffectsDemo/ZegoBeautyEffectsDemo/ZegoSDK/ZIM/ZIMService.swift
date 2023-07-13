//
//  ZIMService.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by zego on 2023/4/28.
//

import Foundation
import UIKit
import ZIM

public class ZIMService: NSObject {
    
    public static let shared = ZIMService()
    
    var zim: ZIM? = nil
    var userInfo: ZIMUserInfo? = nil
    
    var currentRoom: ZIMRoomFullInfo? = nil
    
    let eventHandlers: NSHashTable<ZIMEventHandler> = NSHashTable(options: .weakMemory)
    
    override init() {
        super.init()
    }
    
    public func initWithAppID(_ appID: UInt32, appSign: String?) {
        let zimConfig: ZIMAppConfig = ZIMAppConfig()
        zimConfig.appID = appID
        zimConfig.appSign = appSign ?? ""
        self.zim = ZIM.shared()
        if self.zim == nil {
            self.zim = ZIM.create(with: zimConfig)
        }
        self.zim?.setEventHandler(self)
    }
    
    public func unInit() {
        
    }
    
    public func connectUser(userID: String,
                            userName: String,
                            token: String?,
                            callback: CommonCallback?) {
        let user = ZIMUserInfo()
        user.userID = userID
        user.userName = userName
        userInfo = user
        zim?.login(with: user, token: token ?? "") { error in
            callback?(Int(error.code.rawValue), error.message)
        }
    }
    
    public func disconnectUser() {
        zim?.logout()
    }
    

    public func addEventHandler(_ handler: ZIMEventHandler) {
        eventHandlers.add(handler)
    }
    
    public func renewToken(_ token: String, callback: CommonCallback?) {
        zim?.renewToken(token) { token, error in
            callback?(Int(error.code.rawValue), error.message)
        }
    }
}

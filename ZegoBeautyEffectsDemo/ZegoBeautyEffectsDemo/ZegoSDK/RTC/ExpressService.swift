//
//  ExpressService.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/3/31.
//

import Foundation
import ZegoExpressEngine

public class ExpressService: NSObject {
    
    public static let shared = ExpressService()
    
    public var localUser: UserInfo?
    
    let eventHandlers: NSHashTable<ExpressServiceDelegate> = NSHashTable(options: .weakMemory)
    
    public var isUsingFrontCamera: Bool = true
    
    public var roomID: String?
    
    public var isHost: Bool = false
    
    // StreamID: UserID 
    public var streamDict: [String: String] = [:]
    
    // UserID: UserInfo
    public var inRoomUserDict: [String: UserInfo] = [:]
    
    public var host: UserInfo? {
        inRoomUserDict.values.first(where: { $0.role == .host })
    }
    
    public func initWithAppID(appID: UInt32, appSign: String) {
        let profile = ZegoEngineProfile()
        profile.appID = appID
        profile.appSign = appSign
        profile.scenario = .default
        let config: ZegoEngineConfig = ZegoEngineConfig()
        config.advancedConfig = ["notify_remote_device_unknown_status": "true", "notify_remote_device_init_status":"true"]
        ZegoExpressEngine.setEngineConfig(config)
        ZegoExpressEngine.createEngine(with: profile, eventHandler: self)
    }
    
    public func unInit() {
        ZegoExpressEngine.destroy()
    }
    
    public func connectUser(userID: String,
                     userName: String? = nil) {
        let userName = userName ?? userID
        localUser = UserInfo(id: userID, name: userName)
        inRoomUserDict[userID] = localUser
    }
    
    public func disconnectUser() {
        localUser = nil
    }
    
    public func addEventHandler(_ handler: ExpressServiceDelegate) {
        eventHandlers.add(handler)
    }
}

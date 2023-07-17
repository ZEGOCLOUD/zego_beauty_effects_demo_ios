//
//  ZegoSDKManager.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/3/31.
//

import UIKit
import ZegoExpressEngine
import ZIM

public class ZegoSDKManager: NSObject {
    
    public static let shared = ZegoSDKManager()
    
    public var expressService = ExpressService.shared
    public var zimService = ZIMService.shared
    public var beautyService = ZegoEffectsService.shared
        
    public var localUser: UserInfo? {
        expressService.localUser
    }
    
    private var token: String? = nil
    
    private var appID: UInt32 = 0
    private var appSign: String = ""
    
    public func initWith(appID: UInt32, appSign: String, enableBeauty: Bool = false) {
        
        self.appID = appID
        self.appSign = appSign
        
        expressService.initWithAppID(appID: appID, appSign: appSign)
        zimService.initWithAppID(appID, appSign: appSign)
        
        if enableBeauty {
            beautyService.initWithAppID(appID: appID, appSign: appSign)
            enableCustomVideoProcessing()
        }
    }
    
    public func unInit() {
        expressService.unInit()
        zimService.unInit()
        beautyService.unInit()
    }
    
    public func connectUser(userID: String,
                            userName: String,
                            token: String? = nil,
                            callback: CommonCallback? = nil) {
        self.token = token
        expressService.connectUser(userID: userID,userName: userName)
        zimService.connectUser(userID: userID, userName: userName, token: token, callback:callback)
    }
    
    public func disconnectUser() {
        expressService.disconnectUser()
        zimService.disconnectUser()
    }
    
    public func joinRoom(_ roomID: String,
                         roomName: String? = nil,
                         isHost: Bool = false,
                         callback: CommonCallback? = nil) {
        self.expressService.joinRoom(roomID,isHost:isHost, token: token, callback: { code, message in
            if (code == 0) {
                self.zimService.joinRoom(roomID, roomName: roomName, callback:callback)
            } else {
                callback?(code, "joinRoom faild")
            }
        })
    }
    
    
    public func leaveRoom(callback: CommonCallback? = nil) {
        expressService.leaveRoom()
        zimService.leaveRoom(callback:callback)
    }
    
    public func enableCustomVideoProcessing() {
        let config = ZegoCustomVideoProcessConfig()
        config.bufferType = .cvPixelBuffer
        expressService.enableCustomVideoProcessing(true, config: config)
        expressService.setCustomVideoProcessHandler(self)
    }
}

extension ZegoSDKManager: ZegoCustomVideoProcessHandler {
    public func onStart(_ channel: ZegoPublishChannel) {
        let config = expressService.getVideoConfig()
        beautyService.initEnv(config.captureResolution)
    }
    
    public func onStop(_ channel: ZegoPublishChannel) {
        beautyService.uninitEnv()
    }
    
    public func onCapturedUnprocessedCVPixelBuffer(_ buffer: CVPixelBuffer, timestamp: CMTime, channel: ZegoPublishChannel) {
        beautyService.processImageBuffer(buffer)
        expressService.sendCustomVideoProcessedCVPixelBuffer(buffer,
                                                             timestamp: timestamp,
                                                             channel: channel)
    }
}

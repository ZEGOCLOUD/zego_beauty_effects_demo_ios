//
//  ExpressService+Room.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/4/3.
//

import Foundation
import ZegoExpressEngine

extension ExpressService {
    public func joinRoom(_ roomID: String,
                         isHost: Bool = false,
                         token: String? = nil,
                         callback: CommonCallback? = nil) {
        
        assert(localUser != nil, "Must login first.")
        
        localUser?.role = isHost ? .host : .audience
        
        self.roomID = roomID
        self.isHost = isHost
        
        let userID = localUser?.id ?? ""
        let userName = localUser?.name ?? ""
        let user = ZegoUser(userID: userID, userName: userName)
        
        // monitor sound level
        ZegoExpressEngine.shared().startSoundLevelMonitor(1000)
        
        let config = ZegoRoomConfig()
        config.isUserStatusNotify = true
        if let token = token {
            config.token = token
        }
        
        ZegoExpressEngine.shared().loginRoom(roomID, user: user, config: config) { error, data in
            if error == 0 {
                callback?(Int(error), "join room success.")
            } else {
                callback?(Int(error), "join room faild.")
            }
        };

    }
    
    public func leaveRoom() {
        roomID = nil
        inRoomUserDict.removeAll()
        streamDict.removeAll()
        stopPublishingStream()
        ZegoExpressEngine.shared().stopSoundLevelMonitor()
        ZegoExpressEngine.shared().logoutRoom()
    }
}

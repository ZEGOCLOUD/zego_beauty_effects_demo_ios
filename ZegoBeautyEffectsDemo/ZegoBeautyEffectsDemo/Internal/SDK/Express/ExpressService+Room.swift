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
                         token: String? = nil,
                         callback: CommonCallback? = nil) {
        
        assert(localUser != nil, "Must login first.")
        
        self.roomID = roomID
        
        let userID = localUser?.id ?? ""
        let userName = localUser?.name ?? ""
        let user = ZegoUser(userID: userID, userName: userName)
                
        let config = ZegoRoomConfig()
        config.isUserStatusNotify = true
        if let token = token {
            config.token = token
        }
        
        ZegoExpressEngine.shared().loginRoom(roomID, user: user, config: config) { [weak self] error, data in
            if error == 0 {
                self?.inRoomUserDict[userID] = self?.localUser
                // monitor sound level
                ZegoExpressEngine.shared().startSoundLevelMonitor(1000)                
                callback?(Int(error), "join room success.")
            } else {
                callback?(Int(error), "join room faild.")
            }
        };

    }
    
    public func leaveRoom() {
        roomID = nil
        stopPublishingStream()
        inRoomUserDict.removeAll()
        streamDict.removeAll()
        roomExtraInfoDict.removeAll()
        ZegoExpressEngine.shared().stopSoundLevelMonitor()
        ZegoExpressEngine.shared().logoutRoom()
    }
    
    public func setExpressRoomExtraInfo(key: String, value: String) {
        guard let roomID = roomID else { return }
        ZegoExpressEngine.shared().setRoomExtraInfo(value, forKey: key, roomID: roomID) { code in
            if code == 0 {
                var extraInfo: ZegoRoomExtraInfo? = self.roomExtraInfoDict[key]
                if extraInfo == nil {
                    extraInfo = ZegoRoomExtraInfo()
                    extraInfo?.key = key
                    extraInfo?.updateUser = ZegoUser(userID: self.localUser?.id ?? "", userName: self.localUser?.name ?? "")
                }
                extraInfo?.updateTime = self.getTimeStamp()
                extraInfo?.value = value
                self.roomExtraInfoDict.updateValue(extraInfo!, forKey: key)
                let extraInfoList: [ZegoRoomExtraInfo] = [extraInfo!]
                for delegate in self.eventHandlers.allObjects {
                    delegate.onRoomExtraInfoUpdate?(extraInfoList, roomID: roomID)
                }
            }
        }
    }
    
    private func getTimeStamp() -> UInt64 {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = UInt64(timeInterval)
        return timeStamp
    }
}

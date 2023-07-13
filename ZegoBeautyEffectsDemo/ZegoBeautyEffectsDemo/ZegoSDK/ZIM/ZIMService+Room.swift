//
//  ZIMService+Room.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/7/5.
//

import Foundation
import ZIM

extension ZIMService {
    public func joinRoom(_ roomID: String,
                         roomName: String?,
                         callback: CommonCallback? = nil) {
        
        let roomInfo = ZIMRoomInfo()
        roomInfo.roomID = roomID;
        roomInfo.roomName = roomName ?? roomID;
        
        zim?.enterRoom(with: roomInfo, config: ZIMRoomAdvancedConfig(), callback: { roomFullInfo, errorInfo in
            
            if (errorInfo.code.rawValue == 0) {
                self.currentRoom = roomFullInfo
            } else {
                self.currentRoom = nil
            }
            
            callback?(Int(errorInfo.code.rawValue), errorInfo.message)
        });
    }
    
    public func leaveRoom(callback: CommonCallback? = nil){
        guard let currentRoom = currentRoom else {
            callback?(0, "LeaveRoom Success.")
            return
        }
        
        zim?.leaveRoom(by: currentRoom.baseInfo.roomID, callback: { roomID, errorInfo in
            if(errorInfo.code.rawValue == 0){
                self.currentRoom = nil
            }
            callback?(Int(errorInfo.code.rawValue), errorInfo.message)
        })
    }
}

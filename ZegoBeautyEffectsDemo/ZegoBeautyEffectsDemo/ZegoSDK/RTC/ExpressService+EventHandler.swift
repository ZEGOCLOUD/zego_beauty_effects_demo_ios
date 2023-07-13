//
//  ExpressService+EventHandler.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/4/3.
//

import Foundation
import ZegoExpressEngine

extension ExpressService: ZegoEventHandler {
    public func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        
        for stream in streamList {
            var user = inRoomUserDict[stream.user.userID]
            if updateType == .add {
                streamDict[stream.streamID] = stream.user.userID
                if let user = user {
                    user.streamID = stream.streamID
                    user.name = stream.user.userName
                } else {
                    user = UserInfo(id: stream.user.userID, name: stream.user.userName)
                    user?.streamID = stream.streamID
                }
                inRoomUserDict[stream.user.userID] = user
            } else {
                streamDict.removeValue(forKey: stream.streamID)
                user?.streamID = nil
            }
        }
        
        for handler in eventHandlers.allObjects {
            handler.onRoomStreamUpdate?(updateType, streamList: streamList, extendedData: extendedData, roomID: roomID)
        }
    }
    
    public func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        if updateType == .add {
            for user in userList {
                let user = inRoomUserDict[user.userID] ?? UserInfo(id: user.userID, name: user.userName)
                user.streamID = streamDict.first(where: { $0.value == user.id })?.key
                inRoomUserDict[user.id] = user
            }
        } else {
            for user in userList {
                inRoomUserDict.removeValue(forKey: user.userID)
            }
        }
        for handler in eventHandlers.allObjects {
            handler.onRoomUserUpdate?(updateType, userList: userList, roomID: roomID)
        }
    }
    
    public func onRoomStateChanged(_ reason: ZegoRoomStateChangedReason, errorCode: Int32, extendedData: [AnyHashable : Any], roomID: String) {
        for handler in eventHandlers.allObjects {
            handler.onRoomStateChanged?(reason, errorCode: errorCode, extendedData: extendedData, roomID: roomID)
        }
    }
    
    public func onRoomOnlineUserCountUpdate(_ count: Int32, roomID: String) {
        for handler in eventHandlers.allObjects {
            handler.onRoomOnlineUserCountUpdate?(count, roomID: roomID)
        }
    }
    
    public func onIMRecvCustomCommand(_ command: String, from fromUser: ZegoUser, roomID: String) {
        for handler in eventHandlers.allObjects {
            handler.onIMRecvCustomCommand?(command, from: fromUser, roomID: roomID)
        }
    }
    
    public func onRoomStreamExtraInfoUpdate(_ streamList: [ZegoStream], roomID: String) {
        
        for stream in streamList {
            let userID = stream.user.userID
            let info = stream.extraInfo.toDict
            guard let user = inRoomUserDict[userID] else {
                continue
            }
            if let isCameraOpen = info?["cam"] as? Bool {
                user.isCameraOpen = isCameraOpen
                for handler in eventHandlers.allObjects {
                    handler.onCameraOpen?(userID, isCameraOpen: isCameraOpen)
                }
            }
            
            if let isMicOpen = info?["mic"] as? Bool {
                user.isMicrophoneOpen = isMicOpen
                for handler in eventHandlers.allObjects {
                    handler.onMicrophoneOpen?(userID, isMicOpen: isMicOpen)
                }
            }
        }
        
        for handler in eventHandlers.allObjects {
            handler.onRoomStreamExtraInfoUpdate?(streamList, roomID: roomID)
        }
    }
    
    public func onRemoteCameraStateUpdate(_ state: ZegoRemoteDeviceState, streamID: String) {
        let userID = streamDict[streamID]
        if let userID = userID {
            let user = inRoomUserDict[userID]
            user?.isCameraOpen = state == .open
        }
        
        for handler in eventHandlers.allObjects {
            if let userID = userID {
                handler.onCameraOpen?(userID, isCameraOpen: state == .open)
            }
            handler.onRemoteCameraStateUpdate?(state, streamID: streamID)
        }
    }
    
    public func onRemoteMicStateUpdate(_ state: ZegoRemoteDeviceState, streamID: String) {
        let userID = streamDict[streamID]
        if let userID = userID {
            let user = inRoomUserDict[userID]
            user?.isMicrophoneOpen = state == .open
        }
        
        for handler in eventHandlers.allObjects {
            if let userID = userID {
                handler.onMicrophoneOpen?(userID, isMicOpen: state == .open)
            }
            handler.onRemoteMicStateUpdate?(state, streamID: streamID)
        }
    }
    
    public func onAudioRouteChange(_ audioRoute: ZegoAudioRoute) {
        for handler in eventHandlers.allObjects {
            handler.onAudioRouteChange?(audioRoute)
        }
    }
    
    public func onRemoteSoundLevelUpdate(_ soundLevels: [String : NSNumber]) {
        for handler in eventHandlers.allObjects {
            handler.onRemoteSoundLevelUpdate?(soundLevels)
        }
    }
    
    public func onCapturedSoundLevelUpdate(_ soundLevel: NSNumber) {
        for handler in eventHandlers.allObjects {
            handler.onCapturedSoundLevelUpdate?(soundLevel)
        }
    }
}

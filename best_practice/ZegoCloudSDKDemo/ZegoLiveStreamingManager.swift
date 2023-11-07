//
//  ZegoLiveStreamingManager.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/5/30.
//

import UIKit
import ZIM
import ZegoExpressEngine

@objc protocol ZegoLiveStreamingManagerDelegate: AnyObject {
    
    @objc optional func onRoomStreamAdd(streamList: [ZegoStream])
    @objc optional func onRoomStreamDelete(streamList: [ZegoStream])
    @objc optional func onRoomUserAdd(userList: [ZegoUser])
    @objc optional func onRoomUserDelete(userList: [ZegoUser])
    @objc optional func onCameraOpen(_ userID: String, isCameraOpen: Bool)
    @objc optional func onMicrophoneOpen(_ userID: String, isMicOpen: Bool)
    
    @objc optional func onReceiveRoomMessage(messageList: [ZIMMessage])
    
    @objc optional func getMixLayoutConfig(streamList: [String], videoConfig: ZegoMixerVideoConfig) -> [ZegoMixerInput]
    
}

class ZegoLiveStreamingManager: NSObject {
    
    static let shared = ZegoLiveStreamingManager()
    let eventDelegates: NSHashTable<ZegoLiveStreamingManagerDelegate> = NSHashTable(options: .weakMemory)
    
    var isLiveStart: Bool = false
    
    var pkService: PKService?
    var coHostService: CoHostService?
    var pkInfo: PKInfo? {
        get {
            return pkService?.pkInfo
        }
    }
    
    var isPKStarted: Bool {
        get {
            return pkService?.isPKStarted ?? false
        }
    }
    
    var hostUser: ZegoSDKUser? {
        get {
            return coHostService?.hostUser
        }
        set {
            coHostService?.hostUser = newValue
        }
    }
    
    override init() {
        super.init()
        ZegoSDKManager.shared.expressService.addEventHandler(self)
    }
    
    func addUserLoginListeners() {
        pkService = PKService()
        coHostService = CoHostService()
    }
    
    func addPKDelegate(_ delegate: PKServiceDelegate) {
        pkService?.addPKDelegate(delegate)
    }
    
    func addDelegate(_ delegate: ZegoLiveStreamingManagerDelegate) {
        eventDelegates.add(delegate)
    }
    
    func leaveRoom() {
        if isLocalUserHost() {
            quitPKBattle()
        }
        ZegoSDKManager.shared.logoutRoom()
        clearData()
    }
    
    func clearData()  {
        coHostService?.clearData()
        pkService?.clearData()
    }
    
    func getMixLayoutConfig(streamList: [String], videoConfig: ZegoMixerVideoConfig) -> [ZegoMixerInput]? {
        var inputList: [ZegoMixerInput]?
        for delegate in eventDelegates.allObjects {
            inputList = delegate.getMixLayoutConfig?(streamList: streamList, videoConfig: videoConfig)
        }
        return inputList
    }
    
}
    


extension ZegoLiveStreamingManager {
    
    func startPKBattle(anotherHostID: String, callback: UserRequestCallback?) {
        pkService?.startPKBattle(targetUserIDList: [anotherHostID], callback: callback)
    }

    func startPKBattle(anotherHostIDList: [String], callback: UserRequestCallback?) {
        pkService?.startPKBattle(targetUserIDList: anotherHostIDList, callback: callback)
    }
    
    func invitePKBattle(targetUserID: String, callback: UserRequestCallback?) {
        pkService?.invitePKbattle(targetUserIDList: [targetUserID], callback: callback)
    }
    
    func invitePKbattle(targetUserIDList: [String], callback: UserRequestCallback?) {
        pkService?.invitePKbattle(targetUserIDList: targetUserIDList, callback: callback)
    }
    
    func cancelPKBattleRequest(requestID: String, targetUserID: String) {
        pkService?.cancelPKBattle(requestID: requestID, userID: targetUserID)
    }
    
    func acceptPKStartRequest(requestID: String) {
        pkService?.acceptPKBattle(requestID: requestID)
    }
    
    func rejectPKStartRequest(requestID: String) {
        pkService?.rejectPKBattle(requestID: requestID)
    }
    
    func removePKBattle(userID: String) {
        pkService?.removePKBattle(userID: userID)
    }
    
    func endPKBattle() {
        if let pkInfo = pkService?.pkInfo {
            pkService?.endPKBattle(requestID: pkInfo.requestID, callback: nil)
            pkService?.stopPKBattles()
        }
    }
    
    func quitPKBattle() {
        if let pkInfo = pkService?.pkInfo {
            pkService?.quitPKBattle(requestID: pkInfo.requestID, callback: nil)
            pkService?.stopPKBattles()
        }
    }
    
    func isLocalUserHost() -> Bool {
        return coHostService?.isLocalUserHost() ?? false
    }
    
    func isHost(userID: String) -> Bool {
        return coHostService?.isHost(userID) ?? false
    }

    func isCoHost(userID: String) -> Bool {
        return coHostService?.isCoHost(userID) ?? false
    }

    func isAudience(userID: String) -> Bool {
        return coHostService?.isAudience(userID) ?? false
    }
    
    func getHostMainStreamID() -> String {
        return "\(ZegoSDKManager.shared.expressService.currentRoomID ?? "")_\(ZegoSDKManager.shared.currentUser?.id ?? "")_main_host"
    }
    
    func getCoHostMainStreamID() -> String {
        return "\(ZegoSDKManager.shared.expressService.currentRoomID ?? "")_\(ZegoSDKManager.shared.currentUser?.id ?? "")_main_cohost"
    }
    
    func isPKUser(userID: String) -> Bool {
        return pkService?.isPKUser(userID: userID) ?? false
    }
    
    func isPKUserMuted(userID: String) -> Bool {
        return pkService?.isPKUserMuted(userID: userID) ?? false
    }
    
    func mutePKUser(muteUserList: [String], mute: Bool, callback: ZegoMixerStartCallback?) {
        if let pkInfo = pkInfo,
           let pkService = pkService
        {
            var muteIndexs: [Int] = []
            for muteUserID in muteUserList {
                let pkUser = pkService.getPKUser(pkBattleInfo: pkInfo, userID: muteUserID)
                var i = 0
                for input in pkService.currentInputList {
                    if input.streamID == pkUser?.pkUserStream {
                        muteIndexs.append(i)
                    }
                    i = i + 1
                }
            }
            pkService.mutePKUser(muteIndexList: muteIndexs, mute: mute, callback: callback)
        }
    }
}

extension ZegoLiveStreamingManager: ExpressServiceDelegate {
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        if updateType == .add {
            for delegate in eventDelegates.allObjects {
                delegate.onRoomStreamAdd?(streamList: streamList)
            }
            for stream in streamList {
                let extraInfoDict = stream.extraInfo.toDict
                let isCameraOpen: Bool = extraInfoDict?["cam"] as! Bool
                let isMicOpen: Bool = extraInfoDict?["mic"] as! Bool
                for delegate in eventDelegates.allObjects {
                    delegate.onCameraOpen?(stream.user.userID, isCameraOpen: isCameraOpen)
                    delegate.onMicrophoneOpen?(stream.user.userID, isMicOpen: isMicOpen)
                }
            }
        } else {
            for delegate in eventDelegates.allObjects {
                delegate.onRoomStreamDelete?(streamList: streamList)
            }
        }
    }
    
    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        if updateType == .add {
            for delegate in eventDelegates.allObjects {
                delegate.onRoomUserAdd?(userList: userList)
            }
        } else {
            for delegate in eventDelegates.allObjects {
                delegate.onRoomUserDelete?(userList: userList)
            }
        }
    }
    
    func onCameraOpen(_ userID: String, isCameraOpen: Bool) {
        for delegate in eventDelegates.allObjects {
            delegate.onCameraOpen?(userID, isCameraOpen: isCameraOpen)
        }
    }
    
    func onMicrophoneOpen(_ userID: String, isMicOpen: Bool) {
        print("onMicrophoneOpen, userID: \(userID), isMicOpen: \(isMicOpen)")
        for delegate in eventDelegates.allObjects {
            delegate.onMicrophoneOpen?(userID, isMicOpen: isMicOpen)
        }
    }
    
    func onCapturedSoundLevelUpdate(_ soundLevel: NSNumber) {
        
    }
    
    func onRemoteSoundLevelUpdate(_ soundLevels: [String : NSNumber]) {
        
    }
    
}

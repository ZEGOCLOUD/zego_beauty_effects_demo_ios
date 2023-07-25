//
//  PKService.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/7/6.
//

import UIKit
import ZIM
import ZegoExpressEngine

@objc protocol PKServiceDelegate: AnyObject {
    
    @objc optional func onIncomingPKRequestReceived(requestID: String)
    @objc optional func onIncomingResumePKRequestReceived(requestID: String)
    @objc optional func onIncomingPKRequestCancelled()
    @objc optional func onOutgoingPKRequestAccepted()
    @objc optional func onOutgoingPKRequestRejected()
    @objc optional func onIncomingPKRequestTimeout()
    @objc optional func onOutgoingPKRequestTimeout()
    
    @objc optional func onPKStarted(roomID: String, userID: String)
    @objc optional func onPKEnded(roomID: String, userID: String)
    @objc optional func onPKViewAvaliable()
    
    @objc optional func onLocalHostCameraStatus(isOn: Bool)
    @objc optional func onAnotherHostCameraStatus(isOn: Bool)
    
    @objc optional func onAntoherHostIsReconnecting()
    @objc optional func onAntoherHostIsConnected()
    @objc optional func onHostIsReconnecting()
    @objc optional func onHostIsConnected()
    
    @objc optional func onMixerStreamTaskFail(errorCode: Int)
    @objc optional func onStartPlayMixerStream()
    @objc optional func onStopPlayMixerStream()
}



class PKService: NSObject {
    
    var pkInfo: PKInfo?
    
    var roomPKState: RoomPKState = .isNoPK
    var pkRoomAttribute: [String: String] = [:]
    
    var seiTimer: Timer?
    var checkSEITimer: Timer?
    var seiDict: [String: Any] = [:]
    var isLiveStart: Bool {
        get {
            return ZegoLiveStreamingManager.shared.isLiveStart
        }
    }
    var isMuteAnotherHostAudio = false
    
    var currentPkInvitation: PKInvitation?
    let eventDelegates: NSHashTable<PKServiceDelegate> = NSHashTable(options: .weakMemory)
    let liveManager = ZegoLiveStreamingManager.shared
    
    override init() {
        super.init()
        ZegoSDKManager.shared.expressService.addEventHandler(self)
        ZegoSDKManager.shared.zimService.addEventHandler(self)
    }
    
    func addPKDelegate(_ delegate: PKServiceDelegate) {
        eventDelegates.add(delegate)
    }
    
    func sendPKBattlesStartRequest(userID: String, callback: CommonCallback?) {
        let requestData: [String: AnyObject] = [
            "room_id": ZegoSDKManager.shared.expressService.roomID as AnyObject,
            "user_name": ZegoSDKManager.shared.localUser?.name as AnyObject,
            "type" : PKProtocolType.startPK.rawValue as AnyObject
        ]
        roomPKState = .isRequestPK
        ZegoSDKManager.shared.zimService.sendUserRequest(userList: [userID], extendedData: requestData.jsonString) { code, requestID, errorInvitees in
            var errorMessage: String = ""
            if code == 0 && !errorInvitees.contains(userID) {
                self.currentPkInvitation = PKInvitation()
                self.currentPkInvitation?.roomID = ZegoSDKManager.shared.expressService.roomID
                self.currentPkInvitation?.requestID = requestID
                self.currentPkInvitation?.inviterName = ZegoSDKManager.shared.localUser?.name ?? ""
                self.currentPkInvitation?.inviterID = ZegoSDKManager.shared.localUser?.id ?? ""
                self.currentPkInvitation?.invitee = [userID]
            } else {
                self.roomPKState = .isNoPK
                errorMessage = "send pk request fail"
            }
            guard let callback = callback else { return }
            callback(Int(code), errorMessage)
        }
    }
    
    func sendPKBattleResumeRequest(userID: String) {
        let requestData: [String: AnyObject] = [
            "room_id": ZegoSDKManager.shared.expressService.roomID as AnyObject,
            "user_name": ZegoSDKManager.shared.localUser?.name as AnyObject,
            "type" : PKProtocolType.resume.rawValue as AnyObject
        ]
        roomPKState = .isRequestPK
        ZegoSDKManager.shared.zimService.sendUserRequest(userList: [userID], extendedData: requestData.jsonString) { code, requestID, errorInvitees in
            if code == 0 {
                self.currentPkInvitation = PKInvitation()
                self.currentPkInvitation?.roomID = ZegoSDKManager.shared.expressService.roomID
                self.currentPkInvitation?.requestID = requestID
                self.currentPkInvitation?.inviterName = ZegoSDKManager.shared.localUser?.name ?? ""
                self.currentPkInvitation?.inviterID = ZegoSDKManager.shared.localUser?.id ?? ""
                self.currentPkInvitation?.invitee = [userID]
            } else {
                self.roomPKState = .isNoPK
            }
        }
    }
    
    func sendPKBattlesStopRequest() {
        if roomPKState != .isStartPK { return }
        guard let pkInfo = pkInfo else { return }
        let requestData: [String: AnyObject] = [
            "room_id": ZegoSDKManager.shared.expressService.roomID as AnyObject,
            "user_name": ZegoSDKManager.shared.localUser?.name as AnyObject,
            "type" : PKProtocolType.endPK.rawValue as AnyObject
        ]
        ZegoSDKManager.shared.zimService.sendUserRequest(userList: [pkInfo.pkUser.id], extendedData: requestData.jsonString, callback: nil)
        stopPKBattles()
        currentPkInvitation = nil
        isMuteAnotherHostAudio = false
        for delegate in eventDelegates.allObjects {
            delegate.onPKEnded?(roomID: self.currentPkInvitation?.roomID ?? "", userID: self.currentPkInvitation?.invitee.first ?? "")
        }
    }
    
    func cancelPKBattleRequest() {
        guard let currentPkInvitation = currentPkInvitation else { return }
        roomPKState = .isNoPK
        ZegoSDKManager.shared.zimService.cancelUserRequest(requestID: currentPkInvitation.requestID ?? "",extendedData: "", userList: currentPkInvitation.invitee, callback: nil)
        self.currentPkInvitation = nil
    }
    
    func acceptPKStartRequest(requestID: String) {
        let requestData: [String: AnyObject] = [
            "room_id": ZegoSDKManager.shared.expressService.roomID as AnyObject,
            "user_name": ZegoSDKManager.shared.localUser?.name as AnyObject,
            "type": PKProtocolType.startPK.rawValue as AnyObject
        ]
        ZegoSDKManager.shared.zimService.acceptUserRequest(requestID:requestID, extendedData: requestData.jsonString) { code, requestID in
            if code == 0 {
                self.startPKBatlteWith(roomID: self.currentPkInvitation?.roomID ?? "", userID: self.currentPkInvitation?.inviterID ?? "", userName: self.currentPkInvitation?.inviterName ?? "")
            }
        }
    }
    
    func acceptPKResumeRequest(requestID: String) {
        let requestData: [String: AnyObject] = [
            "room_id": ZegoSDKManager.shared.expressService.roomID as AnyObject,
            "user_name": ZegoSDKManager.shared.localUser?.name as AnyObject,
            "type": PKProtocolType.resume.rawValue as AnyObject
        ]
        ZegoSDKManager.shared.zimService.acceptUserRequest(requestID:requestID, extendedData: requestData.jsonString, callback: nil)
    }
    
    func acceptPKStopRequest(requestID: String) {
        currentPkInvitation = nil
        let requestData: [String: AnyObject] = [
            "room_id": ZegoSDKManager.shared.expressService.roomID as AnyObject,
            "user_name": ZegoSDKManager.shared.localUser?.name as AnyObject,
            "type": PKProtocolType.endPK.rawValue as AnyObject
        ]
        ZegoSDKManager.shared.zimService.acceptUserRequest(requestID:requestID, extendedData: requestData.jsonString, callback: nil)
    }
    
    func rejectPKStartRequest(requestID: String) {
        let requestData: [String: AnyObject] = [
            "type": PKProtocolType.startPK.rawValue as AnyObject
        ]
        ZegoSDKManager.shared.zimService.refuseUserRequest(requestID: requestID, extendedData: requestData.jsonString) { code, requestID in
            if code == 0 {
                if requestID == self.currentPkInvitation?.requestID {
                    self.currentPkInvitation = nil
                }
            }
        }
    }
    
    func rejectPKResumeRequest(requestID: String) {
        let requestData: [String: AnyObject] = [
            "type": PKProtocolType.resume.rawValue as AnyObject
        ]
        ZegoSDKManager.shared.zimService.refuseUserRequest(requestID: requestID, extendedData: requestData.jsonString) { code, requestID in
            if code == 0 {
                if requestID == self.currentPkInvitation?.requestID {
                    self.currentPkInvitation = nil
                }
            }
        }
    }
    
    func startPKBatlteWith(roomID: String, userID: String, userName: String) {
        pkInfo = PKInfo(user: UserInfo(id: userID, name: userName), pkRoom: roomID)
        pkInfo!.seq = pkInfo!.seq + 1
        roomPKState = .isStartPK
        startMixStreamTask(leftContentType: .video, rightContentType: .video) { errorCode, mixerInfo in
            if errorCode == 0 {
                //set room attribute
                self.pkRoomAttribute["host"] = ZegoSDKManager.shared.localUser?.id
                self.pkRoomAttribute["pk_room"] = roomID
                self.pkRoomAttribute["pk_user_id"] = userID
                self.pkRoomAttribute["pk_user_name"] = userName
                self.pkRoomAttribute["pk_seq"] = "\(self.pkInfo!.seq)"
                ZegoSDKManager.shared.zimService.setRoomAttributes(self.pkRoomAttribute, isDeleteAfterOwnerLeft: false, callback: nil)
                self.createSEITimer()
                self.createCheckSERTimer()
                for delegate in self.eventDelegates.allObjects {
                    delegate.onPKStarted?(roomID: roomID, userID: userID)
                }
            } else {
                for delegate in self.eventDelegates.allObjects {
                    delegate.onMixerStreamTaskFail?(errorCode: Int(errorCode))
                }
            }
        }
    }
    
    func stopPKBattles() {
        guard let pkInfo = pkInfo else { return }
        roomPKState = .isNoPK
        ZegoSDKManager.shared.expressService.stopMixerTask()
        ZegoSDKManager.shared.expressService.stopPlayingStream(pkInfo.getPKStreamID())
        delectPKAttributes()
        destoryTimer()
    }
    
    func startMixStreamTask(leftContentType: ZegoMixerInputContentType, rightContentType: ZegoMixerInputContentType, callback: ZegoMixerStartCallback?) {
        guard let currentRoomID = ZegoSDKManager.shared.expressService.roomID,
              let localUserID = ZegoSDKManager.shared.localUser?.id,
              let pkInfo = pkInfo
        else { return }
        //play another host stream
        let localStreamID = currentRoomID + "_" + localUserID + "_main" + "_host"
        // start mixer task
        ZegoSDKManager.shared.expressService.startMixerTask(leftStreamID: localStreamID, rightStreamID: pkInfo.getPKStreamID(), leftContentType: leftContentType, rightContentType: rightContentType, callback: callback)
    }
    
    func delectPKAttributes() {
        var deleteKeys: [String] = []
        pkRoomAttribute.forEach { (key, _) in
            deleteKeys.append(key)
        }
        ZegoSDKManager.shared.zimService.deletedRoomAttributes(deleteKeys, callback: nil)
    }
    
    func muteAnotherHostAudio(mute: Bool) {
        if (isMuteAnotherHostAudio != mute) {
            guard let pkInfo = pkInfo else { return }
            startMixStreamTask(leftContentType: .video, rightContentType: mute ? .videoOnly : .video,callback: nil)
            ZegoSDKManager.shared.expressService.mutePlayStreamAudio(streamID: pkInfo.getPKStreamID(), mute: mute)
            isMuteAnotherHostAudio = mute
        }
    }
    
    func createSEITimer() {
        seiTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
            let dict: [String : Any] = ["type": SEIType.deviceState.rawValue, "sender_id": ZegoSDKManager.shared.localUser?.id ?? "", "mic": ZegoSDKManager.shared.expressService.localUser?.isMicrophoneOpen ?? true, "cam": ZegoSDKManager.shared.localUser?.isCameraOpen ?? true]
            guard let seiData = dict.jsonData else { return }
            ZegoSDKManager.shared.expressService.sendSEI(seiData)
        })
    }
    
    func createCheckSERTimer() {
        checkSEITimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            let currentTimer = Int(Date().timeIntervalSince1970)
            var isFindAnotherHostKey: Bool = false
            self.seiDict.forEach { (key, value) in
                
                let cameraStatus: Bool = (value as! Dictionary<String, Any>)["cam"] as! Bool
                if key == self.pkInfo?.pkUser.id {
                    isFindAnotherHostKey = true
                    for delegate in self.eventDelegates.allObjects {
                        delegate.onAnotherHostCameraStatus?(isOn: cameraStatus)
                    }
                } else {
                    for delegate in self.eventDelegates.allObjects {
                        delegate.onLocalHostCameraStatus?(isOn: cameraStatus)
                    }
                }
                
                let lastTime = (value as! Dictionary<String, Any>)["time"] as! Int
                if currentTimer - lastTime >= 5 {
                    if key == self.pkInfo?.pkUser.id {
                        for delegate in self.eventDelegates.allObjects {
                            delegate.onAntoherHostIsReconnecting?()
                        }
                    } else {
                        for delegate in self.eventDelegates.allObjects {
                            delegate.onHostIsReconnecting?()
                        }
                    }
                } else {
                    if key == self.pkInfo?.pkUser.id {
                        for delegate in self.eventDelegates.allObjects {
                            delegate.onAntoherHostIsConnected?()
                        }
                    } else {
                        for delegate in self.eventDelegates.allObjects {
                            delegate.onHostIsConnected?()
                        }
                    }
                }
            }
            if !isFindAnotherHostKey {
                for delegate in self.eventDelegates.allObjects {
                    delegate.onAntoherHostIsReconnecting?()
                }
            }
        })
    }
    
    func destoryTimer() {
        seiTimer?.invalidate()
        seiTimer = nil
        checkSEITimer?.invalidate()
        checkSEITimer = nil
    }
    
    func clearData() {
        destoryTimer()
        seiDict.removeAll()
        pkRoomAttribute.removeAll()
        pkInfo = nil
        roomPKState = .isNoPK
        currentPkInvitation = nil
        isMuteAnotherHostAudio = false
    }
}

extension PKService: ExpressServiceDelegate {
    
    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        if updateType == .delete {
            if liveManager.hostUser?.id == nil && roomPKState == .isStartPK && liveManager.isLocalUserHost() {
                roomPKState = .isNoPK
                for delegate in eventDelegates.allObjects {
                    delegate.onPKEnded?(roomID: pkInfo?.pkRoom ?? "", userID: pkInfo?.pkUser.id ?? "")
                    delegate.onStopPlayMixerStream?()
                }
                destoryTimer()
            }
        }
    }
    
    func onPlayerRecvAudioFirstFrame(_ streamID: String) {
        if streamID.contains("_mix") {
            muteMainStream()
            for delegate in eventDelegates.allObjects {
                delegate.onPKViewAvaliable?()
            }
        }
    }
    
    func onPlayerRecvVideoFirstFrame(_ streamID: String) {
        if streamID.contains("_mix") {
            muteMainStream()
            for delegate in eventDelegates.allObjects {
                delegate.onPKViewAvaliable?()
            }
        }
    }
    
    func muteMainStream() {
        ZegoSDKManager.shared.expressService.streamDict.forEach { (key, value) in
            if key.hasPrefix("_host") {
                ZegoSDKManager.shared.expressService.mutePlayStreamAudio(streamID: key, mute: true)
                ZegoSDKManager.shared.expressService.mutePlayStreamVideo(streamID: key, mute: true)
            }
        }
    }
    
    func onPlayerSyncRecvSEI(_ data: Data, streamID: String) {
        var seiData = data.toDict
        seiData?["time"] = Int(Date().timeIntervalSince1970)
        let key = seiData?["sender_id"] as? String ?? ""
        seiDict.updateValue(seiData ?? [:], forKey: key)
    }
    
    func isPKBusiness(type: Int) -> Bool {
        if type == PKProtocolType.startPK.rawValue || type == PKProtocolType.resume.rawValue || type == PKProtocolType.endPK.rawValue {
            return true
        }
        return false
    }
    
}

extension PKService: ZIMServiceDelegate {
    
    func zim(_ zim: ZIM, roomAttributesUpdated updateInfo: ZIMRoomAttributesUpdateInfo, roomID: String) {
        if updateInfo.action == .set {
            
            let tempAnotherHost: String = pkInfo?.pkUser.id ?? ""
            let tempAnotherHostRoomID : String = pkInfo?.pkRoom ?? ""
            
            pkInfo = PKInfo(user: UserInfo(id: updateInfo.roomAttributes["pk_user_id"] ?? "", name: updateInfo.roomAttributes["pk_user_name"] ?? ""), pkRoom: updateInfo.roomAttributes["pk_room"] ?? "")
            pkInfo?.seq = Int(updateInfo.roomAttributes["pk_seq"] ?? "0") ?? 0
            pkInfo?.hostUserID = updateInfo.roomAttributes["host"] ?? ""
            
            if pkInfo!.pkUser.id.count > 0 && pkInfo!.pkRoom.count > 0 {
                if liveManager.isLocalUserHost() {
                    //resume pk
                    if pkRoomAttribute.isEmpty {
                        sendPKBattleResumeRequest(userID: pkInfo?.pkUser.id ?? "")
                    }
                    pkRoomAttribute["host"] = pkInfo?.hostUserID ?? ""
                    pkRoomAttribute["pk_room"] = pkInfo?.pkRoom ?? ""
                    pkRoomAttribute["pk_user_id"] = pkInfo?.pkUser.id ?? ""
                    pkRoomAttribute["pk_user_name"] = pkInfo?.pkUser.name ?? ""
                    pkRoomAttribute["pk_seq"] =  "\(pkInfo?.seq ?? 0)"
                    
                } else {
                    //play mixer
                    roomPKState = .isStartPK
                    for delegate in eventDelegates.allObjects {
                        delegate.onPKStarted?(roomID: pkInfo?.pkRoom ?? "", userID: pkInfo?.pkUser.id ?? "")
                        delegate.onStartPlayMixerStream?()
                    }
                    createCheckSERTimer()
                }
            } else {
                for delegate in eventDelegates.allObjects {
                    delegate.onPKEnded?(roomID: tempAnotherHostRoomID, userID: tempAnotherHost)
                    delegate.onStopPlayMixerStream?()
                }
                clearData()
            }
            
        } else {
            for delegate in eventDelegates.allObjects {
                delegate.onPKEnded?(roomID: pkInfo?.pkRoom ?? "", userID: pkInfo?.pkUser.id ?? "")
                delegate.onStopPlayMixerStream?()
            }
            clearData()
        }
    }
    
    // pk invitation
    func onInComingUserRequestReceived(requestID: String, inviter: String, extendedData: String) {
        guard let invitationData = extendedData.toDict else { return }
        let pkInvitation = PKInvitation()
        let type: Int = invitationData["type"] as! Int
        let pkType: PKProtocolType? = PKProtocolType(rawValue: UInt(type))
        if let pkType = pkType,
           !isPKBusiness(type: Int(pkType.rawValue))
        {
            return
        }
        if  pkType == .startPK {
            if !isLiveStart || roomPKState == .isStartPK || roomPKState == .isRequestPK || currentPkInvitation != nil{
                rejectPKStartRequest(requestID: requestID)
                return
            }
            pkInvitation.requestID = requestID
            pkInvitation.roomID = invitationData["room_id"] as? String
            pkInvitation.inviterName = invitationData["user_name"] as? String
            pkInvitation.inviterID = inviter
            currentPkInvitation = pkInvitation
            for delegate in eventDelegates.allObjects {
                delegate.onIncomingPKRequestReceived?(requestID: requestID)
            }
        } else if pkType == .endPK {
            acceptPKStopRequest(requestID: requestID)
            stopPKBattles()
        } else if pkType == .resume {
            if roomPKState != .isStartPK || !liveManager.isLocalUserHost() || !isLiveStart {
                rejectPKResumeRequest(requestID: requestID)
            } else {
                acceptPKResumeRequest(requestID: requestID)
            }
        }
    }
    
    func onOutgoingUserRequestAccepted(requestID: String, invitee: String, extendedData: String) {
        guard let invitationData = extendedData.toDict else { return }
        let roomID = (invitationData["room_id"] ?? "") as! String
        let userName = (invitationData["user_name"] ?? "") as! String
        let type: Int = invitationData["type"] as! Int
        let pkType: PKProtocolType? = PKProtocolType(rawValue: UInt(type))
        if requestID == currentPkInvitation?.requestID {
            if pkType == .startPK || pkType == .resume {
                startPKBatlteWith(roomID: roomID, userID: currentPkInvitation?.invitee.first ?? "", userName: userName)
                for delegate in eventDelegates.allObjects {
                    delegate.onOutgoingPKRequestAccepted?()
                }
            }
        }
    }
    
    
    func onOutgoingUserRequestRejected(requestID: String, invitee: String, extendedData: String) {
        if currentPkInvitation?.requestID == requestID {
            currentPkInvitation = nil
            roomPKState = .isNoPK
            delectPKAttributes()
            for delegate in eventDelegates.allObjects {
                delegate.onOutgoingPKRequestRejected?()
            }
        }
    }
    
    func onInComingUserRequestCancelled(requestID: String, inviter: String, extendedData: String) {
        if requestID == currentPkInvitation?.requestID {
            currentPkInvitation = nil
            for delegate in eventDelegates.allObjects {
                delegate.onIncomingPKRequestCancelled?()
            }
        }
    }
    
    func onInComingUserRequestTimeout(requestID: String) {
        if requestID == currentPkInvitation?.requestID {
            currentPkInvitation = nil
            for delegate in eventDelegates.allObjects {
                delegate.onIncomingPKRequestTimeout?()
            }
        }
    }
    
    func onOutgoingUserRequestTimeout(requestID: String) {
        if requestID == currentPkInvitation?.requestID {
            currentPkInvitation = nil
            roomPKState = .isNoPK
            for delegate in eventDelegates.allObjects {
                delegate.onOutgoingPKRequestTimeout?()
            }
        }
    }
    
}

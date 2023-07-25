//
//  ZegoCallDataManager.swift
//  ZegoCallWithInvitationDemo
//
//  Created by zego on 2023/3/13.
//

import UIKit

@objc public protocol ZegoCallManagerDelegate: AnyObject {
    
    @objc optional func onInComingUserRequestTimeout(requestID: String)
    @objc optional func onInComingUserRequestCancelled(requestID: String, inviter: String, extendedData: String)
    @objc optional func onOutgoingUserRequestTimeout(requestID: String)
    @objc optional func onOutgoingUserRequestAccepted(requestID: String, invitee: String, extendedData: String)
    @objc optional func onOutgoingUserRequestRejected(requestID: String, invitee: String, extendedData: String)
    @objc optional func onInComingUserRequestReceived(requestID: String, inviter: String, extendedData: String)
}

class ZegoCallManager: NSObject {
    
    static let shared = ZegoCallManager()
    
    var currentCallData: ZegoCallDataModel?
    
    let callEventHandlers: NSHashTable<ZegoCallManagerDelegate> = NSHashTable(options: .weakMemory)
    
    override init() {
        super.init()
        ZegoSDKManager.shared.zimService.addEventHandler(self)
    }
    
    func addCallEventHandler(_ handler: ZegoCallManagerDelegate) {
        callEventHandlers.add(handler)
    }
    
    func createCallData(_ callID: String, inviter: UserInfo, invitee: UserInfo, type: CallType, callStatus: CallState) {
        currentCallData = ZegoCallDataModel(callID: callID, inviter: inviter, invitee: invitee, type: type, callStatus: callStatus)
    }
    
    func updateCallData(callStatus: CallState) {
        currentCallData?.callStatus = callStatus
    }
    
    func clearCallData() {
        currentCallData = nil
    }

    //MARK - invitation
    func sendVideoCall(_ targetUserID: String, callback: ZIMServiceInviteUserCallBack?) {
        guard let localUser = ZegoSDKManager.shared.localUser else { return }
        let callType: CallType = .video
        let extendedData: [String : Any] = ["type": callType.rawValue, "user_name": localUser.name]
        
        ZegoSDKManager.shared.zimService.sendUserRequest(userList: [targetUserID], extendedData: extendedData.jsonString) { code, invitationID, errorInvitees in
            if code == 0 {
                let invitee: UserInfo = UserInfo(id: targetUserID, name: targetUserID)
                self.createCallData(invitationID, inviter: localUser, invitee: invitee, type: callType, callStatus: .wating)
            } else {
                self.clearCallData()
            }
            callback?(code,invitationID,errorInvitees)
        }
    }
    
    func sendVoiceCall(_ targetUserID: String, callback: ZIMServiceInviteUserCallBack?) {
        guard let localUser = ZegoSDKManager.shared.localUser else { return }
        let callType: CallType = .voice
        let extendedData: [String : Any] = ["type": callType.rawValue, "user_name": localUser.name]
        
        ZegoSDKManager.shared.zimService.sendUserRequest(userList: [targetUserID], extendedData: extendedData.jsonString) { code, invitationID, errorInvitees in
            if code == 0 {
                let invitee: UserInfo = UserInfo(id: targetUserID, name: targetUserID)
                self.createCallData(invitationID, inviter: localUser, invitee: invitee, type: callType, callStatus: .wating)
            } else {
                self.clearCallData()
            }
            callback?(code,invitationID,errorInvitees)
        }
    }
    
    func cancelCallRequest(requestID: String, userID: String, callback: ZIMServiceCancelInviteCallBack?) {
        guard let currentCallData = currentCallData else { return }
        let extendedData: [String : Any] = ["type": currentCallData.type.rawValue]
        clearCallData()
        ZegoSDKManager.shared.zimService.cancelUserRequest(requestID: requestID,extendedData: extendedData.jsonString, userList: [userID], callback: callback)
    }
    
    func rejectCallRequest(requestID: String, callback: ZIMServiceRejectInviteCallBack?) {
        if let currentCallData = currentCallData,
           requestID == currentCallData.callID
        {
            let extendedData: [String : Any] = ["type": currentCallData.type.rawValue]
            clearCallData()
            ZegoSDKManager.shared.zimService.refuseUserRequest(requestID: requestID, extendedData: extendedData.jsonString, callback: callback)
        }
    }
    
    func acceptCallRequest(requestID: String, callback: ZIMServiceAcceptInviteCallBack?) {
        guard let currentCallData = currentCallData else { return }
        updateCallData(callStatus: .accept)
        let extendedData: [String : Any] = ["type": currentCallData.type.rawValue]
        ZegoSDKManager.shared.zimService.acceptUserRequest(requestID: requestID, extendedData: extendedData.jsonString) { code, requestID in
            callback?(code, requestID)
        }
    }
    
    func busyRejectCallRequest(requestID: String,  extendedData: String, type: CallType, callback: ZIMServiceRejectInviteCallBack?) {
        ZegoSDKManager.shared.zimService.refuseUserRequest(requestID: requestID, extendedData: extendedData, callback: callback)
    }
    
    func leaveRoom() {
        ZegoSDKManager.shared.leaveRoom()
    }
     
    func isCallBusiness(type: Int) -> Bool {
        if type == CallType.video.rawValue || type == CallType.voice.rawValue {
            return true
        }
        return false
    }
    
    func getMainStreamID() -> String {
        return "\(ZegoSDKManager.shared.expressService.roomID ?? "")_\(ZegoSDKManager.shared.localUser?.id ?? "")_main"
    }
}

extension ZegoCallManager: ZIMServiceDelegate {
    func onInComingUserRequestReceived(requestID: String, inviter: String, extendedData: String) {
        let extendedDict: [String : Any] = extendedData.toDict ?? [:]
        let callType: CallType? = CallType(rawValue: extendedDict["type"] as? Int ?? -1)
        guard let callType = callType,
              let localUser = ZegoSDKManager.shared.localUser
        else { return }
        if !isCallBusiness(type: callType.rawValue) { return }
        let inRoom: Bool = (ZegoSDKManager.shared.expressService.roomID != nil)
        if inRoom || (currentCallData != nil && currentCallData?.callID != requestID) {
            for delegate in callEventHandlers.allObjects {
                delegate.onInComingUserRequestReceived?(requestID: requestID, inviter: inviter, extendedData: extendedData)
            }
            return
        }
        let userName: String = extendedDict["user_name"] as? String ?? ""
        let inviterUser = UserInfo(id: inviter, name: userName)
        createCallData(requestID, inviter: inviterUser, invitee: localUser, type: callType, callStatus: .wating)
        
        for delegate in callEventHandlers.allObjects {
            delegate.onInComingUserRequestReceived?(requestID: requestID, inviter: inviter, extendedData: extendedData)
        }
    }
    
    func onInComingUserRequestCancelled(requestID: String, inviter: String, extendedData: String) {
        if let currentCallData = currentCallData,
           currentCallData.callID == requestID
        {
            for delegate in callEventHandlers.allObjects {
                delegate.onInComingUserRequestCancelled?(requestID: requestID, inviter: inviter, extendedData: extendedData)
            }
            clearCallData()
        }
    }
    
    func onInComingUserRequestTimeout(requestID: String) {
        if let currentCallData = currentCallData,
           currentCallData.callID == requestID
        {
            for delegate in callEventHandlers.allObjects {
                delegate.onInComingUserRequestTimeout?(requestID: requestID)
            }
            clearCallData()
        }
    }
    
    func onOutgoingUserRequestTimeout(requestID: String) {
        if let currentCallData = currentCallData,
           currentCallData.callID == requestID
        {
            for delegate in callEventHandlers.allObjects {
                delegate.onOutgoingUserRequestTimeout?(requestID: requestID)
            }
            clearCallData()
        }
    }
    
    func onOutgoingUserRequestAccepted(requestID: String, invitee: String, extendedData: String) {
        if let currentCallData = currentCallData,
           currentCallData.callID == requestID
        {
            updateCallData(callStatus: .accept)
            for delegate in callEventHandlers.allObjects {
                delegate.onOutgoingUserRequestAccepted?(requestID: requestID, invitee: invitee, extendedData: extendedData)
            }
        }
    }
    
    func onOutgoingUserRequestRejected(requestID: String, invitee: String, extendedData: String) {
        if let currentCallData = currentCallData,
           currentCallData.callID == requestID
        {
            updateCallData(callStatus: .reject)
            clearCallData()
            for delegate in callEventHandlers.allObjects {
                delegate.onOutgoingUserRequestRejected?(requestID: requestID, invitee: invitee, extendedData: extendedData)
            }
        }
    }
}

//
//  ZegoCallDataManager.swift
//  ZegoCallWithInvitationDemo
//
//  Created by zego on 2023/3/13.
//

import UIKit

class ZegoCallManager: NSObject {
    
    static let shared = ZegoCallManager()
    
    var currentCallData: ZegoCallDataModel?
    
    override init() {
        super.init()
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
    func sendCallInvitation(with invitees: [String], type: CallType, callback: SendCallInvitationCallback?) {
        guard let localUser = ZegoSDKManager.shared.localUser else { return }
        let callType: String = type == .voice ? "voice_call" : "video_call"
        let extendedData: [String : Any] = ["type": callType, "userName": localUser.id]
        
        ZegoSDKManager.shared.zimService.sendCallInvitation(with: invitees,
                                                            data: extendedData.jsonString) { [weak self] errorCode, errorMessage, invitationID, errorInvitees in
            if errorCode == 0 {
                let invitee: UserInfo = UserInfo(id: invitees.first ?? "", name: invitees.first ?? "")
                self?.createCallData(invitationID, inviter: localUser, invitee: invitee, type: type, callStatus: .wating)
            } else {
                self?.clearCallData()
            }
            callback?(errorCode, errorMessage, invitationID, errorInvitees)
        }
    }
    
    func cancelCallInvitation(with invitees: [String],
                              invitationID: String,
                              data: String?,
                              callback: CancelCallInvitationCallback?) {
        clearCallData()
        ZegoSDKManager.shared.zimService.cancelCallInvitation(with: invitees,
                                                              invitationID: invitationID,
                                                              data: data,
                                                              callback: callback)
    }
    
    func rejectCallInvitation(with invitationID: String,
                              data: String?,
                              callback: CommonCallback?) {
        if invitationID == currentCallData?.callID {
            clearCallData()
        }
        ZegoSDKManager.shared.zimService.rejectCallInvitation(with: invitationID, data: data, callback: callback)
    }
    
    func acceptCallInvitation(with invitationID: String, data: String?, callback: CommonCallback?) {
        updateCallData(callStatus: .accept)
        ZegoSDKManager.shared.zimService.acceptCallInvitation(with: invitationID, data: data, callback: callback)
    }
}

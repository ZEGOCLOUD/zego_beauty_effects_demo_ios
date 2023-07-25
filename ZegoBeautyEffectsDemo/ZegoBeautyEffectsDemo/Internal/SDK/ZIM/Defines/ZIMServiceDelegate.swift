//
//  ZIMServiceDelegate.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/7/10.
//

import Foundation
import ZIM

@objc public protocol ZIMServiceDelegate: ZIMEventHandler {
    
    @objc optional func onActionSendRoomRequest(errorCode: UInt, request: RoomRequest)
    @objc optional func onActionCancelRoomRequest(errorCode: UInt, request: RoomRequest)
    @objc optional func onOutgoingRoomRequestAccepted(request: RoomRequest)
    @objc optional func onOutgoingRoomRequestRejected(request: RoomRequest)
    
    
    @objc optional func onInComingRoomRequestReceived(request: RoomRequest)
    @objc optional func onInComingRoomRequestCancelled(request: RoomRequest)
    @objc optional func onActionAcceptIncomingRoomRequest(errorCode: UInt, request: RoomRequest)
    @objc optional func onActionRejectIncomingRoomRequest(errorCode: UInt, request: RoomRequest)
    
    
    @objc optional func onInComingUserRequestReceived(requestID: String, inviter: String, extendedData: String)
    @objc optional func onInComingUserRequestTimeout(requestID: String)
    @objc optional func onInComingUserRequestCancelled(requestID: String, inviter: String, extendedData: String)
    @objc optional func onOutgoingUserRequestTimeout(requestID: String)
    @objc optional func onOutgoingUserRequestAccepted(requestID: String, invitee: String, extendedData: String)
    @objc optional func onOutgoingUserRequestRejected(requestID: String, invitee: String, extendedData: String)
    
    @objc optional func onRoomCommandReceived(senderID: String, command: String)
}

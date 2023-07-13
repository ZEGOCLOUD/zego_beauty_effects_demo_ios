//
//  ExpressService+Device.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/4/3.
//

import Foundation
import ZegoExpressEngine

extension ExpressService {
    public func useFrontFacingCamera(_ isFrontFacing: Bool) {
        isUsingFrontCamera = isFrontFacing
        ZegoExpressEngine.shared().useFrontCamera(isFrontFacing)
    }
    
    public func enableSpeaker(enable: Bool) {
        ZegoExpressEngine.shared().setAudioRouteToSpeaker(enable)
    }
    
    public func turnMicrophoneOn(_ isOn: Bool) {
        localUser?.isMicrophoneOpen = isOn
        ZegoExpressEngine.shared().muteMicrophone(!isOn)
        
        if let localUser = localUser {
            setCameraAndMicState(isCameraOpen: localUser.isCameraOpen,
                                 isMicOpen: isOn)
        }
    }
    
    public func turnCameraOn(_ isOn: Bool) {
        localUser?.isCameraOpen = isOn
        ZegoExpressEngine.shared().enableCamera(isOn)
        
        if let localUser = localUser {
            setCameraAndMicState(isCameraOpen: isOn,
                                 isMicOpen: localUser.isMicrophoneOpen)
        }
    }
    
    func isMicrophoneOn(_ userID: String) -> Bool {
        guard let participant = inRoomUserDict[userID] else { return false }
        return participant.isMicrophoneOpen
    }
    
    func isCameraOn(_ userID: String) -> Bool {
        guard let participant = inRoomUserDict[userID] else { return false }
        return participant.isCameraOpen
    }
    
    func setCameraAndMicState(isCameraOpen: Bool, isMicOpen: Bool) {
        let info = ["cam" : isCameraOpen, "mic": isMicOpen]
        let infoStr = info.jsonString
        ZegoExpressEngine.shared().setStreamExtraInfo(infoStr)
    }
}

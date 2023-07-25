//
//  ExpressService+Mixer.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/6/2.
//

import Foundation
import ZegoExpressEngine

extension ExpressService {
    
    public func startMixerTask(leftStreamID: String,
                               rightStreamID: String,
                               leftContentType: ZegoMixerInputContentType,
                               rightContentType: ZegoMixerInputContentType,
                               callback: ZegoMixerStartCallback?) {
        let task = ZegoMixerTask(taskID: generateMixerStreamID())
        let videoConfig = ZegoMixerVideoConfig()
        videoConfig.resolution = CGSize(width: 540 * 2, height: 960)
        videoConfig.bitrate = 1200
        task.setVideoConfig(videoConfig)
        task.setAudioConfig(ZegoMixerAudioConfig.default())
        task.enableSoundLevel(true)
        
        let firstRect = CGRect(x: 0, y: 0, width: 540, height: 960)
        let firstInput = ZegoMixerInput(streamID: leftStreamID, contentType: leftContentType, layout: firstRect)
        firstInput.renderMode = .fill
        firstInput.soundLevelID = 0
        firstInput.volume = 100
        
        let secondRect = CGRect(x: 540, y: 0, width: 540, height: 960)
        let secondInput = ZegoMixerInput(streamID: rightStreamID, contentType: rightContentType, layout: secondRect)
        secondInput.soundLevelID = 1
        secondInput.volume = 100
        secondInput.renderMode = .fill
        
        task.setInputList([firstInput,secondInput])
        task.setOutputList([ZegoMixerOutput(target: generateMixerStreamID())])
        
        currentMixerTask = task
        
        ZegoExpressEngine.shared().start(task) { errorCode, mixerInfo in
            if errorCode == 0 {
                print("mixer stream sucessful")
            } else {
                print("mixer stream fail:\(errorCode) streamID: \(self.generateMixerStreamID())")
                self.currentMixerTask = nil
            }
            guard let callback = callback else { return }
            callback(errorCode,mixerInfo)
        }
    }
    
    public func stopMixerTask() {
        guard let currentMixerTask = currentMixerTask else { return }
        ZegoExpressEngine.shared().stop(currentMixerTask) { code in
            
        }
    }
    
    public func generateMixerStreamID() -> String {
        let roomID = roomID ?? ""
        let mixerStreamID = roomID + "_mix"
        return mixerStreamID
    }
    
}

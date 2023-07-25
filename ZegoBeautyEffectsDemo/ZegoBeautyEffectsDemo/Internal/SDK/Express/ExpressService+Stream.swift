//
//  ExpressService+Stream.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/4/3.
//

import Foundation
import ZegoExpressEngine

extension ExpressService {
    
    public func startPreview(_ renderView: UIView,
                            viewMode: ZegoViewMode = .aspectFill) {
        let canvas = ZegoCanvas(view: renderView)
        canvas.viewMode = viewMode
        ZegoExpressEngine.shared().startPreview(canvas)
    }
    
    public func stopPreview() {
        ZegoExpressEngine.shared().stopPreview()
    }
    
    public func startPublishingStream(_ streamID: String, channel: ZegoPublishChannel = .main) {
        localUser?.streamID = streamID
        streamDict[streamID] = localUser?.id
        
        ZegoExpressEngine.shared().startPublishingStream(streamID)
        if let localUser = localUser {
            setCameraAndMicState(isCameraOpen: localUser.isCameraOpen,
                                 isMicOpen: localUser.isMicrophoneOpen)
        }
    }

    public func stopPublishingStream() {
        ZegoExpressEngine.shared().stopPublishingStream()
        ZegoExpressEngine.shared().stopPreview()
    }
    
    public func startPlayingStream(_ renderView: UIView?,
                                   streamID: String,
                                   config: ZegoPlayerConfig = ZegoPlayerConfig(),
                                   viewMode: ZegoViewMode = .aspectFill) {
        if let renderView = renderView {
            let canvas = ZegoCanvas(view: renderView)
            canvas.viewMode = viewMode
            ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: canvas, config: config)
        } else {
            ZegoExpressEngine.shared().startPlayingStream(streamID, config: config)
        }
    }
    
    public func stopPlayingStream(_ streamID: String) {
        ZegoExpressEngine.shared().stopPlayingStream(streamID)
    }
    
    public func mutePlayStreamAudio(streamID: String, mute: Bool) {
        ZegoExpressEngine.shared().mutePlayStreamAudio(mute, streamID: streamID)
    }
    
    public func mutePlayStreamVideo(streamID: String, mute: Bool) {
        ZegoExpressEngine.shared().mutePlayStreamVideo(mute, streamID: streamID)
    }
}

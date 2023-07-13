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
    
    public func startPublishingStream() {
        let streamID = generateStreamID()
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
                                   viewMode: ZegoViewMode = .aspectFill) {
        if let renderView = renderView {
            let canvas = ZegoCanvas(view: renderView)
            canvas.viewMode = viewMode
            ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: canvas)
        } else {
            ZegoExpressEngine.shared().startPlayingStream(streamID)
        }
    }
    
    public func stopPlayingStream(_ streamID: String) {
        ZegoExpressEngine.shared().stopPlayingStream(streamID)
    }
    
    private func generateStreamID() -> String {
        assert(localUser != nil, "Must login first!")
        assert(roomID != nil, "Must join room first!")
        let userID = localUser?.id ?? ""
        let roomID = roomID ?? ""
        let streamID = roomID + "_" + userID + (isHost ? "_host" : "_coHost")
        return streamID
    }
}

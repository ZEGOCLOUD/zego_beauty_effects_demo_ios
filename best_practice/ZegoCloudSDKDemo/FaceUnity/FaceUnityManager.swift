//
//  FaceUnityManager.swift
//  ZegoBeautyEffectsDemo
//
//  Created by zego on 2023/9/20.
//

import UIKit

class FaceUnityManager: NSObject {
    
    public static let shared = FaceUnityManager()
    
    public func enableFaceUnity() {
        ZegoSDKManager.shared.enableCustomVideoProcess()
        FUManager.share().loadFilter()
    }
    
    public func disableFaceUnity() {
        ZegoSDKManager.shared.disableCustomVideoProcess()
    }

}

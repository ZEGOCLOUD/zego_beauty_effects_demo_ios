//
//  DeepAR+EventHandler.swift
//  ZegoCloudSDKDemo
//
//  Created by zego on 2024/1/9.
//

import Foundation
import DeepAR

extension DeepARService: DeepARDelegate {
    
    public func didInitialize() {
        debugPrint("DeepAR didInitialize...")
        for delegate in eventHandlers.allObjects {
            delegate.onDidInitialize?()
        }
    }
    
    public func onError(withCode code: ARErrorType, error: String!) {
        debugPrint("onError code:\(code) error:\(String(describing: error))")
    }
    
}

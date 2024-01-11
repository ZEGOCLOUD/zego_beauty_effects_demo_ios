//
//  DeepARServiceDelegate.swift
//  ZegoCloudSDKDemo
//
//  Created by zego on 2024/1/9.
//

import Foundation
import DeepAR

@objc public protocol DeepARServiceDelegate: DeepARDelegate {
    
    @objc optional func onDidInitialize()
}

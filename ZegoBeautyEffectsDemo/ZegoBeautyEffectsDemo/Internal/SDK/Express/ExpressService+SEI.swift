//
//  ExpressService+SEI.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/6/9.
//

import Foundation
import ZegoExpressEngine

extension ExpressService {
    
    public func sendSEI(_ data: Data) {
        ZegoExpressEngine.shared().sendSEI(data)
    }
    
}

//
//  ZegoEffectsService.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/6.
//

import Foundation
import ZegoEffects

public class ZegoEffectsService: NSObject {
    
    public static let shared = ZegoEffectsService()
    
    public var BACKEND_API_URL = "https://aieffects-api.zego.im/?Action=DescribeEffectsLicense"
    
    public var effects: ZegoEffects?
    
    var beautyAbilities = [BeautyType: BeautyAbility]()
    
    private var appID: UInt32 = 0
    private var appSign: String = ""
    
    private var isInitialized: Bool = false
    
    public func initWithAppID(appID: UInt32, appSign: String) {
        
        if isInitialized { return }
        
        self.appID = appID
        self.appSign = appSign
        
        // step 1, setResources
        EffectsSDKHelper.setResources()
        
        // step 2, getLicence
        EffectsSDKHelper.getLicence(BACKEND_API_URL,
                                    appID: appID,
                                    appSign: appSign) { code, license in
            if code == 0, let license = license {
                self.isInitialized = true
                // step 3 create effect
                self.effects = ZegoEffects.create(license)
                self.effects?.enableFaceDetection(true)
                self.effects?.setEventHandler(self)
                
                // step 4 enableAbilities
                self.initBeautyAbilities()
            }
        }
    }
    
    public func initEnv(_ resolution: CGSize) {
        effects?.initEnv(resolution)
    }
    
    public func uninitEnv() {
        effects?.uninitEnv()
    }
    
    public func processImageBuffer(_ buffer: CVPixelBuffer) {
        effects?.processImageBuffer(buffer)
    }
}

extension ZegoEffectsService: ZegoEffectsEventHandler {
    
    public func effects(_ effects: ZegoEffects, errorCode: Int32, desc: String) {
        debugPrint("effects errorCode: \(errorCode), desc: \(desc)")
        if errorCode == 5000002 {
            EffectsSDKHelper.inValidLicense()
            initWithAppID(appID: appID, appSign: appSign)
        }
    }
    
    public func effects(_ effects: ZegoEffects, faceDetectionResults results: [ZegoEffectsFaceDetectionResult]) {
        
        for result in results {
            debugPrint("faceDetectionResults, result.rect: \(result.rect), result.score: \(result.score)")
        }
    }
}

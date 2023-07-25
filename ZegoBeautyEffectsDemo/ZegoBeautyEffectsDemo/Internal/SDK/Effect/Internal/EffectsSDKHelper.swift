//
//  EffectsSDKHelper.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/6.
//

import Foundation
import ZegoEffects

private var requestTimestamp: TimeInterval = 0

class EffectsSDKHelper {
    
    static var resourcesFolder: String = Bundle.main.path(forResource: "BeautyResources", ofType: nil)!
    static var portraitSegmentationImagePath = resourcesFolder + "/BackgroundImages/image1.jpg"

    static func setResources() {
        let faceDetectionModel = resourcesFolder + "/FaceDetection.model"
        let commonResources = resourcesFolder + "/CommonResources.bundle"
        let faceWhiteningResources = commonResources + "/FaceWhiteningResources"
        let rosyResources = commonResources + "/RosyResources"
        let teethWhiteningResources = commonResources + "/TeethWhiteningResources"
        let stickerPath = resourcesFolder + "/StickerBaseResources.bundle"
        let segmentationPath = resourcesFolder + "/BackgroundSegmentation.model"

        ZegoEffects.setResources([faceDetectionModel,
                                  commonResources,
                                  faceWhiteningResources,
                                  rosyResources,
                                  teethWhiteningResources,
                                  stickerPath,
                                  segmentationPath])
    }
    
    static func getLicence(_ baseUrl: String,
                           appID: UInt32,
                           appSign: String,
                           callback: @escaping (_ code: Int, _ license: String?) -> ()) {
        let license = UserDefaults.standard.string(forKey: "effect_licence")
        let timestamp = UserDefaults.standard.double(forKey: "effect_timestamp")
        let currentTime = Date().timeIntervalSince1970
        if let license = license,
            currentTime - timestamp < 24 * 60 * 60 {
            callback(0, license)
            return
        }
        
        if currentTime - requestTimestamp < 60 * 60 {
            callback(-1, nil)
            return
        }
        
        let authInfo = ZegoEffects.getAuthInfo(appSign)
        
        let urlString = baseUrl + "&AppId=\(appID)&AuthInfo=\(authInfo)"
        
        APIBase.GET(urlString) { error, response in
            if error == nil {
                let code = response?["Code"] as? Int
                let data = response?["Data"] as? [String: String]
                let license = data?["License"]
                
                UserDefaults.standard.setValue(license, forKey: "effect_licence")
                UserDefaults.standard.setValue(currentTime, forKey: "effect_timestamp")
                
                requestTimestamp = Date().timeIntervalSince1970
                
                callback(code ?? 0, license)
            } else {
                callback(error?.code ?? 0, nil)
            }
        }
    }
    
    static func inValidLicense() {
        UserDefaults.standard.setValue("", forKey: "effect_licence")
        UserDefaults.standard.setValue(0, forKey: "effect_timestamp")
    }
}

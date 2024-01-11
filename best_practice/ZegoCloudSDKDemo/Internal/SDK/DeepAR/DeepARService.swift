//
//  DeepARService.swift
//  ZegoCloudSDKDemo
//
//  Created by zego on 2024/1/9.
//

import UIKit
import DeepAR

public typealias DeepARServiceCallback = (_ buffer: CVPixelBuffer) -> ()

public class DeepARService: NSObject {
    
    public static let shared = DeepARService()
    
    var deepAR: DeepAR?
    
    let eventHandlers: NSHashTable<DeepARServiceDelegate> = NSHashTable(options: .weakMemory)
    
    var currentBackgroundImage: UIImage?
    var enableBackgroundBlur: Bool = false
    
    public func initWithLicense(_ licenseKey: String) {
        if let _ = deepAR {
            return
        }
        deepAR = DeepAR()
        deepAR!.setLicenseKey(licenseKey)
        deepAR!.delegate = self
        deepAR!.changeLiveMode(false)
        self.deepAR!.initializeOffscreen(withWidth: 960, height: 540)
    }
    
    public func unInit() {
        deepAR?.shutdown()
        deepAR?.delegate = nil
        deepAR = nil
    }
    
    public func addEventHandler(_ handler: DeepARServiceDelegate) {
        eventHandlers.add(handler)
    }
    
    public func changeLiveModel(_ liveModel: Bool) {
        deepAR?.changeLiveMode(liveModel)
    }
    
    public func initializeOffscreen(width: Int, height: Int) {
        deepAR?.initializeOffscreen(withWidth: width, height: height)
    }
    
    public func processFrameAndReturn(imageBuffer: CVPixelBuffer, outputBuffer: CVPixelBuffer, mirror: Bool) {
        deepAR?.processFrameAndReturn(imageBuffer, outputBuffer: outputBuffer, mirror: mirror)
    }
    
    public func setRenderingResolution(width: Int, height: Int) {
        deepAR?.setRenderingResolutionWithWidth(width, height: height)
    }
    
    public func sendPixelBufferToDeepAR(sampleBuffer: CVPixelBuffer, outputBuffer: CVPixelBuffer ,mirror: Bool) {
        if CFGetTypeID(sampleBuffer) == CVPixelBufferGetTypeID() {
            deepAR?.processFrameAndReturn(sampleBuffer, outputBuffer: outputBuffer, mirror: mirror)
        }
    }
    
    public func switchEffect(slot: String, path: String) {
        deepAR?.switchEffect(withSlot: slot, path: path)
    }
    
    public func removeEffect(slot: String) {
        deepAR?.switchEffect(withSlot: slot, path: "none")
    }
    
    public func backgroundBlur(enable: Bool, strength: Int) {
        enableBackgroundBlur = enable
        deepAR?.backgroundBlur(enable, strength: strength)
    }
    
    public func backgroundReplacement(enable: Bool, image: UIImage!) {
        currentBackgroundImage = image
        deepAR?.backgroundReplacement(enable, image: image)
    }
    
    public func disableDeepAR() {
        switchEffect(slot: "mask", path: "none")
        switchEffect(slot: "effect", path: "none")
        switchEffect(slot: "filter", path: "none")
        if enableBackgroundBlur {
            backgroundBlur(enable: false, strength: 0)
        }
        if let currentBackgroundImage = currentBackgroundImage {
            backgroundReplacement(enable: false, image: currentBackgroundImage)
            self.currentBackgroundImage = nil
        }
    }
    
}

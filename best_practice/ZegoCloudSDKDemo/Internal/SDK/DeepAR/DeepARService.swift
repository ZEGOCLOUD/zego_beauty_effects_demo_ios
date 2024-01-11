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
    
    public func initWithLicense(_ licenseKey: String) {
        if let _ = deepAR {
            return
        }
        deepAR = DeepAR()
        deepAR!.setLicenseKey(licenseKey)
        deepAR!.delegate = self
        deepAR!.changeLiveMode(false)
        self.deepAR!.initializeOffscreen(withWidth: 1, height: 1)
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
    
    public func backgroundBlur(enable: Bool, strength: Int) {
        deepAR?.backgroundBlur(true, strength: strength)
    }
    
    public func backgroundReplacement(enable: Bool, image: UIImage!) {
        deepAR?.backgroundReplacement(enable, image: image)
    }
    
    public func disableDeepAR() {
        switchEffect(slot: "mask", path: "none")
        switchEffect(slot: "effect", path: "none")
        switchEffect(slot: "filter", path: "none")
        backgroundBlur(enable: false, strength: 0)
    }
    
}

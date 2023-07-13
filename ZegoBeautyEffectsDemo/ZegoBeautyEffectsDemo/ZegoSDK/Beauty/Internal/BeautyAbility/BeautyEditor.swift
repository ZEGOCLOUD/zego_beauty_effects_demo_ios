//
//  BeautyEditor.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/8.
//

import Foundation
import ZegoEffects

public protocol BeautyEditor {
    var effects: ZegoEffects? { get }
        
    func enable(_ enable: Bool)
    
    func apply(_ value: Int32)
}

public struct SmoothingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableSmooth(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsSmoothParam()
        param.intensity = value
        effects?.setSmoothParam(param)
    }
}

public struct SkinToneEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableWhiten(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsWhitenParam()
        param.intensity = value
        effects?.setWhitenParam(param)
    }
}

public struct BlusherEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableRosy(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsRosyParam()
        param.intensity = value
        effects?.setRosyParam(param)
    }
}

public struct SharpeningEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableSharpen(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsSharpenParam()
        param.intensity = value
        effects?.setSharpenParam(param)
    }
}

public struct WrinklesEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableWrinklesRemoving(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsWrinklesRemovingParam()
        param.intensity = value
        effects?.setWrinklesRemovingParam(param)
    }
}

public struct DarkCirclesEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableDarkCirclesRemoving(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsDarkCirclesRemovingParam()
        param.intensity = value
        effects?.setDarkCirclesRemovingParam(param)
    }
}

public struct FaceSlimmingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableFaceLifting(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsFaceLiftingParam()
        param.intensity = value
        effects?.setFaceLiftingParam(param)
    }
}

public struct EyesEnlargingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableBigEyes(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsBigEyesParam()
        param.intensity = value
        effects?.setBigEyesParam(param)
    }
}

public struct EyesBrighteningEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableEyesBrightening(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsEyesBrighteningParam()
        param.intensity = value
        effects?.setEyesBrighteningParam(param)
    }
}

public struct ChinLengtheningEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableLongChin(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsLongChinParam()
        param.intensity = value
        effects?.setLongChinParam(param)
    }
}

public struct MouthReshapeEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableSmallMouth(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsSmallMouthParam()
        param.intensity = value
        effects?.setSmallMouthParam(param)
    }
}

public struct TeethWhiteningEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableTeethWhitening(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsTeethWhiteningParam()
        param.intensity = value
        effects?.setTeethWhiteningParam(param)
    }
}

public struct NoseSlimmingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableNoseNarrowing(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsNoseNarrowingParam()
        param.intensity = value
        effects?.setNoseNarrowingParam(param)
    }
}

public struct NoseLengtheningEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableNoseLengthening(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsNoseLengtheningParam()
        param.intensity = value
        effects?.setNoseLengtheningParam(param)
    }
}

public struct FaceShorteningEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableFaceShortening(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsFaceShorteningParam()
        param.intensity = value
        effects?.setFaceShorteningParam(param)
    }
}

public struct MandibleSlimmingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableMandibleSlimming(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsMandibleSlimmingParam()
        param.intensity = value
        effects?.setMandibleSlimmingParam(param)
    }
}

public struct CheekboneSlimmingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableCheekboneSlimming(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsCheekboneSlimmingParam()
        param.intensity = value
        effects?.setCheekboneSlimmingParam(param)
    }
}

public struct ForeheadSlimmingEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        effects?.enableForeheadShortening(enable)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsForeheadShorteningParam()
        param.intensity = value
        effects?.setForeheadShorteningParam(param)
    }
}

public struct LipstickEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setLipstick(path)
        debugPrint("setLipstick() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsLipstickParam()
        param.intensity = value
        effects?.setLipstickParam(param)
    }
}

public struct blusherEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setBlusher(path)
        debugPrint("setBlusher() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsBlusherParam()
        param.intensity = value
        effects?.setBlusherParam(param)
    }
}

public struct eyelashesEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setEyelashes(path)
        debugPrint("setEyelashes() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsEyelashesParam()
        param.intensity = value
        effects?.setEyelashesParam(param)
    }
}

public struct eyelinerEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setEyeliner(path)
        debugPrint("setEyeliner() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsEyelinerParam()
        param.intensity = value
        effects?.setEyelinerParam(param)
    }
}

public struct eyeshadowEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setEyeshadow(path)
        debugPrint("setEyeshadow() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsEyeshadowParam()
        param.intensity = value
        effects?.setEyeshadowParam(param)
    }
}

public struct coloredContactsEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setColoredcontacts(path)
        debugPrint("setColoredcontacts() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsColoredcontactsParam()
        param.intensity = value
        effects?.setColoredcontactsParam(param)
    }
}

public struct styleMakeupEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setMakeup(path)
        debugPrint("setMakeup() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsMakeupParam()
        param.intensity = value
        effects?.setMakeupParam(param)
    }
}

public struct stickerEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setPendant(path)
        debugPrint("setPendant() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        
    }
}

public struct backgroundEditor: BeautyEditor {
    public var effects: ZegoEffects?
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        
        debugPrint("setMakeup() called with: enable = [\(enable)], path: \(path ?? "")")
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsMakeupParam()
        param.intensity = value
        effects?.setMakeupParam(param)
    }
}

public struct FilterEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public var path: String
    
    public init(effects: ZegoEffects?, path: String) {
        self.effects = effects
        self.path = path
    }
    
    public func enable(_ enable: Bool) {
        let path = enable ? path : nil
        effects?.setFilter(path)
    }
    
    public func apply(_ value: Int32) {
        let param = ZegoEffectsFilterParam()
        param.intensity = value
        effects?.setFilterParam(param)
    }
}

// MARK: - None & Reset
public struct BasicResetEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        
    }
    
    public func apply(_ value: Int32) {
        
    }
}

public struct AdvancedResetEditor: BeautyEditor {
    public var effects: ZegoEffects?
    
    public init(effects: ZegoEffects?) {
        self.effects = effects
    }
    
    public func enable(_ enable: Bool) {
        
    }
    
    public func apply(_ value: Int32) {
        
    }
}











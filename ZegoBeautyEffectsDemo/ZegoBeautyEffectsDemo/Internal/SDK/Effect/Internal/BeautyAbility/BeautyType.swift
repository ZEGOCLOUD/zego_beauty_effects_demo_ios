//
//  BeautyType.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/6.
//

import Foundation

public enum BeautyType: String {
    
    // Beauty
    // Beauty - Basic
    case beautyBasicSmoothing
    case beautyBasicSkinTone
    case beautyBasicBlusher
    case beautyBasicSharpening
    case beautyBasicWrinkles
    case beautyBasicDarkCircles

    // Beauty - Advanced
    case beautyAdvancedFaceSlimming
    case beautyAdvancedEyesEnlarging
    case beautyAdvancedEyesBrightening
    case beautyAdvancedChinLengthening
    case beautyAdvancedMouthReshape
    case beautyAdvancedTeethWhitening
    case beautyAdvancedNoseSlimming
    case beautyAdvancedNoseLengthening
    case beautyAdvancedFaceShortening
    case beautyAdvancedMandibleSlimming
    case beautyAdvancedCheekboneSlimming
    case beautyAdvancedForeheadSlimming

    // Beauty - Makeup
    // Beauty - Makeup - Lipstick
    case beautyMakeupLipstickCameoPink
    case beautyMakeupLipstickSweetOrange
    case beautyMakeupLipstickRustRed
    case beautyMakeupLipstickCoral
    case beautyMakeupLipstickRedVelvet

    // Beauty - Makeup - Blusher
    case beautyMakeupBlusherSlightlyDrunk
    case beautyMakeupBlusherPeach
    case beautyMakeupBlusherMilkyOrange
    case beautyMakeupBlusherApricotPink
    case beautyMakeupBlusherSweetOrange

    // Beauty - Makeup - Eyelashes
    case beautyMakeupEyelashesNatural
    case beautyMakeupEyelashesTender
    case beautyMakeupEyelashesCurl
    case beautyMakeupEyelashesEverlong
    case beautyMakeupEyelashesThick

    // Beauty - Makeup - Eyeliner
    case beautyMakeupEyelinerNatural
    case beautyMakeupEyelinerCatEye
    case beautyMakeupEyelinerNaughty
    case beautyMakeupEyelinerInnocent
    case beautyMakeupEyelinerDignified

    // Beauty - Makeup - Eyeshadow
    case beautyMakeupEyeshadowPinkMist
    case beautyMakeupEyeshadowShimmerPink
    case beautyMakeupEyeshadowTeaBrown
    case beautyMakeupEyeshadowBrightOrange
    case beautyMakeupEyeshadowMochaBrown

    // Beauty - Makeup - Colored Contacts
    case beautyMakeupColoredContactsDarknightBlack
    case beautyMakeupColoredContactsStarryBlue
    case beautyMakeupColoredContactsBrownGreen
    case beautyMakeupColoredContactsLightsBrown
    case beautyMakeupColoredContactsChocolateBrown

    // Beauty - Style-Makeup
    case beautyStyleMakeupInnocentEyes
    case beautyStyleMakeupMilkyEyes
    case beautyStyleMakeupCutieCool
    case beautyStyleMakeupPureSexy
    case beautyStyleMakeupFlawless

    // Filters
    // Filters - Natural
    case filterNaturalCreamy
    case filterNaturalBrighten
    case filterNaturalFresh
    case filterNaturalAutumn

    // Filters - Gray
    case filterGrayMonet
    case filterGrayNight
    case filterGrayFilmlike

    // Filters - Dreamy
    case filterDreamySunset
    case filterDreamyCozily
    case filterDreamySweet
    
    // Stickers
    case stickerAnimal
    case stickerDive
    case stickerCat
    case stickerWatermelon
    case stickerDeer
    case stickerCoolGirl
    case stickerClown
    case stickerClawMachine
    case stickerSailorMoon

    // background
//    case backgroundGreenScreenSegmentation
    case backgroundPortraitSegmentation
    case backgroundMosaicing
    case backgroundGaussianBlur
    
    // reset
    case beautyBasicReset
    case beautyAdvancedReset
    case beautyMakeupLipstickReset
    case beautyMakeupBlusherReset
    case beautyMakeupEyelashesReset
    case beautyMakeupEyelinerReset
    case beautyMakeupEyeshadowReset
    case beautyMakeupColoredContactsReset
    case beautyStyleMakeupReset
    case filterReset
    case stickerReset
    case backgroundReset
    
    var isReset: Bool {
        if self == .beautyBasicReset ||
            self == .beautyAdvancedReset ||
            self == .beautyMakeupLipstickReset ||
            self == .beautyMakeupBlusherReset ||
            self == .beautyMakeupEyelashesReset ||
            self == .beautyMakeupEyelinerReset ||
            self == .beautyMakeupEyeshadowReset ||
            self == .beautyMakeupColoredContactsReset ||
            self == .beautyStyleMakeupReset ||
            self == .filterReset ||
            self == .stickerReset ||
            self == .backgroundReset {
            return true
        } else {
            return false
        }
    }
    
    var path: String {
        if isReset {
            return ""
        }
        
        // beauty basic and beauty advanced don't need resources
        return EffectsSDKHelper.resourcesFolder + "/AdvancedResources/" + rawValue + ".bundle"
    }
}

//
//  ZegoEffectsService+Extension.swift
//  ZegoBeautyEffectsDemo
//
//  Created by Kael Ding on 2023/7/13.
//

import Foundation

extension ZegoEffectsService {
    
    func initBeautyAbilities() {
        // Basic
        beautyAbilities[.beautyBasicReset] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: BasicResetEditor(effects: nil), type: .beautyBasicReset)
        beautyAbilities[.beautyBasicSmoothing] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: SmoothingEditor(effects: effects), type: .beautyBasicSmoothing)
        beautyAbilities[.beautyBasicSkinTone] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: SkinToneEditor(effects: effects), type: .beautyBasicSkinTone)
        beautyAbilities[.beautyBasicBlusher] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: BlusherEditor(effects: effects), type: .beautyBasicBlusher)
        beautyAbilities[.beautyBasicSharpening] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: SharpeningEditor(effects: effects), type: .beautyBasicSharpening)
        beautyAbilities[.beautyBasicWrinkles] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: WrinklesEditor(effects: effects), type: .beautyBasicWrinkles)
        beautyAbilities[.beautyBasicDarkCircles] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: DarkCirclesEditor(effects: effects), type: .beautyBasicDarkCircles)
        
        // Advanced
        beautyAbilities[.beautyAdvancedReset] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: AdvancedResetEditor(effects: nil), type: .beautyAdvancedReset)
        beautyAbilities[.beautyAdvancedFaceSlimming] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: FaceSlimmingEditor(effects: effects), type: .beautyAdvancedFaceSlimming)
        beautyAbilities[.beautyAdvancedEyesEnlarging] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: EyesEnlargingEditor(effects: effects), type: .beautyAdvancedEyesEnlarging)
        beautyAbilities[.beautyAdvancedEyesBrightening] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: EyesBrighteningEditor(effects: effects), type: .beautyAdvancedEyesBrightening)
        beautyAbilities[.beautyAdvancedChinLengthening] = BeautyAbility(minValue: -100, maxValue: 100, defaultValue: 0, editor: ChinLengtheningEditor(effects: effects), type: .beautyAdvancedChinLengthening)
        beautyAbilities[.beautyAdvancedMouthReshape] = BeautyAbility(minValue: -100, maxValue: 100, defaultValue: 0, editor: MouthReshapeEditor(effects: effects), type: .beautyAdvancedMouthReshape)
        beautyAbilities[.beautyAdvancedTeethWhitening] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: TeethWhiteningEditor(effects: effects), type: .beautyAdvancedTeethWhitening)
        beautyAbilities[.beautyAdvancedNoseSlimming] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: NoseSlimmingEditor(effects: effects), type: .beautyAdvancedNoseSlimming)
        beautyAbilities[.beautyAdvancedNoseLengthening] = BeautyAbility(minValue: -100, maxValue: 100, defaultValue: 0, editor: NoseLengtheningEditor(effects: effects), type: .beautyAdvancedNoseLengthening)
        beautyAbilities[.beautyAdvancedFaceShortening] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: FaceShorteningEditor(effects: effects), type: .beautyAdvancedFaceShortening)
        beautyAbilities[.beautyAdvancedMandibleSlimming] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: MandibleSlimmingEditor(effects: effects), type: .beautyAdvancedMandibleSlimming)
        beautyAbilities[.beautyAdvancedCheekboneSlimming] = BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: CheekboneSlimmingEditor(effects: effects), type: .beautyAdvancedCheekboneSlimming)
        beautyAbilities[.beautyAdvancedForeheadSlimming] = BeautyAbility(minValue: -100, maxValue: 100, defaultValue: 0, editor: ForeheadSlimmingEditor(effects: effects), type: .beautyAdvancedForeheadSlimming)
                
        // Filters
        beautyAbilities[.filterReset] = filterAbility(.filterReset)
        beautyAbilities[.filterNaturalCreamy] = filterAbility(.filterNaturalCreamy)
        beautyAbilities[.filterNaturalBrighten] = filterAbility(.filterNaturalBrighten)
        beautyAbilities[.filterNaturalFresh] = filterAbility(.filterNaturalFresh)
        beautyAbilities[.filterNaturalAutumn] = filterAbility(.filterNaturalAutumn)
        beautyAbilities[.filterGrayMonet] = filterAbility(.filterGrayMonet)
        beautyAbilities[.filterGrayNight] = filterAbility(.filterGrayNight)
        beautyAbilities[.filterGrayFilmlike] = filterAbility(.filterGrayFilmlike)
        beautyAbilities[.filterDreamySunset] = filterAbility(.filterDreamySunset)
        beautyAbilities[.filterDreamyCozily] = filterAbility(.filterDreamyCozily)
        beautyAbilities[.filterDreamySweet] = filterAbility(.filterDreamySweet)
        
        // Makeup - Lipstick
        beautyAbilities[.beautyMakeupLipstickReset] = lipsAbility(.beautyMakeupLipstickReset)
        beautyAbilities[.beautyMakeupLipstickCameoPink] = lipsAbility(.beautyMakeupLipstickCameoPink)
        beautyAbilities[.beautyMakeupLipstickSweetOrange] = lipsAbility(.beautyMakeupLipstickSweetOrange)
        beautyAbilities[.beautyMakeupLipstickRustRed] = lipsAbility(.beautyMakeupLipstickRustRed)
        beautyAbilities[.beautyMakeupLipstickCoral] = lipsAbility(.beautyMakeupLipstickCoral)
        beautyAbilities[.beautyMakeupLipstickRedVelvet] = lipsAbility(.beautyMakeupLipstickRedVelvet)
        
        // Makeup - Blusher
        beautyAbilities[.beautyMakeupBlusherReset] = blusherAbility(.beautyMakeupBlusherReset)
        beautyAbilities[.beautyMakeupBlusherSlightlyDrunk] = blusherAbility(.beautyMakeupBlusherSlightlyDrunk)
        beautyAbilities[.beautyMakeupBlusherPeach] = blusherAbility(.beautyMakeupBlusherPeach)
        beautyAbilities[.beautyMakeupBlusherMilkyOrange] = blusherAbility(.beautyMakeupBlusherMilkyOrange)
        beautyAbilities[.beautyMakeupBlusherAprocitPink] = blusherAbility(.beautyMakeupBlusherAprocitPink)
        beautyAbilities[.beautyMakeupBlusherSweetOrange] = blusherAbility(.beautyMakeupBlusherSweetOrange)
        
        // Makeup - Eyelashes
        beautyAbilities[.beautyMakeupEyelashesReset] = eyelashesAbility(.beautyMakeupEyelashesReset)
        beautyAbilities[.beautyMakeupEyelashesNatural] = eyelashesAbility(.beautyMakeupEyelashesNatural)
        beautyAbilities[.beautyMakeupEyelashesTender] = eyelashesAbility(.beautyMakeupEyelashesTender)
        beautyAbilities[.beautyMakeupEyelashesCurl] = eyelashesAbility(.beautyMakeupEyelashesCurl)
        beautyAbilities[.beautyMakeupEyelashesEverlong] = eyelashesAbility(.beautyMakeupEyelashesEverlong)
        beautyAbilities[.beautyMakeupEyelashesThick] = eyelashesAbility(.beautyMakeupEyelashesThick)
        
        // Makeup - Eyeliner
        beautyAbilities[.beautyMakeupEyelinerReset] = eyelinerAbility(.beautyMakeupEyelinerReset)
        beautyAbilities[.beautyMakeupEyelinerNatural] = eyelinerAbility(.beautyMakeupEyelinerNatural)
        beautyAbilities[.beautyMakeupEyelinerCatEye] = eyelinerAbility(.beautyMakeupEyelinerCatEye)
        beautyAbilities[.beautyMakeupEyelinerNaughty] = eyelinerAbility(.beautyMakeupEyelinerNaughty)
        beautyAbilities[.beautyMakeupEyelinerInnocent] = eyelinerAbility(.beautyMakeupEyelinerInnocent)
        beautyAbilities[.beautyMakeupEyelinerDignified] = eyelinerAbility(.beautyMakeupEyelinerDignified)
        
        // Makeup - Eyeshadow
        beautyAbilities[.beautyMakeupEyeshadowReset] = eyeshadowAbility(.beautyMakeupEyeshadowReset)
        beautyAbilities[.beautyMakeupEyeshadowPinkMist] = eyeshadowAbility(.beautyMakeupEyeshadowPinkMist)
        beautyAbilities[.beautyMakeupEyeshadowShimmerPink] = eyeshadowAbility(.beautyMakeupEyeshadowShimmerPink)
        beautyAbilities[.beautyMakeupEyeshadowTeaBrown] = eyeshadowAbility(.beautyMakeupEyeshadowTeaBrown)
        beautyAbilities[.beautyMakeupEyeshadowBrightOrange] = eyeshadowAbility(.beautyMakeupEyeshadowBrightOrange)
        beautyAbilities[.beautyMakeupEyeshadowMochaBrown] = eyeshadowAbility(.beautyMakeupEyeshadowMochaBrown)
        
        // Makeup - Colored Contacts
        beautyAbilities[.beautyMakeupColoredContactsReset] = coloredAbility(.beautyMakeupColoredContactsReset)
        beautyAbilities[.beautyMakeupColoredContactsDarknightBlack] = coloredAbility(.beautyMakeupColoredContactsDarknightBlack)
        beautyAbilities[.beautyMakeupColoredContactsStarryBlue] = coloredAbility(.beautyMakeupColoredContactsStarryBlue)
        beautyAbilities[.beautyMakeupColoredContactsBrownGreen] = coloredAbility(.beautyMakeupColoredContactsBrownGreen)
        beautyAbilities[.beautyMakeupColoredContactsLightsBrown] = coloredAbility(.beautyMakeupColoredContactsLightsBrown)
        beautyAbilities[.beautyMakeupColoredContactsChocolateBrown] = coloredAbility(.beautyMakeupColoredContactsChocolateBrown)
        
        // Style-Makeup
        beautyAbilities[.beautyStyleMakeupReset] = styleAbility(.beautyStyleMakeupReset)
        beautyAbilities[.beautyStyleMakeupInnocentEyes] = styleAbility(.beautyStyleMakeupInnocentEyes)
        beautyAbilities[.beautyStyleMakeupMilkyEyes] = styleAbility(.beautyStyleMakeupMilkyEyes)
        beautyAbilities[.beautyStyleMakeupCutieCool] = styleAbility(.beautyStyleMakeupCutieCool)
        beautyAbilities[.beautyStyleMakeupPureSexy] = styleAbility(.beautyStyleMakeupPureSexy)
        beautyAbilities[.beautyStyleMakeupFlawless] = styleAbility(.beautyStyleMakeupFlawless)
        
        // Stickers
        beautyAbilities[.stickerReset] = stickerAbility(.stickerReset)
        beautyAbilities[.stickerAnimal] = stickerAbility(.stickerAnimal)
        beautyAbilities[.stickerDive] = stickerAbility(.stickerDive)
        beautyAbilities[.stickerCat] = stickerAbility(.stickerCat)
        beautyAbilities[.stickerWatermelon] = stickerAbility(.stickerWatermelon)
        beautyAbilities[.stickerDeer] = stickerAbility(.stickerDeer)
        beautyAbilities[.stickerCoolGirl] = stickerAbility(.stickerCoolGirl)
        beautyAbilities[.stickerClown] = stickerAbility(.stickerClown)
        beautyAbilities[.stickerClawMachine] = stickerAbility(.stickerClawMachine)
        beautyAbilities[.stickerSailorMoon] = stickerAbility(.stickerSailorMoon)
    }
    
    private func filterAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: FilterEditor(effects: effects, path: type.path), type: type)
    }
    
    private func lipsAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: LipstickEditor(effects: effects, path: type.path), type: type)
    }
    
    private func blusherAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: blusherEditor(effects: effects, path: type.path), type: type)
    }
    
    private func eyelashesAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: eyelashesEditor(effects: effects, path: type.path), type: type)
    }
    
    private func eyelinerAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: eyelinerEditor(effects: effects, path: type.path), type: type)
    }
    
    private func eyeshadowAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: eyeshadowEditor(effects: effects, path: type.path), type: type)
    }
    
    private func coloredAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: coloredContactsEditor(effects: effects, path: type.path), type: type)
    }
    
    private func styleAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: styleMakeupEditor(effects: effects, path: type.path), type: type)
    }
    
    private func stickerAbility(_ type: BeautyType) -> BeautyAbility {
        return BeautyAbility(minValue: 0, maxValue: 100, defaultValue: 50, editor: stickerEditor(effects: effects, path: type.path), type: type)
    }
}

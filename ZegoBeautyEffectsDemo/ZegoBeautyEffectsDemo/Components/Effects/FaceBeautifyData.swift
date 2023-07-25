//
//  FaceBeautifyData.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/9.
//

import Foundation

struct FaceBeautifyData {
    
    static var beautyAbilities: [BeautyType: BeautyAbility] = ZegoEffectsService.shared.beautyAbilities
    
    static var data: [BeautyTypeItem] {
        return [
            basicItem,
            advancedItem,
            filtersItem,
            lipsItem,
            blusherItem,
            eyelashesItem,
            eyelinerItem,
            eyeshadowItem,
            coloredContactsItem,
            styleMakeupItem,
            stickersItem,
            backgroundItem,
        ]
    }
    
    static var basicItem: BeautyTypeItem = {
        let types: [BeautyType] = [
            .beautyBasicReset,
            .beautyBasicSmoothing,
            .beautyBasicSkinTone,
            .beautyBasicBlusher,
            .beautyBasicSharpening,
            .beautyBasicWrinkles,
            .beautyBasicDarkCircles,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyBasicReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .basic,
                                       items: items,
                                       title: "Basic",
                                       titleWidth: 80.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var advancedItem: BeautyTypeItem = {
        let types: [BeautyType] = [
            .beautyAdvancedReset,
            .beautyAdvancedFaceSlimming,
            .beautyAdvancedEyesEnlarging,
            .beautyAdvancedEyesBrightening,
            .beautyAdvancedChinLengthening,
            .beautyAdvancedMouthReshape,
            .beautyAdvancedTeethWhitening,
            .beautyAdvancedNoseSlimming,
            .beautyAdvancedNoseLengthening,
            .beautyAdvancedFaceShortening,
            .beautyAdvancedMandibleSlimming,
            .beautyAdvancedCheekboneSlimming,
            .beautyAdvancedForeheadSlimming,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyAdvancedReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .advanced,
                                       items: items,
                                       title: "Advanced",
                                       titleWidth: 80.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var filtersItem: BeautyTypeItem = {
        let types: [BeautyType] = [
            .filterReset,
            .filterNaturalCreamy,
            .filterNaturalBrighten,
            .filterNaturalFresh,
            .filterNaturalAutumn,
            .filterGrayMonet,
            .filterGrayNight,
            .filterGrayFilmlike,
            .filterDreamySunset,
            .filterDreamyCozily,
            .filterDreamySweet,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .filterReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .filter,
                                       items: items,
                                       title: "Filters",
                                       titleWidth: 80.0,
                                       iconRadius: 5.0)
        return titleItem
    }()
    
    static var lipsItem: BeautyTypeItem = {
        let types: [BeautyType] = [
            .beautyMakeupLipstickReset,
            .beautyMakeupLipstickCameoPink,
            .beautyMakeupLipstickSweetOrange,
            .beautyMakeupLipstickRustRed,
            .beautyMakeupLipstickCoral,
            .beautyMakeupLipstickRedVelvet,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyMakeupLipstickReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .lipstick,
                                       items: items,
                                       title: "Lipstick",
                                       titleWidth: 80.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var blusherItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .beautyMakeupBlusherReset,
            .beautyMakeupBlusherSlightlyDrunk,
            .beautyMakeupBlusherPeach,
            .beautyMakeupBlusherMilkyOrange,
            .beautyMakeupBlusherAprocitPink,
            .beautyMakeupBlusherSweetOrange,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyMakeupBlusherReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .blusher,
                                       items: items,
                                       title: "Blusher",
                                       titleWidth: 80.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var eyelashesItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .beautyMakeupEyelashesReset,
            .beautyMakeupEyelashesNatural,
            .beautyMakeupEyelashesTender,
            .beautyMakeupEyelashesCurl,
            .beautyMakeupEyelashesEverlong,
            .beautyMakeupEyelashesThick,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyMakeupEyelashesReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .eyelash,
                                       items: items,
                                       title: "Eyelashes",
                                       titleWidth: 80.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var eyelinerItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .beautyMakeupEyelinerReset,
            .beautyMakeupEyelinerNatural,
            .beautyMakeupEyelinerCatEye,
            .beautyMakeupEyelinerNaughty,
            .beautyMakeupEyelinerInnocent,
            .beautyMakeupEyelinerDignified,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyMakeupEyelinerReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .eyeliner,
                                       items: items,
                                       title: "Eyeliner",
                                       titleWidth: 80.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var eyeshadowItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .beautyMakeupEyeshadowReset,
            .beautyMakeupEyeshadowPinkMist,
            .beautyMakeupEyeshadowShimmerPink,
            .beautyMakeupEyeshadowTeaBrown,
            .beautyMakeupEyeshadowBrightOrange,
            .beautyMakeupEyeshadowMochaBrown,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyMakeupEyeshadowReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .eyeshadow,
                                       items: items,
                                       title: "Eyeshadow",
                                       titleWidth: 90.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var coloredContactsItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .beautyMakeupColoredContactsReset,
            .beautyMakeupColoredContactsDarknightBlack,
            .beautyMakeupColoredContactsStarryBlue,
            .beautyMakeupColoredContactsBrownGreen,
            .beautyMakeupColoredContactsLightsBrown,
            .beautyMakeupColoredContactsChocolateBrown,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyMakeupColoredContactsReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .coloredContacts,
                                       items: items,
                                       title: "Colored Contacts",
                                       titleWidth: 140.0,
                                       iconRadius: 22.0)
        return titleItem
    }()
    
    static var styleMakeupItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .beautyStyleMakeupReset,
            .beautyStyleMakeupInnocentEyes,
            .beautyStyleMakeupMilkyEyes,
            .beautyStyleMakeupCutieCool,
            .beautyStyleMakeupPureSexy,
            .beautyStyleMakeupFlawless,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .beautyStyleMakeupReset {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .style,
                                       items: items,
                                       title: "Style",
                                       titleWidth: 80.0,
                                       iconRadius: 5.0)
        return titleItem
    }()
        
    static var stickersItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .stickerReset,
            .stickerAnimal,
            .stickerDive,
            .stickerCat,
            .stickerWatermelon,
            .stickerDeer,
            .stickerCoolGirl,
            .stickerClown,
            .stickerClawMachine,
            .stickerSailorMoon,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            item.hasSlider = false
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .sticker,
                                       items: items,
                                       title: "Stickers",
                                       titleWidth: 80.0,
                                       iconRadius: 5.0)
        return titleItem
    }()
    
    static var backgroundItem: BeautyTypeItem = {
        
        let types: [BeautyType] = [
            .backgroundReset,
            .backgroundPortraitSegmentation,
            .backgroundMosaicing,
            .backgroundGaussianBlur,
        ]
        
        let items = types.compactMap { type in
            var item = BeautyItem(title: itemTitle(type), icon: type.rawValue, info: beautyAbilities[type]!)
            if type == .backgroundReset || type == .backgroundPortraitSegmentation {
                item.hasSlider = false
            }
            return item
        }
        
        let titleItem = BeautyTypeItem(type: .background,
                                       items: items,
                                       title: "Background",
                                       titleWidth: 100.0,
                                       iconRadius: 5.0)
        return titleItem
    }()
    
    static func itemTitle(_ type: BeautyType) -> String {
        switch type {
        case .beautyBasicReset: return "Reset"
        case .beautyBasicSmoothing: return "Smoothing"
        case .beautyBasicSkinTone: return "Skin Tone"
        case .beautyBasicBlusher: return "Blusher"
        case .beautyBasicSharpening: return "Sharpening"
        case .beautyBasicWrinkles: return "Wrinkles"
        case .beautyBasicDarkCircles: return "Dark Circles"

        case .beautyAdvancedReset: return "Reset"
        case .beautyAdvancedFaceSlimming: return "Slimming"
        case .beautyAdvancedEyesEnlarging: return "Enlarging"
        case .beautyAdvancedEyesBrightening: return "Brightening"
        case .beautyAdvancedChinLengthening: return "Lengthening"
        case .beautyAdvancedMouthReshape: return "Reshape"
        case .beautyAdvancedTeethWhitening: return "Whitening"
        case .beautyAdvancedNoseSlimming: return "Slimming"
        case .beautyAdvancedNoseLengthening: return "Lengthening"
        case .beautyAdvancedFaceShortening: return "Shortening"
        case .beautyAdvancedMandibleSlimming: return "Mandible"
        case .beautyAdvancedCheekboneSlimming: return "Cheekbone"
        case .beautyAdvancedForeheadSlimming: return "Forehead"

        case .filterReset: return "None"
        case .filterNaturalCreamy: return "Creamy"
        case .filterNaturalBrighten: return "Brighten"
        case .filterNaturalFresh: return "Fresh"
        case .filterNaturalAutumn: return "Autumn"
        case .filterGrayMonet: return "Monet"
        case .filterGrayNight: return "Night"
        case .filterGrayFilmlike: return "Film-like"
        case .filterDreamySunset: return "Sunset"
        case .filterDreamyCozily: return "Cozily"
        case .filterDreamySweet: return "Sweet"
            
        case .beautyMakeupLipstickReset: return "None"
        case .beautyMakeupLipstickCameoPink: return "Cameo Pink"
        case .beautyMakeupLipstickSweetOrange: return "Sweet Orange"
        case .beautyMakeupLipstickRustRed: return "Rust Red"
        case .beautyMakeupLipstickCoral: return "Coral"
        case .beautyMakeupLipstickRedVelvet: return "Red Velvet"
            
        case .beautyMakeupBlusherReset: return "None"
        case .beautyMakeupBlusherSlightlyDrunk: return "Slightly Drunk"
        case .beautyMakeupBlusherPeach: return "Peach"
        case .beautyMakeupBlusherMilkyOrange: return "Milky Orange"
        case .beautyMakeupBlusherAprocitPink: return "Aprocit Pink"
        case .beautyMakeupBlusherSweetOrange: return "Sweet Orange"
            
        case .beautyMakeupEyelashesReset: return "None"
        case .beautyMakeupEyelashesNatural: return "Natural"
        case .beautyMakeupEyelashesTender: return "Tender"
        case .beautyMakeupEyelashesCurl: return "Curl"
        case .beautyMakeupEyelashesEverlong: return "Everlong"
        case .beautyMakeupEyelashesThick: return "Thick"
            
        case .beautyMakeupEyelinerReset: return "None"
        case .beautyMakeupEyelinerNatural: return "Natural"
        case .beautyMakeupEyelinerCatEye: return "Cat Eye"
        case .beautyMakeupEyelinerNaughty: return "Naughty"
        case .beautyMakeupEyelinerInnocent: return "Innocent"
        case .beautyMakeupEyelinerDignified: return "Dignified"
            
        case .beautyMakeupEyeshadowReset: return "None"
        case .beautyMakeupEyeshadowPinkMist: return "Pink Mist"
        case .beautyMakeupEyeshadowShimmerPink: return "Shimmer Pink"
        case .beautyMakeupEyeshadowTeaBrown: return "Tea Brown"
        case .beautyMakeupEyeshadowBrightOrange: return "Bright Orange"
        case .beautyMakeupEyeshadowMochaBrown: return "Mocha Brown"
            
        case .beautyMakeupColoredContactsReset: return "None"
        case .beautyMakeupColoredContactsDarknightBlack: return "Darknight Black"
        case .beautyMakeupColoredContactsStarryBlue: return "StarryBlue"
        case .beautyMakeupColoredContactsBrownGreen: return "Brown Green"
        case .beautyMakeupColoredContactsLightsBrown: return "Lights Brown"
        case .beautyMakeupColoredContactsChocolateBrown: return "Chocolate Brown"
            
        case .beautyStyleMakeupReset: return "None"
        case .beautyStyleMakeupInnocentEyes: return "Innocent Eyes"
        case .beautyStyleMakeupMilkyEyes: return "Milky Eyes"
        case .beautyStyleMakeupCutieCool: return "Cutie Cool"
        case .beautyStyleMakeupPureSexy: return "Pure Sexy"
        case .beautyStyleMakeupFlawless: return "Flawless"
            
        case .stickerReset: return "None"
        case .stickerAnimal: return "Animal"
        case .stickerDive: return "Dive"
        case .stickerCat: return "Cat"
        case .stickerWatermelon: return "Watermelon"
        case .stickerDeer: return "Deer"
        case .stickerCoolGirl: return "Cool Girl"
        case .stickerClown: return "Clown"
        case .stickerClawMachine: return "Claw Machine"
        case .stickerSailorMoon: return "Sailor Moon"
            
        case .backgroundReset: return "None"
        case .backgroundPortraitSegmentation: return "Portrait Segmentation"
        case .backgroundMosaicing: return "Mosaicing"
        case .backgroundGaussianBlur: return "Gaussian Blur"
        }
    }
}

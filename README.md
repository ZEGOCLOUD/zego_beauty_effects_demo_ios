# **Advanced beauty effects**

## Prerequisites

Before you begin, make sure you complete the following:

* **Contact ZEGOCLOUD Technical Support to activate the advanced beauty effects**.

## Getting started

### Integrate the SDK

Copy the entire `Internal` folder into your own project.

<img src="https://storage.zego.im/sdk-doc/Pics/zegocloud/beauty/code_folder01.png">

### Add icon image resources.

Copy the image resources from the `BeautyItem` folder into your own project.

<img src="https://storage.zego.im/sdk-doc/Pics/zegocloud/beauty/icons.png">

### Add UI Components

Copy the entire `Components` folder into your own project.

<img src='https://storage.zego.im/sdk-doc/Pics/zegocloud/beauty/components_folder.png'>

### Add beauty effects resources

Advanced beauty effects require corresponding beauty resources to be effective.

#### Download resources

Click to download the [beauty resources](https://storage.zego.im/sdk-doc/Pics/zegocloud/uikit/BeautyResources.zip), and extract the resources to your local folder.

<img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/live/effects/beauty_resources.png">

#### Add resources

1. Open your project with Xcode.

2. Drag the downloaded `BeautyResources` folder to the directory, and select `Create folder references`.

   <img src="https://storage.zego.im/sdk-doc/Pics/ZegoUIKit/live/effects/add_folder.png">

### Add the code

#### Add the initialization code

```swift
ZegoSDKManager.shared.initWith(appID: YOUR_APP_ID, appSign: YOUR_APP_SIGN, enableBeauty: true)
```

#### ConnectUser

```swift
ZegoSDKManager.shared.connectUser(userID: userID, userName: userName) { code , message in

}
```

#### Add Beauty View

```swift
lazy var beautifyView: FaceBeautifyView = {
    let beautifyView = FaceBeautifyView(frame: view.bounds)
    view.addSubview(beautifyView)
    return beautifyView
}()
```

#### Add Beauty Button

```swift
lazy var beautifyButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(named: "icon_beauty"), for: .normal)
    button.addTarget(self, action: #selector(beautifyAction), for: .touchUpInside)
    return button
}()

override func viewDidLoad() {
		super.viewDidLoad()
  	
  	beautifyButton.frame = .init(x: 30, y: 200, width: 44, height: 44)
    view.addSubview(beautifyButton)
}

@objc func beautifyAction(_ sender: UIButton) {
    beautifyView.isHidden = false
}
```

### Delete unnecessary beauty features

Advanced beauty currently supports a total of 12 types of features, including: basic beauty, facial shaping, filters, lipstick, blush, eyeliner, eyeshadow, colored contacts, style makeup, stickers, and background segmentation.

<img src="https://storage.zego.im/sdk-doc/Pics/zegocloud/beauty/features.png">

If you don't need a certain feature, you can comment out the corresponding item in the `FaceBeautifyData.swift` file.

<img src="https://storage.zego.im/sdk-doc/Pics/zegocloud/beauty/delete_item.png">

#### Delete beauty resources

After you comment out the unnecessary beauty features, you also need to delete the unused beauty resources.

##### Basic

Do not need to delete resources.

##### Advanced

Do not need to delete resources.

##### Filters

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/filterDreamyCozily.bundle
/BeautyResources/AdvancedResources/filterDreamySunset.bundle
/BeautyResources/AdvancedResources/filterDreamySweet.bundle
/BeautyResources/AdvancedResources/filterGrayFilmlike.bundle
/BeautyResources/AdvancedResources/filterGrayMonet.bundle
/BeautyResources/AdvancedResources/filterGrayNight.bundle
/BeautyResources/AdvancedResources/filterNaturalAutumn.bundle
/BeautyResources/AdvancedResources/filterNaturalBrighten.bundle
/BeautyResources/AdvancedResources/filterNaturalCreamy.bundle
/BeautyResources/AdvancedResources/filterNaturalFresh.bundle
```

##### Lipstick

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyMakeupLipstickCameoPink.bundle
/BeautyResources/AdvancedResources/beautyMakeupLipstickCoral.bundle
/BeautyResources/AdvancedResources/beautyMakeupLipstickRedVelvet.bundle
/BeautyResources/AdvancedResources/beautyMakeupLipstickRustRed.bundle
/BeautyResources/AdvancedResources/beautyMakeupLipstickSweetOrange.bundle
```

##### Blusher

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyMakeupBlusherAprocitPink.bundle
/BeautyResources/AdvancedResources/beautyMakeupBlusherMilkyOrange.bundle
/BeautyResources/AdvancedResources/beautyMakeupBlusherPeach.bundle
/BeautyResources/AdvancedResources/beautyMakeupBlusherSlightlyDrunk.bundle
/BeautyResources/AdvancedResources/beautyMakeupBlusherSweetOrange.bundle
```

##### Eyelashes

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyMakeupEyelashesCurl.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelashesEverlong.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelashesNatural.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelashesTender.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelashesThick.bundle
```

##### Eyeliner

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyMakeupEyelinerCatEye.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelinerDignified.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelinerInnocent.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelinerNatural.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyelinerNaughty.bundle
```

##### Eyeshadow

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyMakeupEyeshadowBrightOrange.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyeshadowMochaBrown.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyeshadowPinkMist.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyeshadowShimmerPink.bundle
/BeautyResources/AdvancedResources/beautyMakeupEyeshadowTeaBrown.bundle
```

##### Colored Contacts

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyMakeupColoredContactsBrownGreen.bundle
/BeautyResources/AdvancedResources/beautyMakeupColoredContactsChocolateBrown.bundle
/BeautyResources/AdvancedResources/beautyMakeupColoredContactsDarknightBlack.bundle
/BeautyResources/AdvancedResources/beautyMakeupColoredContactsLightsBrown.bundle
/BeautyResources/AdvancedResources/beautyMakeupColoredContactsStarryBlue.bundle
```

##### StyleMakeup

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/AdvancedResources/beautyStyleMakeupCutieCool.bundle
/BeautyResources/AdvancedResources/beautyStyleMakeupFlawless.bundle
/BeautyResources/AdvancedResources/beautyStyleMakeupInnocentEyes.bundle
/BeautyResources/AdvancedResources/beautyStyleMakeupMilkyEyes.bundle
/BeautyResources/AdvancedResources/beautyStyleMakeupPureSexy.bundle
```

##### Stickers

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/StickerBaseResources.bundle
/BeautyResources/AdvancedResources/stickerAnimal.bundle
/BeautyResources/AdvancedResources/stickerCat.bundle
/BeautyResources/AdvancedResources/stickerClawMachine.bundle
/BeautyResources/AdvancedResources/stickerClown.bundle
/BeautyResources/AdvancedResources/stickerCoolGirl.bundle
/BeautyResources/AdvancedResources/stickerDeer.bundle
/BeautyResources/AdvancedResources/stickerDive.bundle
/BeautyResources/AdvancedResources/stickerSailorMoon.bundle
/BeautyResources/AdvancedResources/stickerWatermelon.bundle
```

##### Background segmentation

If you don't need this feature, you can delete the following resources.

```
/BeautyResources/BackgroundSegmentation.model
/BeautyResources/BackgroundImages/
```










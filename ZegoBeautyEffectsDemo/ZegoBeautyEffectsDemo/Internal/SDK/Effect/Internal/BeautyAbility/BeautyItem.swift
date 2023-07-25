//
//  BeautyItem.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/8.
//

import Foundation

enum BeautyItemType: UInt {
    case basic
    case advanced
    case filter
    case lipstick
    case blusher
    case eyelash
    case eyeliner
    case eyeshadow
    case coloredContacts
    case style
    case sticker
    case background
}

struct BeautyItem {
    let title: String
    let icon: String
    let info: BeautyAbility
    var hasSlider: Bool = true
}

struct BeautyTypeItem {
    let type: BeautyItemType
    let items: [BeautyItem]
    let title: String
    let titleWidth: CGFloat
    let iconRadius: CGFloat
}

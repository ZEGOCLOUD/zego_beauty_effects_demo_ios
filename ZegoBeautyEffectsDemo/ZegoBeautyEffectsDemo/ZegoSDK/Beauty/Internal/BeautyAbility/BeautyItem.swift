//
//  BeautyItem.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/8.
//

import Foundation

struct BeautyItem {
    let title: String
    let icon: String
    let info: BeautyAbility
}

struct BeautyTypeItem {
    let items: [BeautyItem]
    let title: String
    let titleWidth: CGFloat
    let iconRadius: CGFloat
}

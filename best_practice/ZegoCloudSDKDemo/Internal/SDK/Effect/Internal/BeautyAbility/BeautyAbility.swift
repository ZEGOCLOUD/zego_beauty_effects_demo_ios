//
//  BeautyAbility.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/8.
//

import Foundation

public class BeautyAbility {
    public let maxValue: Int32
    public let minValue: Int32
    public let defaultValue: Int32
    public var currentValue: Int32 = 0 {
        didSet {
            editor.apply(currentValue)
        }
    }
    
    public let editor: BeautyEditor
    public let type: BeautyType
    
    init(minValue: Int32,
         maxValue: Int32,
         defaultValue: Int32,
         editor: BeautyEditor,
         type: BeautyType) {
        self.maxValue = maxValue
        self.minValue = minValue
        self.defaultValue = defaultValue
        self.currentValue = defaultValue
        self.editor = editor
        self.type = type
    }
    
    public func reset() {
        currentValue = defaultValue
    }
    
    public func toString() -> String {
        "BeautyAbility{" + "maxValue=\(maxValue)" + ", minValue=\(minValue)" + ", defaultValue=\(defaultValue)" + ", currentValue=\(currentValue) }"
    }
}

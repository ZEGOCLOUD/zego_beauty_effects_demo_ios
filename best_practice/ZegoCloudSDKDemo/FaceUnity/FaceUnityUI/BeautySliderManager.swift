//
//  BeautySliderManager.swift
//  ZegoBeautyEffectsDemo
//
//  Created by zego on 2023/9/20.
//

import UIKit

enum FaceBeautyType: Int {
    case blur
    case white
    case red
    case eyelighting
}

class BeautySliderModel: NSObject {
    var defaultValue: Float
    var maxValue: Float
    var minValue: Float
    var beautyType: FaceBeautyType
    
    init(defaultValue: Float = 0, maxValue: Float = 0, minValue: Float = 0, beautyType: FaceBeautyType) {
        self.defaultValue = defaultValue
        self.maxValue = maxValue
        self.minValue = minValue
        self.beautyType = beautyType
    }
}

class BeautySliderManager: NSObject, BeautySliderViewDelegate {
    
    var sliderData: [BeautySliderModel] = []
    
    lazy var faceUnitySliderView: BeautySliderView = {
        let sliderView = BeautySliderView(frame: .zero)
        sliderView.isHidden = true
        sliderView.delegate = self
        return sliderView
    }()
    
    override init() {
        super.init()
        initData()
    }
    
    func initData() {
        let blurModel = BeautySliderModel(defaultValue: 1.0, maxValue: 3, minValue: 0, beautyType: .blur)
        let whiteModel = BeautySliderModel(defaultValue: 0.3, maxValue: 1, minValue: 0, beautyType: .white)
        let redModel = BeautySliderModel(defaultValue: 0.3, maxValue: 1, minValue: 0, beautyType: .red)
        let enlargingModel = BeautySliderModel(defaultValue: 0.4, maxValue: 1, minValue: 0, beautyType: .eyelighting)
        sliderData = [blurModel, whiteModel, redModel, enlargingModel]
        faceUnitySliderView.sliderArr = sliderData
        syncDataToFaceUnity()
    }
    
    func syncDataToFaceUnity() {
        for model in sliderData {
            switch model.beautyType {
            case .blur:
                FUManager.share().blurLevel = Double(model.defaultValue)
            case .white:
                FUManager.share().whiteLevel = Double(model.defaultValue)
            case .red:
                FUManager.share().redLevel = Double(model.defaultValue)
            case .eyelighting:
                FUManager.share().eyelightingLevel = Double(model.defaultValue)
            }
        }
    }
    
    func addSliderViewToView(_ view: UIView) {
        faceUnitySliderView.frame = view.bounds
        view.addSubview(faceUnitySliderView)
    }
    
    func showSliderView() {
        faceUnitySliderView.isHidden = false
    }
    
    func onSliderViewValueChange(_ value: Float, type: FaceBeautyType) {
        switch type {
        case .blur:
            FUManager.share().blurLevel = Double(value)
        case .white:
            FUManager.share().whiteLevel = Double(value)
        case .red:
            FUManager.share().redLevel = Double(value)
        case .eyelighting:
            FUManager.share().eyelightingLevel = Double(value)
        }
        updateSliderData(value, type: type)
    }
    
    func updateSliderData(_ value: Float, type: FaceBeautyType) {
        for model in sliderData {
            if model.beautyType == type {
                model.defaultValue = value
                break
            }
        }
    }

}

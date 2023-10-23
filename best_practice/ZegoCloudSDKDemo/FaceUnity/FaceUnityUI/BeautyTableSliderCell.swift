//
//  BeautyTableSliderCell.swift
//  ZegoBeautyEffectsDemo
//
//  Created by zego on 2023/9/19.
//

import UIKit

protocol BeautyTableSliderCellDelegate: AnyObject {
    func onSliderValueDidChange(_ value: Float, type: FaceBeautyType)
}

class BeautyTableSliderCell: UITableViewCell {
    
    @IBOutlet weak var beautyTitleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var model: BeautySliderModel? {
        didSet {
            if let model = model {
                setBeautyTitle(model.beautyType)
                slider.value = model.defaultValue
                slider.maximumValue = model.maxValue
                slider.minimumValue = model.minValue
            }
        }
    }
    
    weak var delegate: BeautyTableSliderCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBeautyTitle(_ type: FaceBeautyType) {
        switch type {
        case .blur:
            beautyTitleLabel.text = "磨皮"
        case .white:
            beautyTitleLabel.text = "美白"
        case .red:
            beautyTitleLabel.text = "红润"
        case .eyelighting:
            beautyTitleLabel.text = "亮眼"
        }
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        if let model = model {
            delegate?.onSliderValueDidChange(sender.value, type: model.beautyType)
        }
    }
    
}

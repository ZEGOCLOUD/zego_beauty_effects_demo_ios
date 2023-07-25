//
//  BeautyTitleCell.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/9.
//

import UIKit

class BeautyTitleCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "BeautyTitleCell.reuseIdentifier"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .init(hex: "CCCCCC")
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }
        
    override var isSelected: Bool {
        willSet {
            if newValue {
                label.textColor = .white
                label.font = .systemFont(ofSize: 16.0, weight: .semibold)
            } else {
                label.textColor = .init(hex: "CCCCCC")
                label.font = .systemFont(ofSize: 14.0)
            }
        }
    }
    
    func configUI() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func updateTitle(_ title: String) {
        label.text = title
    }
    
}

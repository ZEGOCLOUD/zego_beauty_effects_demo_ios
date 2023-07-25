//
//  BeautyItemCell.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/10.
//

import UIKit

class BeautyItemCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "BeautyItemCell.reuseIdentifier"
    
    lazy var iconBackView: UIView = {
        let iconBackView = UIView()
        iconBackView.translatesAutoresizingMaskIntoConstraints = false
        iconBackView.layer.cornerRadius = 22
        iconBackView.layer.borderColor = UIColor.init(hex: "A653FF").cgColor
        iconBackView.layer.borderWidth = 0
        return iconBackView
    }()
    
    lazy var iconImage: UIImageView = {
        let iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        return iconImage
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.textColor = .init(hex: "CCCCCC")
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return nameLabel
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
            iconBackView.layer.borderWidth = newValue ? 2 : 0
            nameLabel.textColor = newValue ? .init(hex: "A653FF") : .init(hex: "CCCCCC")
        }
    }
    
    func configUI() {
        contentView.addSubview(iconBackView)
        NSLayoutConstraint.activate([
            iconBackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            iconBackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconBackView.heightAnchor.constraint(equalToConstant: 44.0),
            iconBackView.widthAnchor.constraint(equalToConstant: 44.0)
        ])
        
        iconBackView.addSubview(iconImage)
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: iconBackView.leadingAnchor),
            iconImage.trailingAnchor.constraint(equalTo: iconBackView.trailingAnchor),
            iconImage.topAnchor.constraint(equalTo: iconBackView.topAnchor),
            iconImage.bottomAnchor.constraint(equalTo: iconBackView.bottomAnchor)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: iconBackView.bottomAnchor, constant: 6.0),
            nameLabel.centerXAnchor.constraint(equalTo: iconBackView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 16.0)
        ])
    }
    
    func update(imageName: String, title: String, iconCornerRadius: CGFloat = 22.0) {
        iconImage.image = UIImage(named: imageName)
        nameLabel.text = title
        iconBackView.layer.cornerRadius = iconCornerRadius
    }
}

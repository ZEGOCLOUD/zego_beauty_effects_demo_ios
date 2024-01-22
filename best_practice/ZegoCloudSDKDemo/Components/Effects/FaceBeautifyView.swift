//
//  FaceBeautifyView.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/9.
//

import UIKit

class FaceBeautifyView: UIView {
    lazy var backgroundView: EffectBackgroundView = {
        let view = EffectBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "111014", alpha: 0.9)
        return view
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .init(hex: "3B3B3B")
        lineView.layer.cornerRadius = 2.5
        return lineView
    }()
    
    lazy var slider: ZegoSlider = {
        let slider = ZegoSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setSliderValue(50, min: 0, max: 100)
        slider.delegate = self
        slider.isHidden = true
        return slider
    }()
    
    lazy var titleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let titleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        titleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        titleCollectionView.register(BeautyTitleCell.self, forCellWithReuseIdentifier: BeautyTitleCell.reuseIdentifier)
        titleCollectionView.backgroundColor = .clear
        titleCollectionView.dataSource = self
        titleCollectionView.delegate = self
        titleCollectionView.showsHorizontalScrollIndicator = false
        return titleCollectionView
    }()
    
    lazy var beautyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BeautyItemCell.self, forCellWithReuseIdentifier: BeautyItemCell.reuseIdentifier)
        return collectionView
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "face_beautify_reset"), for: .normal)
        return button
    }()
    
    var beautyData: FaceBeautifyData!
    var currentTypeItem: BeautyTypeItem!
    var currentAbility: BeautyAbility!
        
    var typeIndexDict: [BeautyItemType: IndexPath] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initData()
    }
    
    func initData() {        
        configUI()
        beautyData = FaceBeautifyData()
        currentTypeItem = beautyData.data.first
        titleCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func configUI() {
        
        addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(slider)
        NSLayoutConstraint.activate([
            slider.bottomAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            slider.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            slider.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 60),
            slider.heightAnchor.constraint(equalToConstant: 81.0)
        ])
        
        backgroundView.addSubview(lineView)
        NSLayoutConstraint.activate([
            lineView.widthAnchor.constraint(equalToConstant: 40.0),
            lineView.heightAnchor.constraint(equalToConstant: 5.0),
            lineView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 7.0),
            lineView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
        
        backgroundView.addSubview(titleCollectionView)
        backgroundView.addSubview(beautyCollectionView)
        NSLayoutConstraint.activate([
            titleCollectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10.0),
            titleCollectionView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 25.0),
            titleCollectionView.heightAnchor.constraint(equalToConstant: 25.0),
            titleCollectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10.0)
        ])
        NSLayoutConstraint.activate([
            beautyCollectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            beautyCollectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            beautyCollectionView.topAnchor.constraint(equalTo: titleCollectionView.bottomAnchor, constant: 32.0),
            beautyCollectionView.heightAnchor.constraint(equalToConstant: 68.0),
            beautyCollectionView.bottomAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.bottomAnchor, constant: -0.0)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let point = touch.location(in: backgroundView)
        let point2 = touch.location(in: slider)
        if backgroundView.point(inside: point, with: event) { return }
        if slider.point(inside: point2, with: event) { return }
        self.isHidden = true
    }
}

extension FaceBeautifyView: UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == titleCollectionView {
            return beautyData.data.count
        } else {
            return currentTypeItem.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == titleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeautyTitleCell.reuseIdentifier, for: indexPath) as! BeautyTitleCell
            cell.updateTitle(beautyData.data[indexPath.row].title)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeautyItemCell.reuseIdentifier, for: indexPath) as! BeautyItemCell
            let item = currentTypeItem.items[indexPath.row]
            let iconCornerRadius = currentTypeItem.iconRadius
            cell.update(imageName: item.icon, title: item.title, iconCornerRadius: iconCornerRadius)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        if collectionView == titleCollectionView {
            currentTypeItem = beautyData.data[indexPath.row]
            slider.isHidden = true
            selectBeautyItem(currentTypeItem)
        } else {
            let item = currentTypeItem.items[indexPath.row]
            let type = item.info.type
            
            if type.isReset {
                collectionView.deselectItem(at: indexPath, animated: false)
                
                // reset to default value.
                currentTypeItem.items.forEach({ $0.info.reset() })
                item.info.editor.enable(true)
                
            } else {
                item.info.editor.enable(true)
                item.info.editor.apply(item.info.currentValue)
                currentAbility = item.info
                slider.setSliderValue(item.info.currentValue,
                                      min: item.info.minValue,
                                      max: item.info.maxValue)
            }
            slider.isHidden = !item.hasSlider
            updateCurrentIndex(currentTypeItem, index: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == titleCollectionView {
            return UIEdgeInsets(top: 0, left: 5.0, bottom: 0, right: 5.0)
        } else {
            return UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == titleCollectionView {
            let w = beautyData.data[indexPath.row].titleWidth
            return CGSize(width: w, height: 25)
        } else {
            return CGSize(width: 85, height: 68)
        }
    }
}

extension FaceBeautifyView {
    func updateCurrentIndex(_ currentTypeItem: BeautyTypeItem, index: IndexPath) {
        if currentTypeItem.type == .basic || currentTypeItem.type == .advanced {
            return
        }
        typeIndexDict[currentTypeItem.type] = index
        
        if currentTypeItem.type == .style {
            typeIndexDict[.lipstick] = .init(row: 0, section: 0)
            typeIndexDict[.blusher] = .init(row: 0, section: 0)
            typeIndexDict[.eyelash] = .init(row: 0, section: 0)
            typeIndexDict[.eyeliner] = .init(row: 0, section: 0)
            typeIndexDict[.eyeshadow] = .init(row: 0, section: 0)
            typeIndexDict[.coloredContacts] = .init(row: 0, section: 0)
            typeIndexDict[.sticker] = .init(row: 0, section: 0)
        } else if currentTypeItem.type.rawValue >= BeautyItemType.lipstick.rawValue ||
                    currentTypeItem.type.rawValue <= BeautyItemType.coloredContacts.rawValue {
            typeIndexDict[.style] = .init(row: 0, section: 0)
        } else if currentTypeItem.type == .sticker {
            typeIndexDict[.style] = .init(row: 0, section: 0)
        }
    }
    
    func selectBeautyItem(_ currentTypeItem: BeautyTypeItem) {
        beautyCollectionView.reloadData()
        
        var index: IndexPath = .init(row: 0, section: 0)
        
        if currentTypeItem.type != .basic && currentTypeItem.type != .advanced {
            index = typeIndexDict[currentTypeItem.type] ?? .init(row: 0, section: 0)
            beautyCollectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
            collectionView(beautyCollectionView, didSelectItemAt: index)
        } else {
            beautyCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        }
    }
}

extension FaceBeautifyView: ZegoSliderDelegate {
    func slider(_ slider: ZegoSlider, valueDidChange value: Int32) {
        currentAbility.currentValue = value
    }
}

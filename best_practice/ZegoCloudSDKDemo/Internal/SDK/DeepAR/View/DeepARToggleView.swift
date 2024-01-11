//
//  DeepARToggleView.swift
//  ZegoCloudSDKDemo
//
//  Created by zego on 2024/1/10.
//

import UIKit

protocol DeepARToggleViewDelegate: AnyObject {
    func deepARToggleViewClick(_ type: Effects)
}

class DeepARToggleView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let effects: [DeepAREffectModel] = [
        DeepAREffectModel(.Elephant_Trunk),
        DeepAREffectModel(.Emotion_Meter),
        DeepAREffectModel(.Emotions_Exaggerator),
        DeepAREffectModel(.Fire_Effect),
        DeepAREffectModel(.Hope),
        DeepAREffectModel(.Humanoid),
        DeepAREffectModel(.MakeupLook),
        DeepAREffectModel(.Neon_Devil_Horns),
        DeepAREffectModel(.Ping_Pong),
        DeepAREffectModel(.Pixel_Hearts),
        DeepAREffectModel(.Snail),
        DeepAREffectModel(.Split_View_Look),
        DeepAREffectModel(.Stallone),
        DeepAREffectModel(.Vendetta_Mask),
        DeepAREffectModel(.burning_effect),
        DeepAREffectModel(.flower_face),
        DeepAREffectModel(.galaxy_background),
        DeepAREffectModel(.viking_helmet),
        DeepAREffectModel(.Effect_Clear)
    ]
    
    
    weak var delegate: DeepARToggleViewDelegate?
    
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    static func show() -> DeepARToggleView {
        let toggleView = DeepARToggleView(frame: CGRect(x: 50, y: (ScreenHeight - 300) / 2, width: ScreenWidth - 100, height: 300))
        KeyWindow().addSubview(toggleView)
        return toggleView
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            for subview in KeyWindow().subviews {
                if subview is DeepARToggleView {
                    let view: DeepARToggleView = subview as! DeepARToggleView
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return effects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mode = effects[indexPath.row]
        let cell: UITableViewCell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = mode.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mode = effects[indexPath.row]
        delegate?.deepARToggleViewClick(mode.effectType)
    }
}

class DeepAREffectModel: NSObject {
    
    var effectType: Effects
    var title: String = ""
    
    init(_ type: Effects) {
        effectType = type
        title = type.rawValue
    }
}

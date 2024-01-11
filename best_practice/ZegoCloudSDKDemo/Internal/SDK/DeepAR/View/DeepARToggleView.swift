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
        DeepAREffectModel(.Background_blur),
        DeepAREffectModel(.Replace_Background_Image)
    ]
    
    
    weak var delegate: DeepARToggleViewDelegate?
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapClick() {
        DeepARToggleView.dismiss()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = bounds
        tableView.frame = CGRect(x: 0, y: CGFloat(Int(bounds.height) - 300), width: bounds.width, height: 300)
    }
    
    static func show() -> DeepARToggleView {
        let toggleView = DeepARToggleView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView: UIView = UIView()
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 30))
        label.text = "DeepAR Effect"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        headView.addSubview(label)
        
        let button: UIButton = UIButton(frame: CGRect(x: bounds.width - 110, y: 5, width: 100, height: 30))
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("clear Effect", for: .normal)
        button.addTarget(self, action: #selector(clearEffectClick), for: .touchUpInside)
        headView.addSubview(button)
        return headView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mode = effects[indexPath.row]
        delegate?.deepARToggleViewClick(mode.effectType)
    }
    
    @objc func clearEffectClick() {
        delegate?.deepARToggleViewClick(.Effect_Clear)
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

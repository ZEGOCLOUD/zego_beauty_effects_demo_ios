//
//  BeautySliderView.swift
//  ZegoBeautyEffectsDemo
//
//  Created by zego on 2023/9/19.
//

import UIKit

protocol BeautySliderViewDelegate: AnyObject {
    func onSliderViewValueChange(_ value: Float, type: FaceBeautyType)
}

class BeautySliderView: UIView {
    
    var sliderArr: [BeautySliderModel] = []
    
    lazy var backgroundView: EffectBackgroundView = {
        let view = EffectBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .init(hex: "111014", alpha: 0.9)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let sliderTable = UITableView(frame: .zero, style: .plain)
        sliderTable.delegate = self
        sliderTable.dataSource = self
        sliderTable.register(UINib(nibName: "BeautyTableSliderCell", bundle: nil), forCellReuseIdentifier: "cell")
        return sliderTable
    }()
    
    weak var delegate: BeautySliderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundView)
        self.addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height: CGFloat = 40.0 * CGFloat(sliderArr.count)
        backgroundView.frame = CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height)
        tableView.frame = CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height)
        tableView.backgroundColor = UIColor.clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let point = touch.location(in: backgroundView)
        if backgroundView.point(inside: point, with: event) { return }
        self.isHidden = true
    }
}

extension BeautySliderView: UITableViewDelegate, UITableViewDataSource, BeautyTableSliderCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliderArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BeautyTableSliderCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BeautyTableSliderCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.model = sliderArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func onSliderValueDidChange(_ value: Float, type: FaceBeautyType) {
        delegate?.onSliderViewValueChange(value, type: type)
    }
}

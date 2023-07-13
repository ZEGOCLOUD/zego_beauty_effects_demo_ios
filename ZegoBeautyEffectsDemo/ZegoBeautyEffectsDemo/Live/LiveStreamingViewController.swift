//
//  LiveStreamingViewController.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/3/31.
//

import UIKit
import ZegoExpressEngine
import ZIM
import Toast_Swift

class LiveStreamingViewController: UIViewController {

    @IBOutlet weak var mainStreamView: VideoView!
    @IBOutlet weak var preBackgroundView: UIView!
    @IBOutlet weak var startLiveButton: UIButton!
    
    @IBOutlet weak var liveContainerView: UIView!
    @IBOutlet weak var userNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var flipButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var endCoHostButton: UIButton!
    @IBOutlet weak var coHostButton: UIButton!
    @IBOutlet weak var coHostWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var flipButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var beautifyButton: UIButton!
    
    lazy var beautifyView: FaceBeautifyView = {
        let beautifyView = FaceBeautifyView(frame: view.bounds)
        view.addSubview(beautifyView)
        return beautifyView
    }()
    
    var coHostVideoViews: [VideoView] = []
    
    var isMySelfHost: Bool = false
    var liveID: String = ""
    var userCount = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ZegoSDKManager.shared.expressService.addEventHandler(self)
        ZegoSDKManager.shared.zimService.addEventHandler(self)
        
        configUI()
    }
    
    func configUI() {
        liveContainerView.isHidden = isMySelfHost
        preBackgroundView.isHidden = !isMySelfHost
        if isMySelfHost {
            startPreviewIfHost()
            updateUserNameLabel(ZegoSDKManager.shared.expressService.localUser?.name)
            ZegoSDKManager.shared.expressService.turnCameraOn(true)
            ZegoSDKManager.shared.expressService.turnMicrophoneOn(true)
        } else {
            userNameLabel.isHidden = true
            coHostButton.isHidden = false
            flipButton.isHidden = true
            micButton.isHidden = true
            cameraButton.isHidden = true
            beautifyButton.isHidden = true
            
            ZegoSDKManager.shared.joinRoom(liveID, roomName:nil, isHost: false) { code, message in
                if code != 0 {
                    self.view.makeToast(message, position: .center)
                }
            }
        }
        ZegoSDKManager.shared.expressService.enableSpeaker(enable: true)
    }
    
    func updateUserNameLabel(_ name: String?) {
        userNameLabel.isHidden = false
        userNameLabel.text = name
        userNameConstraint.constant = userNameLabel.intrinsicContentSize.width + 20
    }
    
    func startPreviewIfHost() {
        preBackgroundView.isHidden = !isMySelfHost
        if isMySelfHost {
            ZegoSDKManager.shared.expressService.startPreview(mainStreamView.renderView)
        }
    }
    
    // MARK: - Actions
    @IBAction func startLive(_ sender: UIButton) {
        // join room and publish
        ZegoSDKManager.shared.joinRoom(liveID, isHost: true) { code, message in
            if code != 0 {
                self.view.makeToast(message, position: .center)
            }
        }
        ZegoSDKManager.shared.expressService.startPublishingStream()
        
        // modify UI
        preBackgroundView.isHidden = true
        liveContainerView.isHidden = false
        
        mainStreamView.update(ZegoSDKManager.shared.expressService.localUser?.id, ZegoSDKManager.shared.expressService.localUser?.name)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
        ZegoSDKManager.shared.expressService.stopPreview()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        func leaveRoom() {
            ZegoSDKManager.shared.leaveRoom()
            dismiss(animated: true)
        }
        
        if !isMySelfHost {
            leaveRoom()
            return
        }
        let alert = UIAlertController(title: "Stop the Live", message: "Are you sure to stop the live?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let okAction = UIAlertAction(title: "Stop it", style: .default) { _ in
            leaveRoom()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func switchCamera(_ sender: UIButton) {
        ZegoSDKManager.shared.expressService.useFrontFacingCamera(!ZegoSDKManager.shared.expressService.isUsingFrontCamera)
    }
    
    @IBAction func memberButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func endCoHostAction(_ sender: UIButton) {
        let localUserID = ZegoSDKManager.shared.expressService.localUser!.id
        ZegoSDKManager.shared.expressService.stopPublishingStream()
        ZegoSDKManager.shared.expressService.stopPreview()
        coHostVideoViews.forEach( { $0.removeFromSuperview() } )
        coHostVideoViews = coHostVideoViews.filter({ $0.userID != localUserID })
        updateCoHostConstraints()
        coHostButton.isHidden = false
        endCoHostButton.isHidden = true
        
        flipButton.isHidden = true
        micButton.isHidden = true
        cameraButton.isHidden = true
        beautifyButton.isHidden = true
        flipButtonConstraint.constant = 16;
    }
    
    @IBAction func micAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        ZegoSDKManager.shared.expressService.turnMicrophoneOn(!sender.isSelected)
    }
    
    @IBAction func cameraAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        ZegoSDKManager.shared.expressService.turnCameraOn(!sender.isSelected)
        
        if isMySelfHost {
            mainStreamView.enableCamera(!sender.isSelected)
        } else {
            let videoViews = coHostVideoViews.filter({ $0.userID ==  ZegoSDKManager.shared.expressService.localUser?.id})
            videoViews.forEach({ $0.enableCamera(!sender.isSelected) })
        }
    }
    
    
    @IBAction func coHostAction(_ sender: UIButton) {
        func clickButton() {
            sender.isSelected = !sender.isSelected
            coHostWidthConstraint.constant = sender.isSelected ? 210 : 165
        }
        clickButton()
        
        let senderID = ZegoSDKManager.shared.expressService.localUser?.id ?? ""
        guard let receiverID = ZegoSDKManager.shared.expressService.host?.id else {
            self.view.makeToast("Host is not in the room.", position: .center)
            clickButton()
            return
        }
        
        var customProtocol = CustomSignalingProtocol(type: .applyCoHost, senderID: senderID, receiverID: receiverID)
        if !sender.isSelected {
            customProtocol.type = .cancelCoHostApply
        }
        
        ZegoSDKManager.shared.zimService.sendCustomSignalingProtocol(customProtocol) { errorCode, errorMessage in
            if errorCode != 0 {
                self.view.makeToast("send custom signaling protocol Failed: \(errorCode)", position: .center)
                clickButton()
            }
        }
    }
    
    @IBAction func beautifyAction(_ sender: UIButton) {
        beautifyView.isHidden = false
    }
}

extension LiveStreamingViewController: ExpressServiceDelegate {
    func onRoomStreamUpdate(_ updateType: ZegoUpdateType, streamList: [ZegoStream], extendedData: [AnyHashable : Any]?, roomID: String) {
        if updateType == .add {
            for stream in streamList {
                addCoHost(stream)
            }
        } else {
            for stream in streamList {
                removeCoHost(stream)
            }
        }
    }
    
    func onRoomUserUpdate(_ updateType: ZegoUpdateType, userList: [ZegoUser], roomID: String) {
        if (updateType == .add) {
            userCount = userCount + userList.count;
        } else {
            userCount = userCount - userList.count;
        }
        memberButton.setTitle("\(userCount)", for: .normal)
    }
    
    func onCameraOpen(_ userID: String, isCameraOpen: Bool) {
        print("onCameraOpen, userID: \(userID), isCameraOpen: \(isCameraOpen)")
        let isHost = ZegoSDKManager.shared.expressService.host?.id == userID
        if isHost {
            mainStreamView.enableCamera(isCameraOpen)
        } else {
            let videoViews = coHostVideoViews.filter({ $0.userID == userID })
            videoViews.forEach({ $0.enableCamera(isCameraOpen) })
        }
    }
    
    func onMicrophoneOpen(_ userID: String, isMicOpen: Bool) {
        print("onMicrophoneOpen, userID: \(userID), isMicOpen: \(isMicOpen)")
    }
}

// MARK: - CoHost
extension LiveStreamingViewController {
    
    func onReceiveApplyCoHostRequest(_ command: CustomSignalingProtocol) {
//        self.view.makeToast("onReceiveApplyCoHostRequest", position: .center)
        func acceptOrRefuse(isAccept:Bool) {
            let senderID = ZegoSDKManager.shared.expressService.localUser?.id ?? ""
            var newCustomProtocol = CustomSignalingProtocol(type: .acceptCoHostApply, senderID: senderID, receiverID: command.senderID)
            if !isAccept{
                newCustomProtocol.type = .refuseCoHostApply
            }
            
            ZegoSDKManager.shared.zimService.sendCustomSignalingProtocol(newCustomProtocol){ errorCode, errorMessage in
                if errorCode != 0 {
                    self.view.makeToast("send custom signaling protocol Failed: \(errorCode)", position: .center)
                }
            }
        }
        let alert = UIAlertController(title: "Co-Host Requesting", message: "", preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
            acceptOrRefuse(isAccept: true)
        }
        let refuseAction = UIAlertAction(title: "Refuse", style: .default) { _ in
            acceptOrRefuse(isAccept: false)
        }

        alert.addAction(refuseAction)
        alert.addAction(acceptAction)
        present(alert, animated: true)
    }
    
    func onReceiveAcceptCoHostApply() {
//        self.view.makeToast("onReceiveAcceptCoHostApply", position: .center)
        let streamID = ""
        let userID = ZegoSDKManager.shared.expressService.localUser?.id ?? ""
        let userName = ZegoSDKManager.shared.expressService.localUser?.name ?? ""
        addCoHost(streamID, userID, userName, isMySelf: true)
        coHostButton.isHidden = true
        coHostButton.isSelected = !coHostButton.isSelected
        endCoHostButton.isHidden = false
        
        flipButton.isHidden = false
        micButton.isHidden = false
        cameraButton.isHidden = false
        beautifyButton.isHidden = false
        flipButtonConstraint.constant = 116;
    }
    
    func onReceiveCancelCoHostApply(){
//        self.view.makeToast("onReceiveCancelCoHostApply", position: .center)
    }

    func onReceiveRefuseCoHostApply(){
//        self.view.makeToast("onReceiveRefuseCoHostApply", position: .center)
        coHostButton.isSelected = !coHostButton.isSelected
        coHostWidthConstraint.constant = coHostButton.isSelected ? 210 : 165
    }
    
    func addCoHost(_ stream: ZegoStream) {
        addCoHost(stream.streamID, stream.user.userID, stream.user.userName)
    }
    
    func addCoHost(_ streamID: String, _ userID: String, _ userName: String, isMySelf: Bool = false) {
        let isHost = streamID.hasSuffix("_host")
        if isHost {
            ZegoSDKManager.shared.expressService.startPlayingStream(mainStreamView.renderView, streamID: streamID)
            updateUserNameLabel(userName)
            mainStreamView.update(userID, userName)
        }
        
        // add cohost
        else {
            
            if coHostVideoViews.count == 4 { return }
            
            let videoView = VideoView()
            videoView.update(userID, userName)
            videoView.enableBorder(true)
            coHostVideoViews.append(videoView)
            if isMySelf {
                ZegoSDKManager.shared.expressService.startPublishingStream()
                ZegoSDKManager.shared.expressService.startPreview(videoView.renderView)
            } else {
                ZegoSDKManager.shared.expressService.startPlayingStream(videoView.renderView, streamID: streamID)
            }
            updateCoHostConstraints()
        }
    }
    
    func removeCoHost(_ stream: ZegoStream) {
        ZegoSDKManager.shared.expressService.stopPlayingStream(stream.streamID)
        let isHost = stream.streamID.hasSuffix("_host")
        if isHost {
            
        } else {
            coHostVideoViews.forEach( { $0.removeFromSuperview() } )
            coHostVideoViews = coHostVideoViews.filter({ $0.userID != stream.user.userID })
            updateCoHostConstraints()
        }
    }
    
    func updateCoHostConstraints() {
        
        let bottomMargin = 85.0
        let margin = 5.0
        let w = 93.0
        let h = 124.0
        for (i, view) in coHostVideoViews.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            liveContainerView.addSubview(view)
            view.layer.cornerRadius = 5.0
            view.layer.masksToBounds = true
            
            let constant: CGFloat = bottomMargin + Double(i) * (h+margin)
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: w),
                view.heightAnchor.constraint(equalToConstant: h),
                view.trailingAnchor.constraint(equalTo: liveContainerView.trailingAnchor, constant: -16),
                view.bottomAnchor.constraint(equalTo: liveContainerView.bottomAnchor, constant: -constant)
            ])
        }
    }
}



extension LiveStreamingViewController: ZIMEventHandler {
    func zim(_ zim: ZIM, receiveRoomMessage messageList: [ZIMMessage], fromRoomID: String) {
        for message in messageList {
            if message.type == .command {
                let commandMessage = message as! ZIMCommandMessage
                let customSignalingJson = String(data: commandMessage.message, encoding: .utf8)!
                guard let customProtocol = CustomSignalingProtocolBuilder.build(customSignalingJson) else {
                    assertionFailure("Receive a error command!")
                    return
                }
                if customProtocol.receiverID != ZegoSDKManager.shared.expressService.localUser!.id{
                    return
                }
                
                switch customProtocol.type {
                case .applyCoHost:
                    onReceiveApplyCoHostRequest(customProtocol)
                case .cancelCoHostApply:
                    onReceiveCancelCoHostApply()
                case .acceptCoHostApply:
                    onReceiveAcceptCoHostApply()
                case .refuseCoHostApply:
                    onReceiveRefuseCoHostApply()
                }
             } else {
                 // ..
             }
         }
    }
}

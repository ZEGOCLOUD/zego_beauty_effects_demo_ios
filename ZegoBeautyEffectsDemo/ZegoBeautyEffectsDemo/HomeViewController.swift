//
//  HomeViewController.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/3/30.
//

import UIKit
import ZIM

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var liveIDTextField: UITextField!
    @IBOutlet weak var callTextField: UITextField!
    
    var userID: String = ""
    var userName: String = ""
    
    var invitee: UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        userIDLabel.text = "User ID: " + userID
        liveIDTextField.text = String(UInt32.random(in: 100..<10000))
        
        ZegoSDKManager.shared.zimService.addEventHandler(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let liveVC = segue.destination as? LiveStreamingViewController else {
            return
        }
        
        liveVC.isMySelfHost = segue.identifier! == "start_live"
        liveVC.liveID = liveIDTextField.text ?? ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        liveIDTextField.endEditing(true)
        callTextField.endEditing(true)
    }
    
    @IBAction func voiceCallClick(_ sender: UIButton) {
        sendCallInvitation(.voice)
    }
    
    @IBAction func videoCallClick(_ sender: UIButton) {
        sendCallInvitation(.video)
    }
}

extension HomeViewController {
    func sendCallInvitation(_ type: CallType)  {
        guard let inviteeUserID = callTextField.text else { return }
        invitee = UserInfo(id: inviteeUserID, name: "user_\(inviteeUserID)")
        //send call invitation
        ZegoCallManager.shared.sendCallInvitation(with: [inviteeUserID], type: type) { errorCode, errorMessage, invitationID, errorInvitees in
            if errorCode == 0 {
                // call waiting
                if errorInvitees.contains(inviteeUserID) {
                    self.view.makeToast("user is not online", duration: 2.0, position: .center)
                } else {
                    self.joinRoom(roomID: invitationID)
                }
            } else {
                self.view.makeToast("call failed:\(errorCode)", duration: 2.0, position: .center)
            }
        }
    }
    
    func joinRoom(roomID: String) {
        ZegoSDKManager.shared.joinRoom(roomID) { [weak self] errorCode, errorMessage in
            if errorCode == 0 {
                guard let invitee = self?.invitee else { return }
                self?.showCallWaitingPage(invitee: invitee)
            } else {
                self?.view.makeToast("join room fail\(errorCode)", duration: 2.0, position: .center)
            }
        }
    }
    
    func showCallPage() {
        let callMainPage: CallingViewController = Bundle.main.loadNibNamed("CallingViewController", owner: self, options: nil)?.first as! CallingViewController
        callMainPage.modalPresentationStyle = .fullScreen
        self.present(callMainPage, animated: true)
    }
        
    func showCallWaitingPage(invitee: UserInfo) {
        let callWaitingVC: CallWaitingViewController = Bundle.main.loadNibNamed("CallWaitingViewController", owner: self, options: nil)?.first as! CallWaitingViewController
        callWaitingVC.modalPresentationStyle = .fullScreen
        callWaitingVC.isInviter = true
        callWaitingVC.invitee = invitee
        callWaitingVC.delegate = self
        self.present(callWaitingVC, animated: true)
    }
    
    func showReceiveCallWaitingPage(inviter: UserInfo, callID: String) {
        let callWaitingVC: CallWaitingViewController = Bundle.main.loadNibNamed("CallWaitingViewController", owner: self, options: nil)?.first as! CallWaitingViewController
        callWaitingVC.modalPresentationStyle = .fullScreen
        callWaitingVC.isInviter = false
        callWaitingVC.inviter = inviter
        self.present(callWaitingVC, animated: true)
    }
}

extension HomeViewController: ZIMEventHandler {
    func zim(_ zim: ZIM, callInvitationReceived info: ZIMCallInvitationReceivedInfo, callID: String) {
        if let currentCallData = ZegoCallManager.shared.currentCallData {
            if currentCallData.callStatus == .wating || currentCallData.callStatus == .accept {
                let dataDict: [String : AnyObject] = ["reason":"busy" as AnyObject, "callID": callID as AnyObject]
                ZegoCallManager.shared.rejectCallInvitation(with: callID, data: dataDict.jsonString, callback: nil)
                return
            }
        }
        let extentedData =  info.extendedData.toDict
        let userName: String = (extentedData?["userName"] as? String) ?? ""
        let inviter = UserInfo(id: info.inviter, name: userName)
        let type: String = (extentedData?["type"] as? String) ?? "voice_call"
        var callType: CallType = .voice
        if type == "voice_call" {
            callType = .voice
        } else {
            callType = .video
        }
        if let localUser = ZegoSDKManager.shared.localUser {
            ZegoCallManager.shared.createCallData(callID, inviter: inviter, invitee: localUser, type: callType, callStatus: .wating)
        }
        
        // receive call
        guard let inviter = ZegoCallManager.shared.currentCallData?.inviter else { return }
        let dialog: ZegoIncomingCallDialog = ZegoIncomingCallDialog.show(inviter, callID: callID, type: ZegoCallManager.shared.currentCallData?.type ?? .voice)
        dialog.delegate = self
    }
    
    func zim(_ zim: ZIM, callInvitationAccepted info: ZIMCallInvitationAcceptedInfo, callID: String) {
        ZegoCallManager.shared.updateCallData(callStatus: .accept)
    }
    
    func zim(_ zim: ZIM, callInvitationRejected info: ZIMCallInvitationRejectedInfo, callID: String) {
        ZegoCallManager.shared.updateCallData(callStatus: .reject)
        ZegoCallManager.shared.clearCallData()
        
        view.makeToast("call is rejected:\(info.extendedData)", duration: 2.0, position: .center)
    }
    
    func zim(_ zim: ZIM, callInvitationCancelled info: ZIMCallInvitationCancelledInfo, callID: String) {
        ZegoCallManager.shared.updateCallData(callStatus: .cancel)
        ZegoCallManager.shared.clearCallData()
        
        //receive cancel call
        ZegoIncomingCallDialog.hide()
    }
    
    func zim(_ zim: ZIM, callInvitationTimeout callID: String) {
        ZegoCallManager.shared.updateCallData(callStatus: .timeout)
        ZegoCallManager.shared.clearCallData()
        
        ZegoIncomingCallDialog.hide()
    }
    
    func zim(_ zim: ZIM, callInviteesAnsweredTimeout invitees: [String], callID: String) {
        ZegoCallManager.shared.updateCallData(callStatus: .timeout)
        ZegoCallManager.shared.clearCallData()
        
        ZegoIncomingCallDialog.hide()
    }
}

extension HomeViewController: CallWaitingViewControllerDelegate, CallAcceptTipViewDelegate {
    func startShowCallPage(_ remoteUser: UserInfo) {
        showCallPage(remoteUser)
    }
    
    func onAcceptButtonClick(_ remoteUser: UserInfo) {
        showCallPage(remoteUser)
    }
    
    func showCallPage(_ remoteUser: UserInfo) {
        let callMainPage = Bundle.main.loadNibNamed("CallingViewController", owner: self, options: nil)?.first as! CallingViewController
        callMainPage.modalPresentationStyle = .fullScreen
        callMainPage.remoteUser = remoteUser
        self.present(callMainPage, animated: false)
    }
}

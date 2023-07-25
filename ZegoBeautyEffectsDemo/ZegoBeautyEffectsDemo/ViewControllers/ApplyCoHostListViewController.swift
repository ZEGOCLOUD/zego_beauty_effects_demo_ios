//
//  ApplyCoHostListViewController.swift
//  ZegoLiveStreamingPkbattlesDemo
//
//  Created by zego on 2023/6/30.
//

import UIKit

class ApplyCoHostListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.darkGray
            tableView.register(UINib(nibName: "CoHostTableViewCell", bundle: nil), forCellReuseIdentifier: "CoHostCell")
        }
    }
    
    var requestList: [RoomRequest] {
        get {
            var array: [RoomRequest] = []
            ZegoSDKManager.shared.zimService.roomRequestDict.forEach { (_ , request) in
                array.append(request)
            }
            return array
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ZegoSDKManager.shared.zimService.addEventHandler(self)
    }
}

extension ApplyCoHostListViewController: UITableViewDelegate, UITableViewDataSource, CoHostTableViewCellDelegate, ZIMServiceDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 5, width: 150, height: 40)
        label.text = "CoHost Apply"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.white
        view.addSubview(label)
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoHostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CoHostCell") as! CoHostTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        cell.request = requestList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func agreeCoHostApply(request: RoomRequest) {
        let roomRequest: RoomRequest? = ZegoSDKManager.shared.zimService.roomRequestDict[request.requestID]
        guard let roomRequest = roomRequest else { return }
        ZegoSDKManager.shared.zimService.acceptRoomRequest(roomRequest) { code, message, messageID in
            if code != 0 {
                self.view.makeToast("send custom signaling protocol Failed: \(code)", position: .center)
            }
            self.tableView.reloadData()
        }
    }
    
    func disAgreeCoHostApply(request: RoomRequest) {
        let roomRequest: RoomRequest? = ZegoSDKManager.shared.zimService.roomRequestDict[request.requestID]
        guard let roomRequest = roomRequest else { return }
        ZegoSDKManager.shared.zimService.rejectRoomRequest(roomRequest) { code, message, messageID in
            if code != 0 {
                self.view.makeToast("send custom signaling protocol Failed: \(code)", position: .center)
            }
            self.tableView.reloadData()
        }
    }
    
    func onCoHostApplyListUpdate() {
        tableView.reloadData()
    }
    
    func onInComingRoomRequestReceived(request: RoomRequest) {
        tableView.reloadData()
    }
    
    func onInComingRoomRequestCancelled(request: RoomRequest) {
        tableView.reloadData()
    }
    
    func onActionAcceptIncomingRoomRequest(errorCode: UInt, request: RoomRequest) {
        tableView.reloadData()
    }
    
    func onActionRejectIncomingRoomRequest(errorCode: UInt, request: RoomRequest) {
        tableView.reloadData()
    }

}

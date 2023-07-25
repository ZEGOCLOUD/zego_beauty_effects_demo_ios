import Foundation
import ZIM

public typealias ZIMServiceInviteUserCallBack = (_ code: UInt,
                                                 _ requestID: String,
                                                 _ errorInvitees: [String]) -> ()
public typealias ZIMServiceCancelInviteCallBack = (_ code: UInt,
                                                   _ requestID: String,
                                                   _ errorInvitees: [String]) -> ()
public typealias ZIMServiceAcceptInviteCallBack = (_ code: UInt,
                                                   _ requestID: String) -> ()
public typealias ZIMServiceRejectInviteCallBack = (_ code: UInt,
                                                   _ requestID: String) -> ()

extension ZIMService {
    public func sendUserRequest(userList: [String],
                                extendedData: String,
                                callback: ZIMServiceInviteUserCallBack?) {
        let config = ZIMCallInviteConfig()
        config.timeout = 60
        config.extendedData = extendedData
        zim?.callInvite(with: userList, config: config, callback: { requestID, sentInfo, errorInfo in
            let code = errorInfo.code.rawValue
            let errorInvitees = sentInfo.errorUserList.compactMap({ $0.userID })
            callback?(code, requestID, errorInvitees)
        })
    }
        
    public func cancelUserRequest(requestID: String, extendedData: String, userList: [String], callback: ZIMServiceCancelInviteCallBack?) {
        let config = ZIMCallCancelConfig()
        config.extendedData = extendedData
        zim?.callCancel(with: userList, callID: requestID, config: config, callback: { requestID, errorInvitees, errorInfo in
            callback?(errorInfo.code.rawValue, requestID, errorInvitees)
        })
    }
        
    public func acceptUserRequest(requestID: String, extendedData: String, callback: ZIMServiceAcceptInviteCallBack?) {
        let config = ZIMCallAcceptConfig()
        config.extendedData = extendedData
        zim?.callAccept(with: requestID, config: config, callback: { requestID, errorInfo in
            callback?(errorInfo.code.rawValue, requestID)
        })
    }
        
    public func refuseUserRequest(requestID: String, extendedData: String, callback: ZIMServiceRejectInviteCallBack?) {
        let config = ZIMCallRejectConfig()
        config.extendedData = extendedData
        zim?.callReject(with: requestID, config: config, callback: { requestID, errorInfo in
            callback?(errorInfo.code.rawValue, requestID)
        })
    }
}

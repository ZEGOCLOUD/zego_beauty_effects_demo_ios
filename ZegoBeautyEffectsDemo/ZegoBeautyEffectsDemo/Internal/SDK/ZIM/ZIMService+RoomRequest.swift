import Foundation
import ZIM

public typealias RoomRequestCallback =  (_ code: UInt, _ message: String, _ messageID: String?) -> ()

extension ZIMService {
            
    public func sendRoomRequest(_ receiverID: String, extendedData: String, callback: RoomRequestCallback?) {
        guard let currentUser = userInfo else { return }
        let roomRequest = RoomRequest(requestID: "", actionType: .request, senderID: currentUser.userID, receiverID: receiverID, extendedData: extendedData)
        sendRoomCommand(command: roomRequest.jsonString() ?? "") { message, error in
            if error.code == .success {
                roomRequest.requestID = "\(message.messageID)"
                var extendedDict: [String: Any] = extendedData.toDict ?? [:]
                extendedDict.updateValue(roomRequest.requestID as AnyObject, forKey: "request_id")
                roomRequest.extendedData = extendedDict.jsonString
                self.roomRequestDict.updateValue(roomRequest, forKey: roomRequest.requestID)
            }
            for delegate in self.eventHandlers.allObjects {
                delegate.onActionSendRoomRequest?(errorCode: error.code.rawValue, request: roomRequest)
            }
            callback?(error.code.rawValue, error.message, "\(message.messageID)")
        }
    }
    
    public func acceptRoomRequest(_ roomRequest: RoomRequest, callback: RoomRequestCallback?) {
        guard let currentUser = userInfo else { return }
        roomRequest.actionType = .accept
        roomRequest.receiverID = roomRequest.senderID
        roomRequest.senderID = currentUser.userID
        
        sendRoomCommand(command: roomRequest.jsonString() ?? "") { message, error in
            self.roomRequestDict.removeValue(forKey: roomRequest.requestID)
            for delegate in self.eventHandlers.allObjects {
                delegate.onActionAcceptIncomingRoomRequest?(errorCode: error.code.rawValue, request: roomRequest)
            }
            callback?(error.code.rawValue, error.message, "\(message.messageID)")
        }
        
    }
    
    public func rejectRoomRequest(_ roomRequest: RoomRequest, callback: RoomRequestCallback?) {
        guard let currentUser = userInfo else { return }
        roomRequest.actionType = .reject
        roomRequest.receiverID = roomRequest.senderID
        roomRequest.senderID = currentUser.userID
        
        sendRoomCommand(command: roomRequest.jsonString() ?? "") { message, error in
            self.roomRequestDict.removeValue(forKey: roomRequest.requestID)
            for delegate in self.eventHandlers.allObjects {
                delegate.onActionRejectIncomingRoomRequest?(errorCode: error.code.rawValue, request: roomRequest)
            }
            callback?(error.code.rawValue, error.message, "\(message.messageID)")
        }
    }
    
    public func cancelRoomRequest(_ roomRequest: RoomRequest, callback: RoomRequestCallback?) {
        guard userInfo != nil else { return }
        roomRequest.actionType = .cancel
        
        sendRoomCommand(command: roomRequest.jsonString() ?? "") { message, error in
            self.roomRequestDict.removeValue(forKey: roomRequest.requestID)
            for delegate in self.eventHandlers.allObjects {
                delegate.onActionCancelRoomRequest?(errorCode: error.code.rawValue, request: roomRequest)
            }
            callback?(error.code.rawValue, error.message, "\(message.messageID)")
        }
    }
    
    public func sendRoomCommand(command: String, callback: @escaping ZIMMessageSentCallback) {
        let bytes = command.data(using: .utf8)!
        let commandMessage = ZIMCommandMessage(message: bytes)
        zim?.sendMessage(commandMessage, toConversationID: currentRoom?.baseInfo.roomID ?? "", conversationType: .room, config: ZIMMessageSendConfig(), notification: nil, callback: callback)
    }
    
    public func getRoomRequestByRequestID(_ requestID: String) -> RoomRequest? {
        return roomRequestDict[requestID]
    }
    
    public func getRoomRequestBySenderID(userID: String) -> RoomRequest? {
        for roomRequest in roomRequestDict.values {
            if roomRequest.senderID == userID {
                return roomRequest
            }
        }
        return nil;
    }
    
    public func getRequestUserList() -> [String] {
        var userList: [String] = []
        if let userInfo = userInfo {
            for roomRequest in roomRequestDict.values {
                if (roomRequest.receiverID == userInfo.userID) {
                    userList.append(roomRequest.senderID)
                }
            }
        }
        return userList
    }
    
    public func isUserRequested(senderID: String) -> Bool {
        for roomRequest in roomRequestDict.values {
            if (roomRequest.senderID == senderID) {
                return true
            }
        }
        return false
    }
    
    public func removeAllRequest() {
        roomRequestDict.removeAll()
    }

}

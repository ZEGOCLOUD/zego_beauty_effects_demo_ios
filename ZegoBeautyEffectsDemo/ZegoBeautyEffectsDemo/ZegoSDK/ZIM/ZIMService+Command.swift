//
//  ZIMService+Command.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/7/5.
//

import Foundation
import ZIM

extension ZIMService {
    func sendCustomSignalingProtocol(_ customProtocol: CustomSignalingProtocol, callback: CommonCallback?) {
        
        guard let roomID = self.currentRoom?.baseInfo.roomID else {
            assertionFailure("Please join the room first!")
            callback?(-1, "Please join the room first!")
            return
        }
        
        guard let protocolStr = customProtocol.jsonString() else {
            assertionFailure("customProtocol error: \(customProtocol)")
            callback?(-2, "customProtocol error: \(customProtocol)")
            return
        }
        
        let bytes = protocolStr.data(using: .utf8)!
        let commandMessage = ZIMCommandMessage(message: bytes)

        zim?.sendMessage(commandMessage, toConversationID: roomID, conversationType: .room, config: ZIMMessageSendConfig(), notification: nil, callback: { msg, error in
            callback?(Int(error.code.rawValue), error.message)
        })
    }
}

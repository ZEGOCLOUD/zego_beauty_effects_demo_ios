//
//  CustomCommand.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/4/6.
//

import Foundation

public struct CustomSignalingProtocol: Codable {
    public var type: CustomSignalingProtocolType
    public var senderID: String
    public var receiverID: String
        
    public func jsonString() -> String? {
        do {
            let data = try JSONEncoder().encode(self)
            if let str = String(data: data, encoding: .utf8) {
                return str
            }
        } catch {
            return nil
        }
        return nil
    }
}

public struct CustomSignalingProtocolBuilder {
    public static func build(_ jsonString: String) -> CustomSignalingProtocol? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let customProtocol = try JSONDecoder().decode(CustomSignalingProtocol.self, from: jsonData)
                return customProtocol
            } catch {
                return nil
            }
        }
        return nil
    }
}

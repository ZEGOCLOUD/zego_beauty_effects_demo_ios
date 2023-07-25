//
//  APIBase.swift
//  ZegoLiveStreamingCohostingDemo
//
//  Created by Kael Ding on 2023/5/6.
//

import Foundation

public class APIBase {
    public static func GET(_ urlStr: String, callback: @escaping (_ error: NSError?, _ response: [String: Any]?) -> ()) {
        let url = URL(string: urlStr)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { data, response, error in
            let error = error as? NSError
            let dict = data?.toDict
            callback(error, dict)
        }
        task.resume()
    }
}

//
//  NetworkTools.swift
//
//  Created by Weslie on 2017/5/19.
//  Copyright © 2017年 Weslie. All rights reserved.
//

import AFNetworking

// define enumeration types
enum RequestMethod: String {
    case get = "get"
    case post = "post"
}

class NetworkTools: AFHTTPSessionManager {
    // create NetworkTool singleton
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tools
    }()
}

extension NetworkTools {

    typealias requestCallbackType = (_ result: AnyObject?, _ error: Error?) -> ()
    
    func request(method: RequestMethod, urlString: String, parameters: Any?, finished: @escaping requestCallbackType) {
        
        // call back closure
        let successCallback = { (task:  URLSessionDataTask, result: Any?) in
            finished(result as AnyObject, nil)
        }
        let failureCallback = { (task:  URLSessionDataTask?, error: Error) in
            finished(nil, error)
        }
        
        // network request
        if method == .get{
            get(urlString, parameters: parameters, progress: nil, success: successCallback, failure: failureCallback)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: successCallback, failure: failureCallback)
        }
    }
}

extension NetworkTools {
    
//    func loadAccessToken(code: String, finished: @escaping (_ result: [String : AnyObject]?, _ error : Error?) -> ()) {
//        // 1. fetch request url
//        let urlString = "https://api.weibo.com/oauth2/access_token"
//        
//        // token based http header post resuest
//        // self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
//        
//        // 2. fetch request paraments
//        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
//
//        // 3. send post request
//        request(method: .post, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
//            // request succeeded
//            guard let resultDict = result as? [String: AnyObject] else {
//                finished(nil, error)
//                return
//            }
//            // call back to outside view controller
//            finished(resultDict, error)
//        }
//    }
}


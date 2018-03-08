//
//  NetworkTool+Feedback.swift
//  Partner
//
//  Created by YJ on 2018/3/8.
//

import UIKit

extension NetWorkTool {
    // MARK:- 意见反馈
    func sendFeedback(token: String, feedContent: String, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/feedback/api/send.do"
        let parameters = ["token" : token, "feedContent" : feedContent]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}

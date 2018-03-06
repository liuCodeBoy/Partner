//
//  Network+Identity.swift
//  Partner
//
//  Created by Weslie on 02/03/2018.
//

import UIKit

extension NetWorkTool {
    // MARK:- 身份列表
    func getIndentityList(token: String, type: Int, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/identity/api/getIndentityList.do"
        let parameters = ["token" : token, "type" : type] as [String : Any]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}

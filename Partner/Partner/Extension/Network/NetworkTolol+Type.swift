//
//  NetworkTolol+Type.swift
//  Partner
//
//  Created by YJ on 2018/3/7.
//

import UIKit

extension NetWorkTool {
    
    // MARK:- 企业类型列表
    func getCompanyTypeList(token: String, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/type/api/getCompanyTypeList.do"
        let parameters = ["token" : token]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}

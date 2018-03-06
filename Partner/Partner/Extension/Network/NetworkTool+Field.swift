//
//  NetworkTool+Field.swift
//  Partner
//
//  Created by YJ on 2018/3/6.
//

import UIKit

extension NetWorkTool {
    // MARK:- 行业领域列表
    func getFieldList(finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/field/api/getFieldList.do"
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}

//
//  NetworkTool+Industry.swift
//  Partner
//
//  Created by Weslie on 03/03/2018.
//

import UIKit

extension NetWorkTool {
    // MARK:- 投资行业列表
    func getInvestIndustryList(finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/industry/api/getInvestIndustryList.do"
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}


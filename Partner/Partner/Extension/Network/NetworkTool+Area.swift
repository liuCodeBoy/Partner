//
//  NetworkTool+Area.swift
//  Partner
//
//  Created by Weslie on 01/03/2018.
//

import UIKit

extension NetWorkTool {
    
    // MARK:- 获取省份和城市列表
    func getProvinceAndCityList(finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/area/api/getProvinceAndCityList.do"
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}

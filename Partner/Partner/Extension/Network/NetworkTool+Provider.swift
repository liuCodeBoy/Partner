//
//  NetworkTool+Provider.swift
//  Partner
//
//  Created by YJ on 2018/3/9.
//

import UIKit
extension NetWorkTool {
    
    // MARK:- 7.1.精选服务商
    func getSelectedProviderList(finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/provider/api/getSelectedProviderList.do"
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- 7.2.搜索服务商
    func searchProvider(pageNum: Int, pageSize: Int, fuzzy: String, type: Int, name: String, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/project/api/updateProjectDesc.do"
        let parameters = ["pageNum" : pageNum, "pageSize" : pageSize, "fuzzy" : fuzzy, "type" : type, "name" : name] as [String : Any]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- 7.3.浏览服务商
    func scanProvider(id: Int, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/provider/api/scanProvider.do"
        let parameters = ["id" : id] as [String : Any]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- 7.4.获取服务商信息
    func getProviderInfo(id: Int, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/provider/api/getProviderInfo.do"
        let parameters = ["id" : id] as [String : Any]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
}

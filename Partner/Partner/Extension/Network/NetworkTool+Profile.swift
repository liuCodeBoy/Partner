//
//  NetworkTool+Profile.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

extension NetWorkTool {

    // MARK:- 获取我的页面信息
    func getSocialcleMomentList(token:String , type : Int , pageNum : Int, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        let urlString = "http://47.97.110.89/qm/moment/api/getSocialConnMomentList.do"
        let parameters = ["token" : token , "type" : type, "pageNum" : pageNum] as [String : Any]
        request(.GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }

}

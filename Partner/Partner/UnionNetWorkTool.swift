//
//  UnionNetWorkTool.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit

extension NetWorkTool {
    
    //完善合作需求
    func getSocialCircleMomentList(token:String , type : Int , pageNum : Int, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/moment/api/getSocialConnMomentList.do"
        //2.获取请求参数
        let parameters = ["token" : token , "type" : type, "pageNum" : pageNum] as [String : Any]
        //3.发送请求参数
        request(.GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    

}

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
    
    
   //http://47.97.110.89/qm/circle/api/getMyCircleList.do
   //我的圈子列表（circle/getMyCircleList）
    func getMyCircleList(token:String ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/getMyCircleList.do"
        //2.获取请求参数
        let parameters = ["token" : token] as [String : Any]
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
    
    //其他圈子列表（circle/getOtherCircleList）
    func getOtherCircleList(token:String , pageNum : Int , pageSize : Int, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/getOtherCircleList.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"pageNum" : pageNum, "pageSize" : pageSize] as [String : Any]
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
    
    
    // 创建圈子
    func circleCreated(token:String , membIds : String , circName : String, circDesc : String , image : UIImage? , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/create.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"circle.circName" : circName, "circle.circDesc" : circDesc ,"membIds" : membIds] as [String : Any]
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload avatar
            if image != nil {
                let cateName = "image"
                if let imageData = UIImageJPEGRepresentation(image!, 0.5){
                    let imageName =  self?.getNowTime()
                    formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                }
            }
            }, progress: { (Progress) in
                
        }, success: { (_, success) in
            guard let resultDict = success as? [String : AnyObject] else {
                return}
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    
    
    // 获取成员 搜索用户
    func searchUserList(token:String , type : Int , fuzzy : String, circleId : Int ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/user/api/circle/searchUserList.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"type" : type, "circleId" : circleId , "fuzzy" : fuzzy] as [String : Any]
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
    
    
    //获取圈详情 getCircleDetailInfo
    func getCircleDetailInfo(token:String , id : Int ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/getCircleDetailInfo.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id] as [String : Any]
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
    
    
    //getCircleSetInfo
    func getCircleSetInfo(token:String , id : Int ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/getCircleSetInfo.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id] as [String : Any]
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

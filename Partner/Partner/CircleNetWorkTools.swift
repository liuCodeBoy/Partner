//
//  CircleNetWorkTools.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/1.
//

//
//  UnionNetWorkTool.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit

extension NetWorkTool {
    //发布动态（moment/send）
    func momentSend(token:String , circleIds : String? , momeContent : String , momePublic : Int?, image : [UIImage]? , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/moment/api/send.do"
        //2.获取请求参数
        var parameters = ["token" : token , "moment.momeContent" : momeContent ,"moment.momePublic" : momePublic ?? 1] as [String : Any]
        //"circleIds" : circleIds ,
        if momePublic == 2 {
            parameters.updateValue(circleIds ?? "", forKey: "circleIds")
        }
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload avatar
            if image != nil {
                let cateName = "images"
                let count = image!.count as Int
                guard count != 1 else{
                    return
                }
                for i in 0..<count-1 {
                    let pic = image![i]
                    if let imageData = UIImageJPEGRepresentation(pic, 0.5){
                        let imageName =  self?.getNowTime()
                        formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                    }
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
    
    
    
    
    
    
    //我的圈子列表（发布动态接口使用）（circle/getMyCircleEntityList）
    func getMyCircleEntityList(token:String ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/getMyCircleEntityList.do"
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
    
    
    
    // 修改圈子基本信息（圈子设置页面）（circle/updateSocialCircle）
    //type
    //类型，1修改圈子名称 2封面 3描述
    
    func updateSocialCircle(token : String , circleId : Int , type : Int, circleName : String?, image : UIImage?, desc : String?, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/updateSocialCircle.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"circleId" : circleId ,"type" : type , "circleName" : circleName ?? "", "desc" :desc ?? "" ] as [String : Any]
        //3.发送请求参数
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
    
    
    //解散圈子（circle/dissolveCircle）
    func dissolveCircle(token:String , id : Int ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/dissolveCircle.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //    退出圈子（circle/withdrawCircle）
    func withdrawCircle(token:String , id : Int ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/withdrawCircle.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    
    
    //获取圈子成员列表（circle/getCircleMemberList）
    func getCircleMemberList(token:String , id : Int ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/getCircleMemberList.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    
    //邀请加入圈子 – 圈子创建者（circle/inviteJoin）
    func inviteJoin(token:String , id : Int , userId : Int, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/inviteJoin.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id , "userId" : userId] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    
    //9.10.申请加入圈子 – 非圈子创建者（circle/applyJoin）
    func applyJoin(token:String , id : Int , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/applyJoin.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"id" : id] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    
    //举报原因列表（report/getReportReasonList）
    func getReportReasonListinviteJoin(finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/report/api/getReportReasonList.do"
        //2.获取请求参数
        let parameters = [:] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    // 举报（report/report）
    func report(token:String , repoType : Int , reaId : Int, id :Int, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/report/api/report.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"repoType" : repoType, "reaId" : reaId, "id" :id] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    
    //通知列表（notice/api/list）
    func getNoticeApiList(token:String ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/notice/api/list.do"
        //2.获取请求参数
        let parameters = ["token" : token] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //社联通知列表（notice/api/socialconn/list）
    func getNoticeSocialConnList(token:String ,pageNum : Int,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/notice/api/socialconn/list.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"pageNum" : pageNum] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //审核圈子成员 - 申请/受邀请（circle/api/member/approve）
    func getCircleMemberApprove(token:String ,circleMembId:Int, type:Int, op : Int, userId : Int,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()){
        //1.获取请求的URLString
        let urlString = "http://47.97.110.89/qm/circle/api/member/approve.do"
        //2.获取请求参数
        let parameters = ["token" : token ,"circleMembId" : circleMembId,"type" : type ,"op":op, "userId":userId] as [String : Any]
        //3.发送请求参数
        request(.POST , urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
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


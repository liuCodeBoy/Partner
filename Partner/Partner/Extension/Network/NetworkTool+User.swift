//
//  NetworkTool+Profile.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit
extension NetWorkTool {

    // MARK:- 获取我的页面信息
    func getMyPageInfo(token: String, finished: @escaping(_ result :[String : AnyObject]? , _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/user/api/getMyPageInfo.do"
        let parameters = ["token" : token]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- 获取我的信息
    func getMyInfo(token: String, finished: @escaping(_ result :[String : AnyObject]? , _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/user/api/getMyInfo.do"
        let parameters = ["token" : token]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- 用户编辑
    func editUser(token: String,
                  image: UIImage?,
                  userName: String,
                  userGender: Int,
                  userMail: String,
                  userCompanyName: String,
                  userJob: String,
                  communityId: Int,
                  identityId: Int,
                  userHobby: String,
                  userSkill: String,
                  userRequire: String,
                  userDesc: String?,
                  finished: @escaping(_ result :[String : AnyObject]? , _ error: Error?) ->()) {
        
        let urlString = "http://47.97.110.89/qm/user/api/editUser.do"
        var parameters = ["token"               : token,
                          "user.userName"       : userName,
                          "userGender"          : userGender,
                          "user.userMail"       : userMail,
                          "user.userCompanyName": userCompanyName,
                          "user.userJob"        : userJob,
                          "user.communityId"    : communityId,
                          "user.identityId"     : identityId,
                          "user.userHobby"      : userHobby,
                          "user.userSkill"      : userSkill,
                          "user.userRequire"    : userRequire
            ] as [String : Any]
        if userDesc != nil {
            parameters.updateValue(userDesc!, forKey: "user.userDesc")
        }
        if image != nil {
            parameters.updateValue(image!, forKey: "image")
        }
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload image
            if image != nil {
                let cateName = "image"
                if let imageData = UIImageJPEGRepresentation(image!, 0.5){
                    let imageName = self?.getNowTime()
                    formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName!, mimeType: "image/png")
                }
            }
            }, progress: { (Progress) in
        }, success: { (_, success) in
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    
    // MARK:- 修改密码IOS
    func changePwd(token: String, phone: String, newPwd: String, code: String, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/user/api/ios/changePwd.do"
        let parameters = ["token" : token, "phone" : phone, "newPwd" : newPwd, "code" : code]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }

}

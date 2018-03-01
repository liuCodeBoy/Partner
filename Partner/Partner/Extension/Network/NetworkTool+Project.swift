//
//  NetworkTool+Project.swift
//  Partner
//
//  Created by Weslie on 01/03/2018.
//

import UIKit
extension NetWorkTool {
    
    // MARK:- 创建项目
    func changePwd(token        : String,
                   logo         : UIImage,
                   fields       : String,
                   projName     : String,
                   projCompName : String,
                   projConnName : String,
                   projPhone    : String,
                   projMail     : String,
                   idenId       : Int,
                   areaId       : Int,
                   roundId      : Int,
                   finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {

        let urlString = "http://47.97.110.89/qm/project/api/create.do"
        let parameters = ["token"                 : token,
                          "fields"                : fields,
                          "project.projName"      : projName,
                          "project.projCompName"  : projCompName,
                          "project.projConnName"  : projConnName,
                          "project.projPhone"     : projPhone,
                          "project.projMail"      : projMail,
                          "project.idenId"        : idenId,
                          "project.areaId"        : areaId,
                          "project.roundId"       : roundId
            ] as [String : Any]
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload image
            let cateName = "image"
            if let imageData = UIImageJPEGRepresentation(logo, 0.5){
                let imageName = self?.getNowTime()
                formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName!, mimeType: "image/png")
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
}

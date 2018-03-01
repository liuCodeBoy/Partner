//
//  NetworkTool+CopyModel.swift
//  Partner
//
//  Created by Weslie on 01/03/2018.
//

import UIKit

extension NetWorkTool {
    // MARK:- single
    func singleRequest(token: String, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/"
        let parameters = ["token" : token]
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- multiple
    func multiRequ(token        : String,
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
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    func nullablePara(token: String, userDesc: String?, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/"
        var parameters = ["token" : token]
        
        // MARK:- nullable parament
        if userDesc != nil {
            parameters.updateValue(userDesc!, forKey: "user.userDesc")
        }
        
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            finished(resultDict, error)
        }
    }
    
    // MARK:- withImage
    func withImage(token: String, image: UIImage?, finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/"
        let parameters = ["token" : token]
       
        
        // TODO:- with image
        
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
    
    
}

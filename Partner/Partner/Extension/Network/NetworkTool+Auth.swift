//
//  NetworkTool+Auth.swift
//  Partner
//
//  Created by YJ on 2018/3/6.
//

import UIKit

extension NetWorkTool {
    
    // MARK:- 投资商认证
    func authInvestor(token            : String,
                      image            : UIImage,
                      nameCard         : UIImage,
                      industryIds      : String,
                      inveRealName     : String,
                      invePhone        : String,
                      inveMail         : String,
                      inveRound        : Int,
                      idenId           : Int,
                      instName         : String?,
                      instJobName      : String?,
                      inTime           : String?,
                      finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/auth/api/authInvestor.do"
        var parameters = ["token"                   : token,
                          "nameCard"                : nameCard,
                          "industryIds"             : industryIds,
                          "investor.inveRealName"   : inveRealName,
                          "investor.invePhone"      : invePhone,
                          "investor.inveMail"       : inveMail,
                          "investor.inveRound"      : inveRound,
                          "investor.idenId"         : idenId
            ] as [String : Any]
        
        if idenId == 5 {
            if instName != nil && instJobName != nil && inTime != nil {
                parameters.updateValue(instName!, forKey: "institut.instName")
                parameters.updateValue(instJobName!, forKey: "institute.instJobName")
                parameters.updateValue(inTime!, forKey: "inTime" )
            } else {
                return
            }
        }
        
        // TODO:- with image
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload image
            if let image = UIImageJPEGRepresentation(image, 0.5) {
                let imageName = self?.getNowTime()
                formData.appendPart(withFileData: image, name: "image", fileName: imageName!, mimeType: "image/png")
            }
            if let nameCard = UIImageJPEGRepresentation(nameCard, 0.5) {
                let imageName = self?.getNowTime()
                formData.appendPart(withFileData: nameCard, name: "nameCard", fileName: imageName!, mimeType: "image/png")
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
    
    // MARK:- 企业认证
    func authCompany(token            : String,
                   logo             : UIImage,
                   licence          : UIImage,
                   typeIds          : String,
                   compName         : String,
                   compConn         : String,
                   compConnPhone    : String,
                   compConnMail     : String,
                   compDesc         : String,
                   compCreditCode   : Int,
                   compRepresent    : String,
                   compCardNo       : String,
                   compAddrDetail   : String,
                   areaId           : Int,
                   finished: @escaping(_ result: [String : AnyObject]?, _ error: Error?) ->()) {
        let urlString = "http://47.97.110.89/qm/auth/api/authCompany.do"
        let parameters = ["token"                   : token,
                          "ntypeIds"                : typeIds,
                          "icompany.compName"       : compName,
                          "icompany.compConn"       : compConn,
                          "icompany.compConnPhone"  : compConnPhone,
                          "icompany.compConnMail"   : compConnMail,
                          "icompany.compDesc"       : compDesc,
                          "icompany.compCreditCode" : compCreditCode,
                          "company.compRepresent"   : compRepresent,
                          "company.compCardNo"      : compCardNo,
                          "company.compAddrDetail"  : compAddrDetail,
                          "company.areaId"          : areaId
            ] as [String : Any]
        
        // TODO:- with image
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload image
            if let logo = UIImageJPEGRepresentation(logo, 0.5) {
                let imageName = self?.getNowTime()
                formData.appendPart(withFileData: logo, name: "logo", fileName: imageName!, mimeType: "image/png")
            }
            if let licence = UIImageJPEGRepresentation(licence, 0.5) {
                let imageName = self?.getNowTime()
                formData.appendPart(withFileData: licence, name: "licence", fileName: imageName!, mimeType: "image/png")
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

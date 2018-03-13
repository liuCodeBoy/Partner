//
//  ProjectModel.swift
//  Partner
//
//  Created by Weslie on 03/03/2018.
//

import MJExtension

class ProjectListModel: NSObject {
    
    @objc var projectId     : NSNumber?
    @objc var logoUrl       : String?
    @objc var projName      : String?
    // 项目状态，0未融资 1审核中 2通过 3审核不通过
    @objc var status        : NSNumber?
    // id, fieldName
    @objc var fields        :[NSDictionary]?
    @objc var pub           : NSNumber?
    @objc var focusNum      : NSNumber?
    @objc var scanNum       : NSNumber?
    @objc var focus         : NSNumber?
    @objc var create        : NSNumber?
    @objc var desc          : String?
    
}

class ProjectModel: NSObject {
    
    // MARK:- create project
    @objc var logo             : UIImage?
    @objc var fields           : String?
    @objc var projName         : String?
    @objc var projCompName     : String?
    @objc var projConnName     : String?
    @objc var projPhone        : String?
    @objc var projMail         : String?
    @objc var idenId           : NSNumber?
    @objc var areaId           : NSNumber?
    @objc var roundId          : NSNumber?
    
}

class ProjectBasicInfoModel: NSObject {
    
    // MARK:- view project info
    @objc var projectId        : NSNumber?
    @objc var logoUrl          : String?
    @objc var projName         : String?
    @objc var compName         : String?
    @objc var connName         : String?
    @objc var phone            : String?
    @objc var mail             : String?
    @objc var idenId           : NSNumber?
    @objc var idenName         : String?
    @objc var areaId           : NSNumber?
    @objc var areaName         : String?
    @objc var roundId          : NSNumber?
    @objc var roundName        : String?
    // id, fieldName
    @objc var fields           :[NSDictionary]?
    
    @objc var status           : NSNumber?
    ////////////////
    @objc var operation        : NSNumber?
    @objc var foucsNum         : NSNumber?
    @objc var scanNum          : NSNumber?
    @objc var applyNum         : NSNumber?
    
}

class ProjectMemberModel: NSObject {
    
    @objc var id            : NSNumber?
    @objc var image         : UIImage?
    @objc var imgUrl        : String?
    @objc var name          : String?
    @objc var desc          : String?
    //c是否是项目创建者，1是 0否
    @objc var create        : NSNumber?
    @objc var idenId        : NSNumber?
    @objc var idenName      : String?
    @objc var jobName       : String?
    @objc var mail          : String?
    
}

class ProjectDetialModel: NSObject {

    
//    "projectId": 48,
//    "status": 0,
//    "operation": null,
//    "logoUrl": "http://47.97.110.89/ftp/qm/project/logo/2018/3/10/721450b9-95ad-4f2e-b44d-8f166dea4e75.png",
//    "projName": "weslie",
//    "roundName": "上市",
//    "areaName": "北京市",
//    "foucsNum": 0,
//    "scanNum": 0,
//    "applyNum": 0,
//    "fields": [],
//    "planName": null,
//    "planUrl": null,
//    "projDesc": null,
//    "projHighlights": null,
//    "projUserGroup": null,
//    "projProfitModel": null,
//    "projCompetitor": null,
//    "projResources": null,
//    "projMonthIncome": null,
//    "projMonthUser": null,
//    "projTotalUser": null,
//    "projDataRemark": null,
//    "projFinancing": null,
//    "projShare": null,
//    "projValue": null,
//    "projFundPlan": null,
//    "currency": null,
//    "membImgUrls": [
//    "http://47.97.110.89/ftp/qm/user/default/default.png"
//    ],
//    "membNum": 1,
//    "membInfos": null
    
    
}



//
//  ProjectModel.swift
//  Partner
//
//  Created by Weslie on 03/03/2018.
//

import MJExtension

class ProjectListModel: NSObject {
    
    @objc var projectId         : NSNumber?
    @objc var logoUrl           : String?
    @objc var projName          : String?
    @objc var cityName          : String?
    // 项目状态，0未融资 1审核中 2通过 3审核不通过
    @objc var status            : NSNumber?
    // id, fieldName
    @objc var fields            :[NSDictionary]?
    @objc var pub               : NSNumber?
    @objc var focusNum          : NSNumber?
    @objc var scanNum           : NSNumber?
    @objc var focus             : NSNumber?
    @objc var create            : NSNumber?
    @objc var desc              : String?
    var isSelected : Bool?
}

class ProjectModel: NSObject {
    
    // MARK:- create project
    @objc var logo              : UIImage?
    @objc var fields            : String?
    @objc var projName          : String?
    @objc var projCompName      : String?
    @objc var projConnName      : String?
    @objc var projPhone         : String?
    @objc var projMail          : String?
    @objc var idenId            : NSNumber?
    @objc var areaId            : NSNumber?
    @objc var roundId           : NSNumber?
    
}

class ProjectBasicInfoModel: NSObject {
    
    // MARK:- view project info
    @objc var projectId         : NSNumber?
    @objc var logoUrl           : String?
    @objc var projName          : String?
    @objc var compName          : String?
    @objc var connName          : String?
    @objc var phone             : String?
    @objc var mail              : String?
    @objc var idenId            : NSNumber?
    @objc var idenName          : String?
    @objc var areaId            : NSNumber?
    @objc var areaName          : String?
    @objc var roundId           : NSNumber?
    @objc var roundName         : String?
    // id, fieldName
    @objc var fields            :[NSDictionary]?
    
    @objc var status            : NSNumber?
    ////////////////
    @objc var operation         : NSNumber?
    @objc var foucsNum          : NSNumber?
    @objc var scanNum           : NSNumber?
    @objc var applyNum          : NSNumber?
    
}

class ProjectMemberModel: NSObject {
    
    @objc var id                : NSNumber?
    @objc var image             : UIImage?
    @objc var imgUrl            : String?
    @objc var name              : String?
    @objc var desc              : String?
    //c是否是项目创建者，1是 0否
    @objc var create            : NSNumber?
    @objc var idenId            : NSNumber?
    @objc var idenName          : String?
    @objc var jobName           : String?
    @objc var mail              : String?
    
}

class ProjectDetialModel: NSObject {

    // MARK:- basic info
    @objc var projectId         : NSNumber?
    // 项目状态 0未提交 1审核中 2审核通过 3审核不通过
    @objc var status            : NSNumber?
    // reEdit
    @objc var isEdit            : NSNumber?
    @objc var logoUrl           : String?
    @objc var projName          : String?
    @objc var roundName         : String?
    @objc var areaName          : String?
    @objc var foucsNum          : NSNumber?
    @objc var scanNum           : NSNumber?
    @objc var applyNum          : NSNumber?
    @objc var fields            :[NSDictionary]?
    
    @objc var planName          : String?
    @objc var planUrl           : String?
    
    @objc var projDesc          : String?
    @objc var projHighlights    : String?
    @objc var membImgUrls       :[String]?
    @objc var membInfos         :[NSDictionary]?

    @objc var projUserGroup     : String?
    @objc var projProfitModel   : String?
    @objc var projCompetitor    : String?
    @objc var projResources     : String?

    @objc var projMonthIncome   : NSNumber?
    @objc var projMonthUser     : NSNumber?
    @objc var projTotalUser     : NSNumber?
    @objc var projDataRemark    : String?

    @objc var projFinancing     : NSNumber?
    @objc var projShare         : NSNumber?
    @objc var projValue         : NSNumber?
    @objc var projFundPlan      : String?
    @objc var currency          : String?
    @objc var currencyId        : NSNumber?

}



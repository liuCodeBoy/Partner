//
//  ProjectModel.swift
//  Partner
//
//  Created by Weslie on 03/03/2018.
//

import MJExtension

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

class ProjectDetialModel: NSObject {
    
    // MARK:- basic info
    @objc var basicInfo         : ProjectBasicInfoModel?
    
    
    
}

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

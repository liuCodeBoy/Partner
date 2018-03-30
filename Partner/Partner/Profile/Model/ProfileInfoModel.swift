//
//  ProfileInfoModel.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import MJExtension

class ProfileInfoModel: NSObject {
    
    // auth and identity
    @objc var idenId            : NSNumber?
    // 认证状态，0未认证 1认证中 2认证通过 3认证不通过，普通用户身份返回null
    @objc var auth              : NSNumber?
    // 第二认证状态，投资商身份且审核通过后有效，0未认证 1认证中 2认证通过 3认证不通过
    @objc var secAuth           : NSNumber?
    // 用户状态 1有效 0禁用
    @objc var status            : NSNumber?
    
    // user basic
    @objc var uid               : NSNumber?
    @objc var userImgUrl        : String?
    @objc var userName          : String?
    @objc var gender            : NSNumber?
    // profile main
    @objc var percent           : NSNumber?
    @objc var officecubicleNum  : NSNumber?
    @objc var boardroomNum      : NSNumber?
    @objc var fieldNum          : NSNumber?
    // detial info
    @objc var phone             : String?
    @objc var mail              : String?
    @objc var compName          : String?
    @objc var userJob           : String?
    @objc var jobName           : String?
    @objc var communityId       : NSNumber?
    @objc var commName          : String?
    @objc var hobby             : String?
    @objc var skill             : String?
    @objc var require           : String?
    @objc var desc              : String?

}


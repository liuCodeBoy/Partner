//
//  AuthInfoModel.swift
//  Partner
//
//  Created by YJ on 2018/3/7.
//

import MJExtension

class AuthInfoModel: NSObject {

    @objc var inveAuthId        : NSNumber?
    @objc var imgUrl            : String?
    @objc var nameCardUrl       : String?
    @objc var inveRound         : String?
    
    // only for assign value
    @objc var roundId           : NSNumber?
    
    @objc var realName          : String?
    @objc var inveIndentity     : String?
    @objc var inveIdentity      : String?
    
    // only for assign value
    @objc var inveIdenId        : NSNumber?
    
    @objc var industryList      :[NSDictionary]?
    @objc var phone             : String?
    @objc var mail              : String?
    @objc var instName          : String?
    @objc var instJobName       : String?
    @objc var inTime            : String?
    @objc var auth              : NSNumber?
    @objc var userIdenId        : NSNumber?
    
}

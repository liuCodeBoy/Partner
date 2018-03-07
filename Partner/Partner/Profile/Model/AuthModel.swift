//
//  AuthModel.swift
//  Partner
//
//  Created by YJ on 2018/3/6.
//

import MJExtension

class AuthModel: NSObject {
    
    // investor auth
    @objc var image            : UIImage?
    @objc var nameCard         : UIImage?
    @objc var industryIds      : String?
    @objc var inveRealName     : String?
    @objc var invePhone        : String?
    @objc var inveMail         : String?
    @objc var inveRound        : NSNumber?
    @objc var idenId           : NSNumber?
    @objc var instName         : String?
    @objc var instJobName      : String?
    @objc var inTime           : String?
    
    // enterprise auth
    @objc var logo             : UIImage?
    @objc var licence          : UIImage?
    @objc var typeIds          : String?
    @objc var compName         : String?
    @objc var compConn         : String?
    @objc var compConnPhone    : String?
    @objc var compConnMail     : String?
    @objc var compDesc         : String?
    @objc var compCreditCode   : NSNumber?
    @objc var compRepresent    : String?
    @objc var compCardNo       : String?
    @objc var compAddrDetail   : String?
    @objc var areaId           : NSNumber?

}

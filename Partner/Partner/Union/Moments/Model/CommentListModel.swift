//
//  CommentListModel.swift
//  Partner
//
//  Created by Weslie on 07/03/2018.
//

import UIKit
import MJExtension

class CommentListModel: NSObject {
    
    @objc  var   commentId    : NSNumber?
    @objc  var   userId    : NSNumber?
    @objc  var   idenId    : NSNumber?
    @objc  var   auth      : NSNumber?
    @objc  var   secAuth   : NSNumber? // 同时通过企业认证和投资认证
    @objc  var   commUserId    : NSNumber?
    @objc  var   level     : NSNumber?
    @objc  var   commUserName  : String?
    @objc  var   commentDate   : NSString?
    @objc  var   comments    : [NSDictionary]?

    
    
    @objc  var   momentId    : NSNumber?
    @objc  var   userImgUrl  : NSString?
    @objc  var   userName    : String?
    @objc  var   userIdenId  : NSNumber?
    @objc  var   userAuth    : NSNumber?
    @objc  var   commName    : NSString?
    @objc  var   content     : NSString?
    @objc  var   imgUrls     : [NSString]?
    @objc  var   sendDate    : NSString?
    @objc  var   commentNum  : NSNumber?
    @objc  var   thumbNum    : NSNumber?
    @objc  var   thumb       : NSNumber?
    @objc  var   my          : NSNumber?
    @objc  var   uid         : NSNumber?
    

}

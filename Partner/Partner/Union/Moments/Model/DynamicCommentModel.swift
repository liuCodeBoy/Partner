//
//  DynamicCommentModel.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/5.
//

import UIKit
import MJExtension
class DynamicCommentModel: NSObject {
    @objc  var   commentId        :  NSNumber?
    @objc  var   userId           :  NSNumber?
    @objc  var   idenId           :  NSNumber?
    @objc  var   auth             :  NSNumber?
    @objc  var   secAuth          :  NSNumber?
    @objc  var   commUserId       :  NSNumber?
    @objc  var   level            :  NSNumber?
    @objc  var   thumbNum         :  NSNumber?
    @objc  var   thumb            :  NSNumber?
    @objc  var   my               :  NSNumber?

    @objc  var   userImgUrl       : String?
    @objc  var   userName         : String?
    @objc  var   commName         : String?
    @objc  var   commUserName     : String?
    @objc  var   content          : String?
    @objc  var   commentDate      : String?
}

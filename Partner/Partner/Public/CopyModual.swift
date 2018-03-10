//
//  CopyModual.swift
//  Partner
//
//  Created by YJ on 2018/3/7.
//

import UIKit

class CopyModel: UIViewController {
    
    override func viewDidLoad() {
        NetWorkTool.shareInstance.getAuthInfo(token: access_token!, type: 1) { (result, error) in
            
            
            // MARK:- result call back in network request
            
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model 
                weakSelf?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                    weakSelf?.navigationController?.popViewController(animated: true)
                })
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
            
            
        }
    }
    
}


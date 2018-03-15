//
//  ProjectReviewConfirmButtonTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit
import SCLAlertView

class ProjectReviewConfirmButtonTableViewCell: UITableViewCell {
    
    var projID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnClicked(_ sender: ShadowButton) {
        guard let id = projID else { return }
        
        let userId = UserDefaults.standard.integer(forKey: "uid")
        guard userId != 0 else { return }
        NetWorkTool.shareInstance.deliverProject(token: access_token!, userId: userId, projectId: id) { (result, error) in
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                SCLAlertView().showSuccess("投递成功", subTitle: "")
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
}

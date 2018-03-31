//
//  ProjectEditConfirmButtonTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

let deliverProjectNotification = "com.Partner.project.deliver"

class ProjectEditConfirmButtonTableViewCell: UITableViewCell {
    
    var isVerified = false
    
    var projID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let id = viewModel?.projectId {
                self.projID = id as? Int
            }
            if let status = viewModel?.status {
                reEditView.isHidden = true
                switch status {
                case 0:
                    btn.setTitle("开始融资", for: .normal)
                case 1:
                    btn.setTitle("审核中", for: .normal)
                    btn.isEnabled = false
                case 2:
                    btn.setTitle("投递项目", for: .normal)
                    isVerified = true
                // did not pass
                case 3: reEditView.isHidden = false
                default: break
                }
            }
        }
    }
    
    @IBOutlet weak var reEditView: UIView!
    @IBOutlet weak var btnBackView: UIView!
    @IBOutlet weak var btn: ShadowButton!
    @IBAction func btnClicked(_ sender: ShadowButton) {
        
        if !isVerified {
            guard let id = projID else { return }
            
            NetWorkTool.shareInstance.beginProject(token: access_token!, id: id) { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data into model
                    SCLAlertView().showSuccess("融资成功", subTitle: "")
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        } else {
            NotificationCenter.default.post(name: NSNotification.Name.init(deliverProjectNotification), object: nil)
        }
        
    }
    
}

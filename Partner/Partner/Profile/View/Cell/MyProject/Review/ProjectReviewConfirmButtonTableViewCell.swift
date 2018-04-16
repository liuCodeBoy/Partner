//
//  ProjectReviewConfirmButtonTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit
import SCLAlertView

let pushInvestorNotification = "com.Partner.Project.review.push.invest"

class ProjectReviewConfirmButtonTableViewCell: UITableViewCell {
    
    var projID: Int?
    var operation: Int? {
        didSet {
            if let id = operation {
                // 操作类型，1投递项目 2融资提交 3融资审核中 4已融资 5认证投资人
                switch id {
                case 1: btn.setTitle("投递项目", for: .normal)
                case 2: btn.setTitle("融资提交", for: .normal)
                case 3:
                    btn.setTitle("融资审核中", for: .normal)
                    btn.isEnabled = false
                case 4: btn.setTitle("已融资", for: .normal)
                case 5: btn.setTitle("认证投资人", for: .normal)
                default: break
                }
            }
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var btn: ShadowButton!
    @IBAction func btnClicked(_ sender: ShadowButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init(pushInvestorNotification), object: operation)
        
    }
    
}

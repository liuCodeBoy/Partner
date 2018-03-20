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

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnClicked(_ sender: ShadowButton) {
        
        NotificationCenter.default.post(name: NSNotification.Name.init(pushInvestorNotification), object: nil)
        
    }
    
}

//
//  ProjectEditMembersBriefTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class ProjectEditMembersBriefTableViewCell: UITableViewCell {
    
    var imgURLs: [String]? {
        didSet {
            if let imgURLs = imgURLs {
                memberCount = imgURLs.count
                if imgURLs.count <= 5 {
                    // 1. hide all
                    for img in avatarImg {
                        img.isHidden = true
                    }
                    // 2. set image and show
                    for i in 0..<imgURLs.count {
                        avatarImg[i].sd_setImage(with: URL.init(string: imgURLs[i]), placeholderImage: nil, options: .continueInBackground, completed: nil)
                        avatarImg[i].isHidden = false
                    }
                } else {
                    for j in 0..<5 {
                        avatarImg[j].sd_setImage(with: URL.init(string: imgURLs[j]), placeholderImage: nil, options: .continueInBackground, completed: nil)
                    }
                }
            } else {
                // hide all
                for img in avatarImg {
                    img.isHidden = true
                }
                // set label title
                membersCountLbl.text = "添加成员"
            } 
        }
    }
    var memberCount: Int? {
        didSet {
            membersCountLbl.text = "\(memberCount!)个"
        }
    }

    
    @IBOutlet var avatarImg: [UIImageView]!
    
    @IBOutlet weak var membersCountLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

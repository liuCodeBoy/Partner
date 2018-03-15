//
//  ProjectReviewMemberIntroductionTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectReviewMemberIntroductionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectMemberModel? {
        didSet {
            if let avatar = viewModel?.imgUrl {
                avatarImg.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.name {
                nickNameLbl.text = name
            }
            if let job = viewModel?.jobName {
                jobLbl.text = job
            }
            if let detial = viewModel?.desc {
                descLbl.text = detial
            }
        }
    }

}

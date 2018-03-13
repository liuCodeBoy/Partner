//
//  ProjectEditSingleTeamMemberTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/12.
//

import UIKit

class ProjectEditSingleTeamMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    
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
            if let detial = viewModel?.desc {
                detialLbl.text = detial
            }
        }
    }

}

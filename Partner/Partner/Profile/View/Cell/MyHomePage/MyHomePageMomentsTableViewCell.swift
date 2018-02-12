//
//  MyHomePageMomentsTableViewCell.swift
//  Partner
//
//  Created by Weslie on 08/02/2018.
//

import UIKit

class MyHomePageMomentsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImg: RoundRectImage!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var createTimeLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var momentsDetialLbl: UILabel!
    
    @IBAction func commentBtnClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var likeBtn: UIButton!
    @IBAction func likeBtnClicked(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

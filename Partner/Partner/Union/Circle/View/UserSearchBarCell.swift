//
//  UserSearchBarCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/23.
//

import UIKit

class UserSearchBarCell: UITableViewCell {
    @IBOutlet weak var userIndentifyBtn: UIButton!
    @IBOutlet weak var imageHeaderView: UIImageView!
    @IBOutlet weak var nameTextLab: UILabel!
    @IBOutlet weak var communityLab: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    var  indexRowNum : NSNumber?
    
    var viewModel: UserModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.nameTextLab.text = viewModel.userName
            self.communityLab.text = viewModel.userComm
            if let  imageUrl =  viewModel.userImgUrl {
                self.imageHeaderView.setImageWith(URL.init(string: imageUrl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
            
            if viewModel.create == 1 {
                self.selectedBtn.isHidden = false
            }else{
                self.selectedBtn.isHidden = true
            }
        }
    }
    @IBAction func chooseUser(_ sender: Any) {
//        self.selectedBtn.isSelected  = !self.selectedBtn.isSelected
        
    }
    
    
    
}

//
//  WatingJionInCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit

class WatingJionInCell: UITableViewCell {
    @IBOutlet weak var watingJionInImageHeaderView: UIImageView!
    @IBOutlet weak var watingJionInNameTextLab: UILabel!
    @IBOutlet weak var watingJionInCommunityLab: UILabel!
    @IBOutlet weak var watingJionInStatusBtnLeft: UIButton!
    @IBOutlet weak var watingJionInStatusBtnRight: UIButton!

    var  indexRowNum : NSNumber?
    
    var viewModel: UserModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.watingJionInNameTextLab.text = viewModel.userName
            self.watingJionInCommunityLab.text = viewModel.userComm
            if let  imageUrl =  viewModel.userImgUrl {
                self.watingJionInImageHeaderView.setImageWith(URL.init(string: imageUrl)!, placeholderImage: nil)
            }
            
//            if viewModel.create == 1 {
//                self.selectedBtn.isHidden = false
//            }else{
//                self.selectedBtn.isHidden = true
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

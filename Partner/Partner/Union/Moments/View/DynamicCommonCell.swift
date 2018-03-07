//
//  DynamicCommonCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/5.
//

import UIKit

class DynamicCommonCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var identifyIcon: UIButton!
    
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var sourceFrom: UILabel!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var commentNumLab: UILabel!
    @IBOutlet weak var zanNumLab: UILabel!
//    @IBOutlet weak var deleteLab: UILabel!
//    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var zanBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    var viewModel: CommentListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImage.sd_setImage(with: URL.init(string: viewModel.userImgUrl! as String), placeholderImage: nil)
            
            var   userIdentify : String?
            if let identID = viewModel.userIdenId{
                switch Int(truncating: identID) {
                case 1:
                    userIdentify = "投资商"
                    break
                case 2:
                    userIdentify = "创业者"
                    break
                case 3:
                    userIdentify = "普通用户"
                    break
                default:
                    break
                }
                identifyIcon.setTitle(userIdentify, for: .normal)
            }
            
//            if viewModel.my == 1 {
//
//                deleteBtn.isHidden = false
//                deleteLab.isHidden = false
//
//            }else if viewModel.my == 0 {
//
//                deleteBtn.isHidden = true
//                deleteLab.isHidden = true
//
//            }
            
            
            //设置评论数
            if let  commentNum = viewModel.commentNum{
                if commentNum != 0 {
                    self.commentBtn.isSelected = true
                    self.commentNumLab.text = "\(commentNum)"
                }else{
                    self.commentBtn.isSelected = false
                    self.commentNumLab.text = "\(0)"
                }
            }
            //设置点赞数
            if let  thumbNum = viewModel.thumbNum{
                if thumbNum != 0 {
                    self.zanBtn.isSelected = true
                    self.zanNumLab.text = "\(thumbNum)"
                }else{
                    self.zanBtn.isSelected = false
                    self.zanNumLab.text = "\(0)"
                }
            }
            
            nickname.text = viewModel.userName
            createAt.text = viewModel.commentDate! as String
            if let name = viewModel.commName{
                sourceFrom.text = name as String
            }
            
            contentText.text = viewModel.content as String?
            
        }
        
    }

}

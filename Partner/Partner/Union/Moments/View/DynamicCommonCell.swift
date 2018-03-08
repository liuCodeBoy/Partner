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
                self.commentBtn.isSelected = true
                if viewModel.level == 2 {
                    if viewModel.my == 1 {
                   
                        commentNumLab.text = "删除"
                        commentBtn.setImage(#imageLiteral(resourceName: "moments_delete"), for: .selected)
                    }else{
                        commentNumLab.text = "回复"
                        commentBtn.setImage(#imageLiteral(resourceName: "comment_selected"), for: .selected)
                    }
                }else if viewModel.level == 1 {
                     commentNumLab.text = "评论"
                     commentBtn.setImage(#imageLiteral(resourceName: "comment_selected"), for: .selected)
                }else if viewModel.level == 3 {
                    commentNumLab.text = "删除"
                    commentBtn.setImage(#imageLiteral(resourceName: "moments_delete"), for: .selected)
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
            
            
            let  uid = UserDefaults.standard.integer(forKey: "uid")
                
         
            if let level = viewModel.level{
                guard viewModel.userName != nil else{
                    return
                }
                var tempLevelName = ""
                if level == 2{
                guard viewModel.commUserName != nil else{
                        return
                    }
                tempLevelName = viewModel.userName! + " 评论 "
                 if viewModel.commUserId as? Int == uid{
                      tempLevelName =  tempLevelName + "我"
                 }else{
                     tempLevelName  =  tempLevelName + viewModel.commUserName!
                    }
                }else if level == 3 {
                tempLevelName = viewModel.userName! + " 回复 "
                    if viewModel.commUserId as? Int == uid {
                        tempLevelName =  tempLevelName + "我"
                    }else{
                        tempLevelName  =  tempLevelName + viewModel.commUserName!
                    }
                }else{
                    tempLevelName = viewModel.userName!
                }
               nickname.text = tempLevelName
                
            }
            
            
            
            
          
            createAt.text = viewModel.commentDate! as String
            if let name = viewModel.commName{
                sourceFrom.text = name as String
            }
            
            contentText.text = viewModel.content as String?
            
        }
        
    }

    @IBAction func commentClick(_ sender: Any) {
      let dynamicDetailVC = AppDelegate.dynamicDetailVC
      dynamicDetailVC.inputTF.becomeFirstResponder()
      dynamicDetailVC.parentId = viewModel?.commentId as? Int
      dynamicDetailVC.commentType = 2
    }
  
    
    @IBAction func zanClick(_ sender: Any) {
        
    }
    
    
}

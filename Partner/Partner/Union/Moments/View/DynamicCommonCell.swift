//
//  DynamicCommonCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/5.
//

import UIKit
import NoticeBar

class DynamicCommonCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var identifyIcon: UIButton!
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var sourceFrom: UILabel!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var commentNumLab: UILabel!
    @IBOutlet weak var zanNumLab: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var zanBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    var pushVC : showVCType?
    var  dynamicIsMy : Int?
    
    var viewModel: CommentListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImage.sd_setImage(with: URL.init(string: viewModel.userImgUrl! as String), placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            let guestrue = UITapGestureRecognizer.init(target: self, action: #selector(showUserInfo))
            avatarImage.addGestureRecognizer(guestrue)
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
            let  uid = UserDefaults.standard.integer(forKey: "uid")

            if dynamicIsMy == 0 {
                deleteBtn.isHidden = false
                if viewModel.level == 2 {
                    if viewModel.my == 1 {
                        deleteBtn.isHidden = true
                    }else {
                        if viewModel.commUserId as? Int == uid{
                            deleteBtn.isHidden = false
                        }else{
                            deleteBtn.isHidden = true
                        }
                    }
                }else if viewModel.level == 1 {
                    if viewModel.my == 0 {
                        deleteBtn.isHidden = true
                    }else{
                        deleteBtn.isHidden = false
                    }
                }else if viewModel.level == 3 {
                    deleteBtn.isHidden = true
                }
            }else if dynamicIsMy == 1{
                deleteBtn.isHidden = false
                if viewModel.level == 2 {
                    if viewModel.my == 1 {
                        deleteBtn.isHidden = true
                    }else{
                        if viewModel.commUserId as? Int == uid{
                            deleteBtn.isHidden = false
                        }else{
                            deleteBtn.isHidden = true
                        }
                    }
                }else if viewModel.level == 1 {
                    if viewModel.my == 1 {
                        deleteBtn.isHidden = false
                    }
                }else if viewModel.level == 3 {
                    deleteBtn.isHidden = true
                }
            }
            
            //设置评论数
                self.commentBtn.isSelected = true
                if viewModel.level == 2 {
                    if viewModel.my == 1 {
                        
                        commentBtn.isHidden = false
                        commentNumLab.text = "删除"
                        commentBtn.setImage(#imageLiteral(resourceName: "moments_delete"), for: .selected)
                        
                    }else{
                        if viewModel.commUserId as? Int == uid {
                        commentBtn.isHidden = false
                        commentNumLab.text = "回复"
                        commentBtn.setImage(#imageLiteral(resourceName: "comment_selected"), for: .selected)
                        }else{
                            if  dynamicIsMy == 1 {
                                commentBtn.isHidden = false
                                commentNumLab.text = "删除"
                                commentBtn.setImage(#imageLiteral(resourceName: "moments_delete"), for: .selected)
                            }else {
                                commentNumLab.text = ""
                                commentBtn.isHidden = true
                            }
                        }
                    }
                }else if viewModel.level == 1 {
                     commentBtn.isHidden = false
                     commentNumLab.text = "评论"
                     commentBtn.setImage(#imageLiteral(resourceName: "comment_selected"), for: .selected)
                }else if viewModel.level == 3 {
                    if viewModel.my == 1 {
                        commentBtn.isHidden = false
                        commentNumLab.text = "删除"
                        commentBtn.setImage(#imageLiteral(resourceName: "moments_delete"), for: .selected)
                    }else{
                        commentNumLab.text = ""
                        commentBtn.isHidden = true
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
    
    @objc func showUserInfo(){
        if pushVC != nil {
            let uid = viewModel?.userId as? Int
            guard uid != nil else{
                return
            }
            pushVC!(uid!)
        }
    }
   
    @IBAction func commentClick(_ sender: UIButton) {
        let  title  = commentNumLab.text
        if title == "评论" || title == "回复"{
            let dynamicDetailVC = AppDelegate.dynamicDetailVC
            dynamicDetailVC.inputTF.becomeFirstResponder()
            dynamicDetailVC.parentId = viewModel?.commentId as? Int
            dynamicDetailVC.commentType = 2
        }else{
            let alert = UIAlertController(title: "确定要删除改动态吗", message: "", preferredStyle: .alert)
            let sureAction = UIAlertAction(title: "确认", style: .destructive) { [weak self](action) in
                guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                    return
                }
                if let id = self?.viewModel?.commentId {
                    
                    self?.deleteAction(access_token: access_token, id: Int(truncating: id))
                }
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alert.addAction(sureAction)
            alert.addAction(cancelAction)
            AppDelegate.dynamicDetailVC.present(alert, animated: true, completion: nil)
        }
        
    }
  
    @IBAction func deleteClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "确定要删除改动态吗", message: "", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确认", style: .destructive) { [weak self](action) in
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                return
            }
            if let id = self?.viewModel?.commentId {
                
                self?.deleteAction(access_token: access_token, id: Int(truncating: id))
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        AppDelegate.dynamicDetailVC.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func zanClick(_ sender: UIButton) {
        thumb(btn: sender, isThumb: self.viewModel?.thumb as! Int)

    }
    
    
}


extension  DynamicCommonCell {
    //删除评论函数
    func  deleteAction( access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.deleteComment(token: access_token, commentId: id) {(result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "删除成功"
                AppDelegate.dynamicDetailVC.refresh()
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
    
    func thumb(btn : UIButton , isThumb : Int){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        guard let id = viewModel?.commentId else{
            return
        }
        if isThumb == 1 {
            cancelThumb(btn: btn, access_token: access_token, id: Int(truncating: id))
        }else{
            getNmomentThumb(btn: btn, access_token: access_token, id: Int(truncating: id))
        }
        
    }
    
    //MARK: - 点赞方法
    
    func getNmomentThumb(btn : UIButton , access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.commentThumb(token: access_token, id: id) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "点赞成功"
                btn.isSelected = true
                self?.viewModel?.thumb = 1
                let thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) + 1
                self?.viewModel?.thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) + 1 as NSNumber
                self?.zanNumLab.text = "\(thumbNum)"
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
    
    //MARK: - 取消点赞方法
    func cancelThumb(btn : UIButton , access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.cancelCommentThumb(token: access_token, id: id) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                btn.isSelected = false
                self?.viewModel?.thumb = 0
                showInfo = "取消点赞成功"
                let thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) - 1
                self?.viewModel?.thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) - 1 as NSNumber
                self?.zanNumLab.text = "\(thumbNum)"
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
}

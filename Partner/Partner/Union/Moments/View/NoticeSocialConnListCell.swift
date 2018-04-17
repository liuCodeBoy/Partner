//
//  NoticeSocialConnListCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/28.
//

import UIKit
import NoticeBar
class NoticeSocialConnListCell: UITableViewCell {
    @IBOutlet weak var sexImage: UIImageView!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var timeTextLab: UILabel!
    @IBOutlet weak var imageHeaderView: UIImageView!
    @IBOutlet weak var nameTextLab: UILabel!
    @IBOutlet weak var communityLab: UILabel!
    @IBOutlet weak var identText: UIButton!
    var  indexRowNum : NSNumber?
//    操作类型，1同意 0拒绝
    var  optionValue = 0
    
    var viewModel: NoticeSocialConnListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let name = viewModel.senderName{
                self.nameTextLab.text = name
            }
            if let gender = viewModel.gender{
                switch gender {
                    //性别 0保密 1男 2女
                case 0:
                    self.sexImage.isHidden = false
                    self.sexImage.image = #imageLiteral(resourceName: "gender_unkonwn_grey")
                    break
                case 1:
                    self.sexImage.isHidden = false
                    self.sexImage.image = #imageLiteral(resourceName: "male")
                    break
                case 2:
                    self.sexImage.isHidden = false
                    self.sexImage.image = #imageLiteral(resourceName: "female")
                    break
                default:
                    break
                }
            }
            if let identText = viewModel.idenId {
                //身份，1投资商 2创业者 3普通用户
                switch identText {
                case 1:
                    self.identText.setTitle("投资商", for: .normal)
                    self.identText.backgroundColor = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                    break
                case 2:
                    self.identText.setTitle("创业者", for: .normal)
                    self.identText.backgroundColor = #colorLiteral(red: 0.7332935929, green: 0.8520618081, blue: 0.6388275623, alpha: 1)
                    break
                case 3:
                    self.identText.setTitle("普通用户", for: .normal)
                    self.identText.backgroundColor = #colorLiteral(red: 0.6982426047, green: 0.7371578217, blue: 0.7609840631, alpha: 1)
                    break
                default:
                    break
                }
            }
            if let status = viewModel.status{
                switch status {
                    //状态， 1待审核 2通过 3不通过（社圈邀请、申请加入的通知时有效
                case 1:
                    self.agreeBtn.isHidden = false
                    self.refuseBtn.isHidden = false
                    break
                case 2:
                    self.agreeBtn.isHidden = true
                    self.refuseBtn.isHidden = false
                    self.refuseBtn.setTitle("已通过", for: .normal)
                    break
                case 3:
                    self.agreeBtn.isHidden = true
                    self.refuseBtn.isHidden = false
                    self.refuseBtn.setTitle("已拒绝", for: .normal)
                    break
                default:
                    break
                }
            }else{
                self.agreeBtn.isHidden = true
                self.refuseBtn.isHidden = true
            }
            
            
            if let content = viewModel.content{
                if let circlename = viewModel.circleName {
                    let str = "####"
                    let result = content.replacingOccurrences(of:str, with: circlename)
                    self.communityLab.text = result
                }else{
                    self.communityLab.text = content
                }
            }
            if let  sendTime =  viewModel.sendTime{
                self.timeTextLab.text = sendTime
            }
            if let  imageUrl =  viewModel.senderImgUrl {
                self.imageHeaderView.setImageWith(URL.init(string: imageUrl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
        }
    }
    

    @IBAction func agreeBtnClick(_ sender: UIButton) {
        optionValue = 1
        getCircleMemberApprove(btn: sender)
    
    }
    
    @IBAction func refuseBtnClick(_ sender: UIButton) {
        optionValue = 0
        getCircleMemberApprove(btn: sender)
    }
    

    
    func getCircleMemberApprove(btn : UIButton){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        //圈子创建者，1是 0否（status字段不为空时有效）
        var type = 0
        if let status = viewModel?.create{
            if status == 0 {
                type = 1
            }else{
                type = 2
            }
            
        }
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.getCircleMemberApprove(token: access_token, circleMembId: viewModel?.circleMembId as! Int, type: type, op: optionValue, userId: viewModel?.applyUserId as! Int) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
               color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
               showInfo = "操作成功"
                if self?.optionValue == 0 {
                    self?.agreeBtn.isHidden = true
                     self?.refuseBtn.setTitle("已拒绝", for: .normal)
                }else{
                     self?.agreeBtn.isHidden = true
                     self?.refuseBtn.setTitle("已通过", for: .normal)
                }
            }else{
               showInfo =  result!["msg"] as! String
            }
            
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
}



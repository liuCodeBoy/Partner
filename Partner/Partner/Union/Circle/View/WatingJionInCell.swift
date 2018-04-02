//
//  WatingJionInCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit
import NoticeBar

class WatingJionInCell: UITableViewCell {
    @IBOutlet weak var watingJionInImageHeaderView: UIImageView!
    @IBOutlet weak var watingJionInNameTextLab: UILabel!
    @IBOutlet weak var watingJionInCommunityLab: UILabel!
    @IBOutlet weak var watingJionInStatusBtnLeft: UIButton!
    @IBOutlet weak var watingJionInStatusBtnRight: UIButton!
    //    操作类型，1同意 0拒绝
    var  optionValue = 0
    var  indexRowNum : NSNumber?
    
    var viewModel: UserModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            self.watingJionInNameTextLab.text = viewModel.userName
            self.watingJionInCommunityLab.text = viewModel.userComm
            if let  imageUrl =  viewModel.userImgUrl {
                self.watingJionInImageHeaderView.setImageWith(URL.init(string: imageUrl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
            
            
            if let status = viewModel.status{
                switch status {
                //状态， 1待审核 2通过 3不通过（社圈邀请、申请加入的通知时有效
                case 1:
                    if viewModel.type == 2{
                    self.watingJionInStatusBtnLeft.isHidden = true
                    self.watingJionInStatusBtnRight.isHidden = false
                    self.watingJionInStatusBtnRight.setTitle("待回复", for: .normal)
                  }else{
                    self.watingJionInStatusBtnLeft.isHidden = false
                    self.watingJionInStatusBtnRight.isHidden = false
                    self.watingJionInStatusBtnLeft.setTitle("同意", for: .normal)
                    self.watingJionInStatusBtnRight.setTitle("拒绝", for: .normal)
                  }
                    break
                case 2:
                    self.watingJionInStatusBtnLeft.isHidden = true
                    self.watingJionInStatusBtnRight.isHidden = false
                    self.watingJionInStatusBtnRight.setTitle("已通过", for: .normal)
                    break
                case 3:
                    self.watingJionInStatusBtnLeft.isHidden = true
                    self.watingJionInStatusBtnRight.isHidden = false
                    self.watingJionInStatusBtnRight.setTitle("已拒绝", for: .normal)
                    break
                default:
                    break
                }
            }else{
                self.watingJionInStatusBtnLeft.isHidden = true
                self.watingJionInStatusBtnRight.isHidden = true
            }
            
//            if viewModel.create == 1 {
//                self.selectedBtn.isHidden = false
//            }else{
//                self.selectedBtn.isHidden = true
//            }
        }
    }
    @IBAction func agreeBtnClick(_ sender: UIButton) {
        optionValue = 1
        getCircleMemberApprove(btn : sender)
    }
    
    @IBAction func refuseBtnClick(_ sender: UIButton) {
        optionValue = 0
        getCircleMemberApprove(btn : sender)
    }
    
    
    
    func getCircleMemberApprove(btn : UIButton){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        //圈子创建者，1是 0否（status字段不为空时有效）
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.getCircleMemberApprove(token: access_token, circleMembId: viewModel?.circleMembId as! Int, type: 2, op: optionValue, userId: viewModel?.uid as! Int) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "操作成功"
                if self?.optionValue == 0 {
                    self?.watingJionInStatusBtnLeft.isHidden = true
                    self?.watingJionInStatusBtnRight.setTitle("已拒绝", for: .normal)
                }else{
                    self?.watingJionInStatusBtnLeft.isHidden = true
                    self?.watingJionInStatusBtnRight.setTitle("已通过", for: .normal)
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

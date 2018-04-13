//
//  ServiceListCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/26.
//

import UIKit

class ServiceListCell: UITableViewCell {
    @IBOutlet weak var sexImage: UIImageView!
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
                if let content = viewModel.content{
                    self.communityLab.text = content
                }
                if let  sendTime =  viewModel.sendTime{
                    self.timeTextLab.text = sendTime
                }
                if let  imageUrl =  viewModel.senderImgUrl {
                    self.imageHeaderView.setImageWith(URL.init(string: imageUrl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                }
            }
        }
        

      
}



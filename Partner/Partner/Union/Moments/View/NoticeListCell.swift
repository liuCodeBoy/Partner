//
//  NoticeListCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/28.
//

import UIKit

class NoticeListCell: UITableViewCell {
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var timeTextLab: UILabel!
    @IBOutlet weak var imageHeaderView: UIImageView!
    @IBOutlet weak var nameTextLab: UILabel!
    @IBOutlet weak var communityLab: UILabel!
    var  indexRowNum : NSNumber?
    
    var viewModel: NoticeInfoModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            if viewModel.type == 1 {
                self.nameTextLab.text = "服务通知"
            }else{
                self.nameTextLab.text = "社联通知"
            }
            if let content = viewModel.content{
              self.communityLab.text = content
            }
            if let  sendTime =  viewModel.sendTime{
                self.timeTextLab.text = sendTime
            }
        }
    }
}


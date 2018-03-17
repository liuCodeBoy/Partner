//
//  ServiceProjectBriefTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit
import SCLAlertView

class ServiceProjectBriefTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLab: UILabel!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var locationLab: UILabel!
    @IBOutlet weak var scanNum: UIButton!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var detailLab: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    var type  = 1
    var model : ProjectListModel?  {
        didSet {
          
            if let logourl = model?.logoUrl{
                logoImg.setImageWith(URL.init(string: logourl)!, placeholderImage: nil)
            }
            
            if let locationStr = model?.cityName{
                locationLab.text = locationStr
            }
            
            if let viewNum = model?.scanNum{
                scanNum.setTitle("\(viewNum)", for: .normal)
            }
            
            if let provComm = model?.desc{
                detailLab.text = provComm
            }
            
            if let companyNameStr = model?.projName{
                companyNameLab.text = companyNameStr
            }
            
            if let focus = model?.focus{
                if focus == 1 {
                    type = 2
                    collectionBtn.isSelected = true
                }else{
                    collectionBtn.isSelected = false
                     type = 1
                }
            }
            
            collectionBtn.foldTag = model?.projectId as! Int
            
            if let type = model?.fields {
                for i in 0..<type.count {
                    if i == 0 {
                        let dict  = type[i] as? [String : Any]
                        tag1.text = dict?["fieldName"] as? String
                        tag2.isHidden = true
                        tag3.isHidden = true
                    }else if i == 1 {
                        let dict  = type[i] as? [String : Any]
                        tag2.text = dict?["fieldName"] as? String
                        tag2.isHidden = false
                        tag3.isHidden = true
                    }else if i == 2{
                        let dict  = type[i] as? [String : Any]
                        tag3.text = dict?["fieldName"] as? String
                        tag3.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func focusClick(_ sender: UIButton) {
        guard access_token != nil else {
            return
        }
        if let focus = model?.focus{
            if focus == 1 {
                type = 2
            }else{
                type = 1
            }
        }
//        操作类型，1收藏 2取消收藏
        NetWorkTool.shareInstance.updateFocusProject(token: access_token!, id: sender.foldTag, type:type) { [weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
               SCLAlertView().showSuccess("\(String(describing: result!["msg"]!))", subTitle: "")
                if self?.type == 1 {
                   self?.model?.focus = 1
                    sender.isSelected = true
                }else{
                   self?.model?.focus = 0
                    sender.isSelected = false
                    
                }
            }else{
                SCLAlertView().showError("\(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
       }
    }
}

//
//  ProjectEditMembersBriefTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class ProjectEditMembersBriefTableViewCell: UITableViewCell {
    
    var projId: Int? {
        didSet {
            loadMemberData()
        }
    }
    
    var imgURLs: [String]? {
        didSet {
            if let imgURLs = imgURLs {
                if imgURLs.count <= 5 {
                    // 1. hide all
                    for img in avatarImg {
                        img.isHidden = true
                    }
                    // 2. set image and show
                    for i in 0..<imgURLs.count {
                        avatarImg[i].sd_setImage(with: URL.init(string: imgURLs[i]), placeholderImage: nil, options: .continueInBackground, completed: nil)
                        avatarImg[i].isHidden = false
                    }
                } else {
                    for j in 0..<5 {
                        avatarImg[j].sd_setImage(with: URL.init(string: imgURLs[j]), placeholderImage: nil, options: .continueInBackground, completed: nil)
                    }
                }
            }
            
        }
    }
    var memberCount: Int? {
        didSet {
            membersCountLbl.text = "\(memberCount!)个"
        }
    }

    
    @IBOutlet var avatarImg: [UIImageView]!
    
    @IBOutlet weak var membersCountLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func loadMemberData() {
        
        guard let projectId = projId else { return }
        NetWorkTool.shareInstance.getMemberList(token: access_token!, projectId: projectId) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                if let resultDictArray = result!["result"] as? [[String : AnyObject]] {
                    var count = 0
                    var urlArray = [String]()
                    for dict in resultDictArray {
                        let imgURL = dict["imgUrl"] as! String
                        urlArray.append(imgURL)
                        weakSelf?.imgURLs = urlArray
                        count += 1
                    }
                    weakSelf?.memberCount = count
                }
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }

}

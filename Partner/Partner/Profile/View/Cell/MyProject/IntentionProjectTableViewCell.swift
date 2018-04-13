//
//  IntentionProjectTableViewCell.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit
import SCLAlertView

class IntentionProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projLogoImg: UIImageView!
    @IBOutlet weak var projNameLbl: UILabel!
    
    @IBOutlet var tagLbl: [StrokeLabel]!
    
    
    @IBOutlet weak var refuseBtn: UIButton!
    @IBAction func refuseBtnClicked(_ sender: UIButton) {
        
        if let id = viewModel?.projectId as? Int {
            NetWorkTool.shareInstance.rejectIntendedProject(token: access_token!, projectId: id, finished: { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    
                    SCLAlertView().showSuccess("驳回成功", subTitle: "")
                    
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            })
        }
        
    }
    @IBOutlet weak var investBtn: UIButton!
    @IBAction func investBtnClicked(_ sender: UIButton) {
        
        if let id = viewModel?.projectId as? Int {
            NetWorkTool.shareInstance.investIntendedProject(token: access_token!, projectId: id, finished: { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    
                    SCLAlertView().showSuccess("投资成功", subTitle: "")
                    
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            })
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var viewModel: ProjectBasicInfoModel? {
        didSet {
            if let image = viewModel?.logoUrl {
                projLogoImg.sd_setImage(with: URL.init(string: image), placeholderImage: #imageLiteral(resourceName: "project_logo_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.projName {
                projNameLbl.text = name
            }
            if let fieldsDictArray = viewModel?.fields {
                // hide all
                for lbl in tagLbl {
                    lbl.isHidden = true
                }
                if fieldsDictArray.count == 1 {
                    tagLbl[0].isHidden = false
                    tagLbl[0].text = fieldsDictArray.first?["fieldName"] as? String
                } else {
                    let count = fieldsDictArray.count
                    if count <= 3 {
                        if count == 3 {
                            for lbl in tagLbl {
                                lbl.isHidden = false
                            }
                            for i in 0..<count {
                                tagLbl[i].text = (fieldsDictArray[i] as! [String : AnyObject])["fieldName"] as? String
                                tagLbl[i].isHidden = false
                            }
                        } else {
                            for i in 0..<count {
                                tagLbl[i].text = (fieldsDictArray[i] as! [String : AnyObject])["fieldName"] as? String
                                tagLbl[i].isHidden = false
                            }
                            for j in count..<3 {
                                tagLbl[j].isHidden = true
                            }
                        }
                    } else {
                        for k in 0..<3 {
                            tagLbl[k].text = (fieldsDictArray[k] as! [String : AnyObject])["fieldName"] as? String
                            tagLbl[k].isHidden = false
                        }
                    }
                }
            }
            
        }
    }
}

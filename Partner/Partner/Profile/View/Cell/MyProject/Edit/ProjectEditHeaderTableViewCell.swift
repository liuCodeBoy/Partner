//
//  ProjectEditHeaderTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

let pushEditProjBasicInfoNotification = "com.Partner.project.edit.push"

class ProjectEditHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projLogoImg: UIImageView!
    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var projStatusLbl: UILabel!
    @IBOutlet weak var favLbl: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    
    @IBOutlet var tagLbl: [StrokeLabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var editBtn: UIButton!
    @IBAction func editClicked(_ sender: UIButton) {
        
        if let viewModel = viewModel {
            NotificationCenter.default.post(name: NSNotification.Name.init(pushEditProjBasicInfoNotification), object: viewModel)
        }
        
    }
    
    var viewModel: ProjectBasicInfoModel? {
        didSet {
            if let status = viewModel?.status {
                if status == 0 {
                    editBtn.isHidden = false
                } else {
                    editBtn.isHidden = true
                }
            }
            if let logo = viewModel?.logoUrl {
                projLogoImg.sd_setImage(with: URL.init(string: logo), placeholderImage: #imageLiteral(resourceName: "project_logo_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.projName {
                projNameLbl.text = name
            }
            if let round = viewModel?.roundName {
                projStatusLbl.text = round
            }
            if let fav = viewModel?.foucsNum {
                favLbl.text = "收藏 \(fav)"
            }
            if let view = viewModel?.scanNum {
                viewLbl.text = "浏览 \(view)"
            }
            if let fieldsDictArray = viewModel?.fields {
                // hide all
                for lbl in tagLbl {
                    lbl.isHidden = true
                }
                if fieldsDictArray.count == 1 {
                    tagLbl[1].isHidden = false
                    tagLbl[1].text = fieldsDictArray.first?["fieldName"] as? String
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

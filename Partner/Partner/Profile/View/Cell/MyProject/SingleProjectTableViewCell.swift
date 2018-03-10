//
//  SingleProjectTableViewCell.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit

class SingleProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectImg: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet var tagLbl: [StrokeLabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectListModel? {
        didSet {
            if let logo = viewModel?.logoUrl {
                projectImg.sd_setImage(with: URL.init(string: logo), placeholderImage: #imageLiteral(resourceName: "project_logo_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.projName {
                nameLbl.text = name
            }
            if let status = viewModel?.status {
                // 项目状态，0未融资 1审核中 2通过 3审核不通过
                switch status {
                case 0: statusLbl.text = "未融资"; statusLbl.textColor = #colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1)
                case 1: statusLbl.text = "审核中"; statusLbl.textColor = #colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1)
                case 2: statusLbl.text = "已通过"; statusLbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                case 3: statusLbl.text = "未通过"; statusLbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                default: statusLbl.isHidden = true
                }
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
                        for i in 0..<count {
                            tagLbl[i].text = (fieldsDictArray[i] as! [String : AnyObject])["fieldName"] as? String
                        }
                        for j in count..<2 {
                            tagLbl[j].isHidden = true
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

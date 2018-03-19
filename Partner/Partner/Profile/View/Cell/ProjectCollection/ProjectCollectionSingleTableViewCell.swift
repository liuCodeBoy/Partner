//
//  ProjectCollectionSingleTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectCollectionSingleTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var roundLbl: UILabel!
    @IBOutlet var tagLbl: [StrokeLabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectListModel? {
        didSet {
            if let logo = viewModel?.logoUrl {
                logoImg.sd_setImage(with: URL.init(string: logo), placeholderImage: #imageLiteral(resourceName: "project_logo_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.projName {
                projNameLbl.text = name
            }
            if let round = viewModel?.cityName {
                roundLbl.text = round
            }
            if let fieldsDictArray = viewModel?.fields {
                // hide all
                for lbl in tagLbl {
                    lbl.isHidden = true
                }
                if fieldsDictArray.count == 1 {
                    tagLbl[0].isHidden = false
                    tagLbl[2].isHidden = false
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

//
//  ServiceFounderBriefTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceFounderBriefTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: RoundRectImage!
    @IBOutlet weak var companyLab: UILabel!
    @IBOutlet weak var licationString: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    
    
    var model : HotInvestorListModel?  {
        didSet {
            if let logourl = model?.userImgUrl{
                logoImage.setImageWith(URL.init(string: logourl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
            
            if let provComm = model?.userName{
                companyLab.text = provComm
            }
            
            if let locationStr = model?.roundName{
                licationString.text = locationStr
            }
            
            
            if let type = model?.industryList {
                for i in 0..<type.count {
                    if i == 0 {
                        let dict  = type[i]
                        tag1.text = dict["induName"] as? String
                        tag2.isHidden = true
                        tag3.isHidden = true
                    }else if i == 1 {
                        let dict  = type[i]
                        tag2.text = dict["induName"] as? String
                        tag2.isHidden = false
                        tag3.isHidden = true
                    }else if i == 2{
                        let dict  = type[i]
                        tag3.text = dict["induName"] as? String
                        tag3.isHidden = false
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

}

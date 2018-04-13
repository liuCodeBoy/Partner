//
//  ServiceProviderCompanyIntroductionTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceProviderCompanyIntroductionTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var logoImage: RoundRectImage!
    @IBOutlet weak var companyLab: UILabel!
    @IBOutlet weak var licationString: UILabel!
    @IBOutlet weak var tag1: StrokeLabel!
    @IBOutlet weak var tag2: StrokeLabel!
    @IBOutlet weak var viewNumBtn: UIButton!
    
    var model : SelectedProviderModel?  {
        didSet {
            if let url = model?.imgUrl {
              mainImageView.setImageWith(URL.init(string: url)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
            
            if let logourl = model?.logoUrl{
                logoImage.setImageWith(URL.init(string: logourl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
            
            if let provComm = model?.provName{
                companyLab.text = provComm
            }
            
            if let viewNum = model?.scanNum{
                viewNumBtn.setTitle("\(viewNum)", for: .normal)
            }
            
            if let locationStr = model?.provComm{
                licationString.text = locationStr
            }
            
            if let type = model?.provType {
                let typeArr = type.components(separatedBy: ",")
                for i in 0..<typeArr.count {
                    if i == 0 {
                        tag1.text = typeArr[i]
                        tag2.isHidden = true
                    }else if i == 1 {
                        tag2.text =  typeArr[i]
                        tag2.isHidden = false
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    

}

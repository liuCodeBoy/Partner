//
//  ServiceMainProviderListTableViewCell.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceMainProviderListTableViewCell: UITableViewCell {


    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var logoImage: RoundRectImage!
    @IBOutlet weak var companyLab: UILabel!
    @IBOutlet weak var tag1: StrokeLabel!
    @IBOutlet weak var tag2: StrokeLabel!
    @IBOutlet weak var tag3: StrokeLabel!
    
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
            
            if let type = model?.provType {
                let typeArr = type.components(separatedBy: ",")
                for i in 0..<typeArr.count {
                    if i == 0 {
                        tag1.text = typeArr[i]
                        tag2.isHidden = true
                        tag3.isHidden = true

                    }else if i == 1 {
                        tag2.text =  typeArr[i]
                        tag2.isHidden = false
                        tag3.isHidden = true
                    }else if i == 2{
                        tag3.text =  typeArr[i]
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



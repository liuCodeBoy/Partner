//
//  InfomationCell.swift
//  Partner
//
//  Created by Weslie on 06/03/2018.
//

import UIKit

class InfomationCell: UITableViewCell {

    @IBOutlet weak var infoImg: RoundRectImage!
    
    @IBOutlet weak var infoLab: UILabel!
    
    @IBOutlet weak var watchNum: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    
    var viewModel: infoModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let  watchNum =  viewModel.scanNum {
                self.watchNum.text = "\(watchNum)"
            }
            if let title =  viewModel.title {
                self.infoLab.text = title
            }
            if let time =  viewModel.pubDate {
                self.timeLab.text = time
            }
            if let img =  viewModel.imgUrl {
                self.infoImg.setImageWith(URL.init(string: img)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


}

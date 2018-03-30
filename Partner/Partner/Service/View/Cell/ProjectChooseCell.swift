//
//  ProjectChooseCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/29.
//

import UIKit

class ProjectChooseCell: UITableViewCell {
    
    ////profile_my_project_radio_non_selected
    var userId : Int?
    var projectId : Int?
    var isSelectStatus = false
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var headImageView: UIImageView!
    var viewModel : ProjectListModel?{
        didSet{
            if let logo = viewModel?.logoUrl {
                headImageView.sd_setImage(with: URL.init(string: logo), placeholderImage: #imageLiteral(resourceName: "project_logo_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.projName {
                projectName.text = name
            }
            if viewModel?.isSelected == true {
                statusImg.image = #imageLiteral(resourceName: "profile_my_project_radio_selected")
            }else{
                statusImg.image = #imageLiteral(resourceName: "profile_my_project_radio_non_selected")
            }
            statusBtn.isSelected  = (viewModel?.isSelected)!
           
            if let field =  viewModel?.fields?[0] {
                self.type1.text = field["fieldName"] as? String
                self.type2.isHidden = true
            }
            if  viewModel!.fields!.count >= 2 {
                if let field2 = viewModel?.fields?[1]{
                    self.type2.text = field2["fieldName"]  as? String
                }
                self.type2.isHidden = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    

    
}

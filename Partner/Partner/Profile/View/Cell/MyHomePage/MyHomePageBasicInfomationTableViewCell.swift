//
//  MyHomePageBasicInfomationTableViewCell.swift
//  Partner
//
//  Created by Weslie on 06/02/2018.
//

import UIKit

class MyHomePageBasicInfomationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var socialOrgLbl: UILabel!
    @IBOutlet weak var skillsLbl: UILabel!
    @IBOutlet weak var fundingTurnLbl: UILabel!
    @IBOutlet weak var hobbiesLbl: UILabel!
    @IBOutlet weak var coopRequsetLbl: UILabel!
    @IBOutlet weak var selfIntroLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProfileInfoModel? {
        didSet {
            if let company = viewModel?.compName {
                companyNameLbl.text = company
            }
            if let social = viewModel?.commName {
                socialOrgLbl.text = social
            }
            if let skill = viewModel?.skill {
                skillsLbl.text = skill
            }
            
        }
    }

}

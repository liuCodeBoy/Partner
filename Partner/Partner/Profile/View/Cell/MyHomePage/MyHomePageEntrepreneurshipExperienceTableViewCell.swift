//
//  MyHomePageEntrepreneurshipExperienceTableViewCell.swift
//  Partner
//
//  Created by Weslie on 09/02/2018.
//

import UIKit

class MyHomePageEntrepreneurshipExperienceTableViewCell: UITableViewCell {
    
    var pushControllerClosure: NonParamClosure?

    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var jobNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var industryLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var peopleCountLbl: UILabel!
    @IBOutlet weak var fundingScaleLbl: UILabel!
    @IBOutlet weak var teamMemberCountLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        if pushControllerClosure != nil {
            pushControllerClosure!()
        }
    }
    
    var viewModel: EntrepreneurshipModel? {
        didSet {
            if let projName = viewModel?.entrProjName {
                projNameLbl.text = projName
            }
            if let job = viewModel?.entrRole {
                jobNameLbl.text = job
            }
            if let time = viewModel?.entrDate {
                timeLbl.text = time
            }
            if let industry = viewModel?.entrIndustry {
                industryLbl.text = industry
            }
            if let location = viewModel?.entrArea {
                locationLbl.text = location
            }
            if let count = viewModel?.entrPartnership {
                peopleCountLbl.text = count
            }
            if let scale = viewModel?.entrFinancingScale {
                fundingScaleLbl.text = scale
            }
            if let count = viewModel?.entrTeamNum {
                teamMemberCountLbl.text = count
            }
            if let desc = viewModel?.entrDesc {
                descLbl.text = desc
            }
        }
    }

}

//
//  MyHomePageEducationExperienceTableViewCell.swift
//  Partner
//
//  Created by Weslie on 09/02/2018.
//

import UIKit

class MyHomePageEducationExperienceTableViewCell: UITableViewCell {

    var pushControllerClosure: NonParamClosure?
    
    @IBOutlet weak var schoolNameLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        if pushControllerClosure != nil {
            pushControllerClosure!()
        }
    }

    var viewModel: EducationExperienceModel? {
        didSet {
            if let school = viewModel?.eduSchool {
                schoolNameLbl.text = school
            }
            if let degree = viewModel?.eduDegree {
                degreeLbl.text = degree
            }
            if let time = viewModel?.eduDate {
                timeLbl.text = time
            }
            if let desc = viewModel?.eduDesc {
                descLbl.text = desc
            } else {
                descLbl.isHidden = true
            }
        }
    }
    
}

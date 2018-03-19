//
//  MyHomePageWorkExperienceTableViewCell.swift
//  Partner
//
//  Created by Weslie on 09/02/2018.
//

import UIKit

class MyHomePageWorkExperienceTableViewCell: UITableViewCell {
    
    var pushControllerClosure: NonParamClosure?

    @IBOutlet weak var compNameLbl: UILabel!
    @IBOutlet weak var jobNameLbl: UILabel!
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
    
    var viewModel: WorkExperienceModel? {
        didSet {
            if let name = viewModel?.jobCompName {
                compNameLbl.text = name
            }
            if let job = viewModel?.jobName {
                jobNameLbl.text = job
            }
            if let time = viewModel?.jobOnTime {
                timeLbl.text = time
            }
            if let desc = viewModel?.jobDesc {
                descLbl.text = desc
            } else {
                descLbl.isHidden = true
            }
        }
    }
    

}

//
//  ProjectEditRunStatusTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class ProjectEditRunStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addCoverView: UIView!
    @IBOutlet weak var editBtn: UIButton!

    @IBOutlet weak var monthSalaryLbl: UILabel!
    @IBOutlet weak var monthActivePeopleLbl: UILabel!
    @IBOutlet weak var totalUserLbl: UILabel!
    @IBOutlet weak var runDataLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCoverView.isHidden = false
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let status = viewModel?.status {
                if status == 0 {
                    editBtn.isHidden = false
                } else {
                    editBtn.isHidden = true
                }
            }
            if let income = viewModel?.projMonthIncome {
                monthSalaryLbl.text = "\(income)"
                addCoverView.isHidden = true
            }
            if let active = viewModel?.projMonthUser {
                monthActivePeopleLbl.text = "\(active)"
            }
            if let total = viewModel?.projTotalUser {
                totalUserLbl.text = "\(total)"
            }
            if let desc = viewModel?.projDataRemark {
                runDataLbl.text = desc
            }
            
        }
    }

}

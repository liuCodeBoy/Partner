//
//  ProjectReviewRunStatusTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectReviewRunStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var monthSalaryLbl: UILabel!
    @IBOutlet weak var monthActivePeopleLbl: UILabel!
    @IBOutlet weak var totalUserLbl: UILabel!
    @IBOutlet weak var runDataLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let income = viewModel?.projMonthIncome {
                monthSalaryLbl.text = "\(income)"
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

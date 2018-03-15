//
//  ProjectReviewFundingNeedTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectReviewFundingNeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fundingMomeyLbl: UILabel!
    @IBOutlet weak var transferSharesLbl: UILabel!
    @IBOutlet weak var fundingExpectationLbl: UILabel!
    @IBOutlet weak var moneyUsingPlanLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let expect = viewModel?.projFinancing {
                fundingMomeyLbl.text = "\(expect)万元"
            }
            if let stock = viewModel?.projShare {
                transferSharesLbl.text = "\(stock)%"
            }
            if let estimate = viewModel?.projValue {
                fundingExpectationLbl.text = "\(estimate)万"
            }
            if let plan = viewModel?.projFundPlan {
                moneyUsingPlanLbl.text = plan
            }
            
        }
    }

}

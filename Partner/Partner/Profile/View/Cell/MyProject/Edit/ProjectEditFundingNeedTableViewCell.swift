//
//  ProjectEditFundingNeedTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class ProjectEditFundingNeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addCoverView: UIView!
    @IBOutlet weak var editBtn: UIButton!

    @IBOutlet weak var fundingMomeyLbl: UILabel!
    @IBOutlet weak var transferSharesLbl: UILabel!
    @IBOutlet weak var fundingExpectationLbl: UILabel!
    @IBOutlet weak var moneyUsingPlanLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCoverView.isHidden = false
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
            addCoverView.isHidden = true
        }
    }

}

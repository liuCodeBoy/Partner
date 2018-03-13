//
//  ProjectEditMarketAnalysisTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class ProjectEditMarketAnalysisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addCoverView: UIView!
    @IBOutlet weak var editBtn: UIButton!

    @IBOutlet weak var aimUserGroupLbl: UILabel!
    @IBOutlet weak var profitModLbl: UILabel!
    @IBOutlet weak var competitionRivalLbl: UILabel!
    @IBOutlet weak var ownSourceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCoverView.isHidden = false
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let projUserGroup = viewModel?.projUserGroup {
                aimUserGroupLbl.text = projUserGroup
            }
            if let projProfitModel = viewModel?.projProfitModel {
                profitModLbl.text = projProfitModel
            }
            if let projCompetitor = viewModel?.projCompetitor {
                competitionRivalLbl.text = projCompetitor
            }
            if let projResources = viewModel?.projResources {
                ownSourceLbl.text = projResources
            }
            addCoverView.isHidden = true
        }
    }

}

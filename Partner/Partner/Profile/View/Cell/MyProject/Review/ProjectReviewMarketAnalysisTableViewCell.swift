//
//  ProjectReviewMarketAnalysisTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectReviewMarketAnalysisTableViewCell: UITableViewCell {

    @IBOutlet weak var aimUserGroupLbl: UILabel!
    @IBOutlet weak var profitModLbl: UILabel!
    @IBOutlet weak var competitionRivalLbl: UILabel!
    @IBOutlet weak var ownSourceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
            
        }
    }

}

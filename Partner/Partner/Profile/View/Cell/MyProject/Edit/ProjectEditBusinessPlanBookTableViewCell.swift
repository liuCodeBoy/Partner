//
//  ProjectEditBusinessPlanBookTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class ProjectEditBusinessPlanBookTableViewCell: UITableViewCell {

    @IBOutlet weak var planBookLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let plan = viewModel?.planName {
                planBookLbl.text = plan
            }
        }
    }

}

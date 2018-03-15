//
//  ProjectReviewIntroductionTableViewCell.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectReviewIntroductionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projIntroLbl: UILabel!
    @IBOutlet weak var projHighlightsLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            
            if let desc = viewModel?.projDesc {
                projIntroLbl.text = desc
            }
            if let highlight = viewModel?.projHighlights {
                projHighlightsLbl.text = highlight
            }
            
        }
    }

}

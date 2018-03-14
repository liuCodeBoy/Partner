//
//  ProjectEditIntroductionTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class ProjectEditIntroductionTableViewCell: UITableViewCell {

    @IBOutlet weak var addCoverView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var projIntroLbl: UILabel!
    @IBOutlet weak var projHighlightsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCoverView.isHidden = false
    }
    
    var viewModel: ProjectDetialModel? {
        didSet {
            if let desc = viewModel?.projDesc, let highlight = viewModel?.projHighlights {
                projIntroLbl.text = desc
                projHighlightsLbl.text = highlight
                // MARK:- desc is nil, show the cover view
                addCoverView.isHidden = true
            }
            addCoverView.isHidden = true
        }
    }

}

//
//  ProjectEditHeaderTableViewCell.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class ProjectEditHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var projLogoImg: UIImageView!
    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var projStatusLbl: UILabel!
    @IBOutlet weak var favLbl: UILabel!
    @IBOutlet weak var viewLbl: UILabel!
    @IBOutlet weak var tag1Lbl: StrokeLabel!
    @IBOutlet weak var tag2Lbl: StrokeLabel!
    @IBOutlet weak var tag3Lbl: StrokeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

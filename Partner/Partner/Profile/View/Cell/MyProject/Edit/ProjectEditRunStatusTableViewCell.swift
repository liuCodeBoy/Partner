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
    }

}

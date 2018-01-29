//
//  SingleProjectTableViewCell.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit

class SingleProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectImg: UIImageView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tag1Lbl: StrokeLabel!
    @IBOutlet weak var tag2Lbl: StrokeLabel!
    @IBOutlet weak var tag3Lbl: StrokeLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

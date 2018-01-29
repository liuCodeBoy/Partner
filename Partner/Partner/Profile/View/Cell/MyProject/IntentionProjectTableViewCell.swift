//
//  IntentionProjectTableViewCell.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit

class IntentionProjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projLogoImg: UIImageView!
    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var type1Lbl: StrokeLabel!
    @IBOutlet weak var type2Lbl: StrokeLabel!
    @IBOutlet weak var type3Lbl: StrokeLabel!
    
    @IBOutlet weak var refuseBtn: UIButton!
    @IBAction func refuseBtnClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var investBtn: UIButton!
    @IBAction func investBtnClicked(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

//
//  ServiceMainProviderHeaderTableViewCell.swift
//  Partner
//
//  Created by Weslie on 16/03/2018.
//

import UIKit


class ServiceMainProviderHeaderTableViewCell: UITableViewCell {
    var showVC : showVCType?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var showProvideVC: UIButton!
    
    @IBAction func showProvideVCAction(_ sender: Any) {
        if showVC != nil {
            showVC!(0)
        }
    }
}

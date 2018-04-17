//
//  ProfileTagSelectorTableViewBodyCell.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class ProfileHobbiesSelectorTableViewBodyCell: UITableViewCell {
    
    var hobbyString = ""
    
    var hobbyArray = [String]() {
        didSet {
            var str = ""
            for skill in hobbyArray {
                str += "\(skill),"
            }
            if !str.isEmptyString {
                str.removeLast(1)
            }
            hobbyString = str
        }
    }
    
    @IBAction func staticBtnClicked(_ sender: ShadowButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = #colorLiteral(red: 0.5529412031, green: 0.6274510026, blue: 0.6941176653, alpha: 1)
            sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            hobbyArray.append((sender.titleLabel?.text)!)

        } else {
            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sender.setTitleColor(#colorLiteral(red: 0.5529412031, green: 0.6274510026, blue: 0.6941176653, alpha: 1), for: .normal)
            hobbyArray.remove(at: hobbyArray.index(of: (sender.titleLabel?.text)!)!)

        }
    }
    
    @IBOutlet weak var customBtn1: ShadowButton!
    @IBOutlet weak var customBtn2: ShadowButton!
    @IBOutlet weak var customBtn3: ShadowButton!
    @IBOutlet weak var customBtn4: ShadowButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

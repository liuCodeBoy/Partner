//
//  ProfileSkillsSelectorTableViewBodyCell.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class ProfileSkillsSelectorTableViewBodyCell: UITableViewCell {
    
    var skillString = ""
    
    var skillArray = [String]() {
        didSet {
            for skill in skillArray {
                skillString += "\(skill),"
            }
            skillString.removeLast(1)
        }
    }
    
    @IBAction func staticBtnClicked(_ sender: ShadowButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = #colorLiteral(red: 0.5529412031, green: 0.6274510026, blue: 0.6941176653, alpha: 1)
            sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
            skillArray.append((sender.titleLabel?.text)!)
            
        } else {
            sender.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            sender.setTitleColor(#colorLiteral(red: 0.5529412031, green: 0.6274510026, blue: 0.6941176653, alpha: 1), for: .normal)
            skillArray.remove(at: skillArray.index(of: (sender.titleLabel?.text)!)!)
        }
    }
    
    @IBOutlet weak var customBtn5: ShadowButton!
    @IBOutlet weak var customBtn6: ShadowButton!
    @IBOutlet weak var customBtn7: ShadowButton!
    @IBOutlet weak var customBtn8: ShadowButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

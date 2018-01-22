//
//  CustomTimePickerView.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class CustomTimePickerView: UIView {

    @IBOutlet weak var pickerTitle: UILabel!

    @IBOutlet var partnerPicker: UIDatePicker!
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}

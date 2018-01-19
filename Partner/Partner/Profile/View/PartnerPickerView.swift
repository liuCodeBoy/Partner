//
//  PartnerPickerView.swift
//  Partner
//
//  Created by Weslie on 18/01/2018.
//

import UIKit
let leftRow = ["南京市", "南京市", "南京市", "南京市", "南京市", "南京市", "南京市", "南京市"]
let rightRoe = ["合伙人孵化某某某社区", "合伙人孵化某某某社区", "合伙人孵化某某某社区", "合伙人孵化某某某社区", "合伙人孵化某某某社区", "合伙人孵化某某某社区", "合伙人孵化某某某社区", "合伙人孵化某某某社区"]

class PartnerPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var partnerPicker: UIPickerView!
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        partnerPicker.delegate = self
        partnerPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 8
        case 1:
            return 8
        default:
            return 8
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch component {
        case 0:
            return leftRow[row]
        case 1:
            return rightRoe[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        // set seperate line's color
        for singleLine in pickerView.subviews {
            if singleLine.frame.size.height < 2 {
                singleLine.backgroundColor = #colorLiteral(red: 0.8432456255, green: 0.8734833598, blue: 0.8959761262, alpha: 1)
            }
        }
        
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.2313725501, green: 0.2941176593, blue: 0.3411764801, alpha: 1)
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        
        switch component {
        case 0:
            label.text = leftRow[row]
        case 1:
            label.text = rightRoe[row]
        default:
            break
        }
        
        return label
    }
    

}

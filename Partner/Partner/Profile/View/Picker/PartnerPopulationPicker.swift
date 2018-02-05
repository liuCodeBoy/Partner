//
//  PartnerPopulationPicker.swift
//  Partner
//
//  Created by Weslie on 05/02/2018.
//

import UIKit

class PartnerPopulationPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var backView: UIView!
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
    }
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0.3
            self.containerView.transform = CGAffineTransform(scaleX: 0, y: -276)
        }, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "没有合伙人"
        case 1: return "1人"
        case 2: return "2人"
        case 3: return "3人"
        case 4: return "4人"
        case 5: return "5人及5人以上"
        default: return nil
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
        
        switch row {
        case 0: label.text = "没有合伙人"
        case 1: label.text = "1人"
        case 2: label.text = "2人"
        case 3: label.text = "3人"
        case 4: label.text = "4人"
        case 5: label.text = "5人及5人以上"
        default:
            break
        }
        
        return label
    }

}

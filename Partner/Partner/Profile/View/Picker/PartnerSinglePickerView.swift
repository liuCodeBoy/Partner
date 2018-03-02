//
//  PartnerSinglePickerView.swift
//  Partner
//
//  Created by Weslie on 02/03/2018.
//

import UIKit

class PartnerSinglePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var componentArray = [String]()
    
    var inputLbl: UILabel?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var partnerPicker: UIPickerView!
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: 266)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        partnerPicker.delegate = self
        partnerPicker.dataSource = self
        
        // appear animation
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.3
            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: -266)
            
        }, completion: nil)
        
        // tap back view to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnClicked(_:)))
        backgroundView.addGestureRecognizer(tap)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return componentArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
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
        
        label.text = componentArray[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        inputLbl?.text = componentArray[row]
    }
    
    
}


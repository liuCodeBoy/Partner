//
//  DegreePicker.swift
//  Partner
//
//  Created by Weslie on 06/02/2018.
//

import UIKit

class DegreePicker:  UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var saveDataClosure: ((_ degree: String) -> Void)?
    
    var degree: String?
    
    @IBOutlet weak var backView: UIView!
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0.3
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 276)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        if saveDataClosure != nil, degree != nil {
            saveDataClosure!(degree!)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.backView.alpha = 0
                self.containerView.transform = CGAffineTransform(translationX: 0, y: 276)
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0.3
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -276)
        }, completion: nil)
        
        // tap back view to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelBtnClicked(_:)))
        backView.addGestureRecognizer(tap)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0: return "学士"
        case 1: return "硕士"
        case 2: return "博士"
        case 3: return "本科"
        case 4: return "其他"
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
        case 0: label.text = "学士"
        case 1: label.text = "硕士"
        case 2: label.text = "博士"
        case 3: label.text = "本科"
        case 4: label.text = "其他"
        default: break
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let lbl = pickerView.view(forRow: row, forComponent: component) as? UILabel
        degree = lbl?.text
    }
    
}


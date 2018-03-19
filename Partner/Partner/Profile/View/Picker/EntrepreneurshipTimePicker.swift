//
//  EntrepreneurshipTimePicker.swift
//  Partner
//
//  Created by Weslie on 05/02/2018.
//

import UIKit

class EntrepreneurshipTimePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var years: [Int] = [Int]()
    var months: [String] = [String]()
    
    var beginDate: String?
    var endDate: String?
    var time: String?
    var saveDataClosure: ((_ from: String, _ to: String, _ time: String) -> Void)?
    
    let currentDate = Date()
    var current = ""
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0
            self.picContainerView.transform = CGAffineTransform(translationX: 0, y: 276)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        if saveDataClosure != nil {
            saveDataClosure!(beginDate!, endDate!, time!)
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0
            self.picContainerView.transform = CGAffineTransform(translationX: 0, y: 276)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var picContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // get the curret year an create an array
        let yaer = currentDate.year()
        current = "\(yaer)/\(currentDate.month())月"
        // set the placeholder picker title
        timeLbl.text = "\(current) - \(current)"
        for i in 1968...yaer {
            years.append(i)
        }
        // reverse the element in the array
        years.reverse()
        for j in 1...12 {
            months.append("\(j)月")
        }
        
        // set the deafult value
        beginDate = "\(currentDate.year())/\(currentDate.month())"
        endDate = "\(currentDate.year())/\(currentDate.month())"
        time = "\(beginDate!) - \(endDate!)"

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0.3
            self.picContainerView.transform = CGAffineTransform(translationX: 0, y: -276)
        }, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0, 3: return years.count         //year
        case 1, 4: return 12                  //momth
        case 2   : return 1                   //
        default  : return 0
        }
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
        
        switch component {
        case 0: label.text = "\(years[row])"
        case 1: label.text = months[row]
        case 2: label.text = "至"
        case 3: label.text = "\(years[row])"
        case 4: label.text = months[row]
        default :break
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fromYear    = pickerView.view(forRow: row, forComponent: 0) as? UILabel
        let fromMonth   = pickerView.view(forRow: row, forComponent: 1) as? UILabel
        let toYear      = pickerView.view(forRow: row, forComponent: 3) as? UILabel
        let toMonth     = pickerView.view(forRow: row, forComponent: 4) as? UILabel

        let beginTime = "\(fromYear?.text ?? "\(currentDate.year())")/\(fromMonth?.text ?? "\(currentDate.month())")"
        let endTime = "\(toYear?.text ?? "\(currentDate.year())")/\(toMonth?.text ?? "\(currentDate.month())")"
        let entDate = "\(beginTime) - \(endTime)"
        
        self.beginDate = beginTime
        self.endDate = endTime
        self.time = entDate
        
        timeLbl.text = entDate
        
    }
    
}


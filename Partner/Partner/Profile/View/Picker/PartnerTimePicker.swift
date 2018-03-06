//
//  PartnerTimePicker.swift
//  Partner
//
//  Created by YJ on 2018/3/6.
//

import UIKit

class PartnerTimePicker: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickerTitle: UILabel!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    

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
        
        // appear animation
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.3
            self.pickerContainerView.transform = CGAffineTransform(translationX: 0, y: -266)
            
        }, completion: nil)
        
        // tap back view to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeBtnClicked(_:)))
        backgroundView.addGestureRecognizer(tap)
        
    }
    
}

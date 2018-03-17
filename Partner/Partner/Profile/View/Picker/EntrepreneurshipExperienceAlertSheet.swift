//
//  EntrepreneurshipExperienceAlertSheet.swift
//  Partner
//
//  Created by Weslie on 05/02/2018.
//

import UIKit

class EntrepreneurshipExperienceAlertSheet: UIView {
    
    var saveDataClosure: ((_ role: String) -> Void)?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func founder(_ sender: UIButton) {
        if saveDataClosure != nil {
            saveDataClosure!("创始人")
            
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 232)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    @IBAction func investor(_ sender: UIButton) {
        if saveDataClosure != nil {
            saveDataClosure!("投资人")
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 232)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    @IBAction func partner(_ sender: UIButton) {
        if saveDataClosure != nil {
            saveDataClosure!("合伙人")
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 232)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func dismissBtnClicked(_ sender: ShadowButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 232)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0.3
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -232)
        }, completion: nil)

        // tap back view to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBtnClicked(_:)))
        backView.addGestureRecognizer(tap)
        
    }

}

//
//  EntrepreneurshipExperienceAlertSheet.swift
//  Partner
//
//  Created by Weslie on 05/02/2018.
//

import UIKit

class EntrepreneurshipExperienceAlertSheet: UIView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func founder(_ sender: UIButton) {
    }
    @IBAction func investor(_ sender: UIButton) {
    }
    @IBAction func partner(_ sender: UIButton) {
    }
    
    @IBAction func dismissBtnClicked(_ sender: ShadowButton) {
        self.removeFromSuperview()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.backView.alpha = 0.3
            self.containerView.transform = CGAffineTransform(scaleX: 0, y: -232)
        }, completion: nil)
    }

}

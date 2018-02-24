//
//  ServiceInvestorProfileViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceInvestorProfileViewController: UIViewController {

    @IBOutlet weak var navViewHCons: NSLayoutConstraint!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerImgHCons: NSLayoutConstraint!
    @IBOutlet weak var headerInfoTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var basicInfoContainerView: UIView!
    @IBOutlet weak var experienceContainerView: UIView!
    
    @IBOutlet weak var basicInfoBtn: ShadowButton!
    @IBOutlet weak var experienceBtn: ShadowButton!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func basicInfoBtnClicked(_ sender: ShadowButton) {
        basicInfoBtn.setSelected()
        experienceBtn.reverseSelected()
        basicInfoContainerView.isHidden = false
        experienceContainerView.isHidden = true
    }
    @IBAction func experienceBtnClicked(_ sender: ShadowButton) {
        basicInfoBtn.reverseSelected()
        experienceBtn.setSelected()
        basicInfoContainerView.isHidden = true
        experienceContainerView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isIPHONEX {
            headerImgHCons.constant += 24
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SIBasicInfoSegue" {
            let dest = segue.destination as! ServiceInvestorBasicInfomationContainerViewController
            dest.segue = segue
        } else if segue.identifier == "SIExperienceSegue" {
            let dest = segue.destination as! ServiceInvestorExperienceContainerViewController
            dest.segue = segue
        }
    }

}

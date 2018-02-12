//
//  MyHomePageViewController.swift
//  Partner
//
//  Created by Weslie on 06/02/2018.
//

import UIKit

class MyHomePageViewController: UIViewController {

    @IBOutlet weak var navViewHCons: NSLayoutConstraint!
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerImgHCons: NSLayoutConstraint!
    @IBOutlet weak var headerInfoTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var basicInfoContainerView: UIView!
    @IBOutlet weak var experienceContainerView: UIView!
    
    @IBOutlet weak var basicInfoBtn: ShadowButton!
    @IBOutlet weak var experienceBtn: ShadowButton!
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
    
    @IBAction func uploadHeaderBackImgClicked(_ sender: ShadowButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if isIPHONEX {
            headerImgHCons.constant += 24
            navViewHCons.constant += 24
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MHPBasicInfoSegue" {
            let dest = segue.destination as! MyHomePageBasicInfomationContainerViewController
            dest.segue = segue
        } else if segue.identifier == "MHPSelfExperienceSegue" {
            let dest = segue.destination as! MyHomePageSelfExperienceContainerViewController
            dest.segue = segue
        }
    }

}



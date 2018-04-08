//
//  AuthApplyUploadViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit

class AuthApplyUploadViewController: UIViewController {
    
    var isInvestor = true

    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var applyEnterpriseView: UIView!
    @IBOutlet weak var applyInvestView: UIView!
    
    @IBOutlet weak var authSelectViewHCons: NSLayoutConstraint!
    
    @IBOutlet weak var investAuth: ShadowButton!
    @IBOutlet weak var enterpriseAuth: ShadowButton!

    @IBAction func investAuthClicked(_ sender: ShadowButton) {
        investAuth.setSelected()
        enterpriseAuth.reverseSelected()
        applyInvestView.isHidden = false
        applyEnterpriseView.isHidden = true
    }
    
    @IBAction func enterpriseAuthClicked(_ sender: ShadowButton) {
        investAuth.reverseSelected()
        enterpriseAuth.setSelected()
        applyInvestView.isHidden = true
        applyEnterpriseView.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if isInvestor {
            authSelectViewHCons.constant = 70
            applyInvestView.isHidden = false
            applyEnterpriseView.isHidden = true
        } else {
            authSelectViewHCons.constant = 0
            applyInvestView.isHidden = true
            applyEnterpriseView.isHidden = false
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !isInvestor && identifier == "investAuthContainerSegue" {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination
        if segue.identifier == "investAuthContainerSegue" {
            let dest = destnation as! AuthApplyInvestViewController
            dest.containerSegue = segue
        } else if segue.identifier == "enterpriseAuthContainerSegue" {
            let dest = destnation as! AuthApplyEnterpriseViewController
            dest.containerSegue = segue
        }
    }

}

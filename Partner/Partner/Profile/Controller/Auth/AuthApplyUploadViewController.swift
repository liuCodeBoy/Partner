//
//  AuthApplyUploadViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit

class AuthApplyUploadViewController: UIViewController {
    
    var isInvestor = true
    
    var auth = 0

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
        
        if auth == 2 {
            investAuth.reverseSelected()
            enterpriseAuth.setSelected()
            applyInvestView.isHidden = true
            applyEnterpriseView.isHidden = false
        } else {
            presentHintMessage(hintMessgae: "请先完成投资认证", completion: nil)
        }
        
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
        
        judgeAuthStatus()
        
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

extension AuthApplyUploadViewController {
    
    func judgeAuthStatus() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        NetWorkTool.shareInstance.getAuthInfo(token: access_token!, type: 1) { (result, error) in
            if result != nil, let resultDict = result!["result"] as? [String : AnyObject] {
                self.auth = resultDict["auth"] as! Int //认证状态 0未认证 1认证中 2通过 3不通过
            }
        }
    }
}

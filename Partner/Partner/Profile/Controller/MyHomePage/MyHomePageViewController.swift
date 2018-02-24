//
//  MyHomePageViewController.swift
//  Partner
//
//  Created by Weslie on 06/02/2018.
//

import UIKit

class MyHomePageViewController: UIViewController {
    
    @IBOutlet weak var avatar: RoundRectImage!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    
    var viewModel: ProfileInfoModel? {
        didSet {
            if let url = viewModel?.userImgUrl {
                avatar.sd_setImage(with: URL.init(string: url), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.userName {
                nickNameLbl.text = name
            }
            if let job = viewModel?.jobName {
                jobLbl.text = job
            }
        }
    }

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
    
    @IBAction func backToHomePage(_ sender: UIStoryboardSegue) { }
    
    @IBAction func uploadHeaderBackImgClicked(_ sender: ShadowButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLoginStatus()
        NetWorkTool.shareInstance.getMyInfo(token: access_token!) { [weak self](result, error) in
            if error != nil {
                self?.presentConfirmationAlert(hint: "\(String(describing: error))", completion: nil)
            }
            if result!["code"] as! Int == 200 {
                self?.viewModel = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
            } else {
                self?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"])), reason: \(String(describing: result!["msg"])))", completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if isIPHONEX {
            headerImgHCons.constant += 24
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



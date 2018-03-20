//
//  MyProjectReviewViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/15.
//

import UIKit
import SCLAlertView

class MyProjectReviewViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var projID: Int? {
        didSet {
            loadProjBasicInfo()
        }
    }
    
    var modelView: ProjectDetialModel? {
        didSet {
            // MARK:- reload model
            tableView.modelView = modelView
        }
    }
    
    @IBOutlet weak var tableView: ProjectReviewTableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadProjBasicInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushInvestorVC), name: NSNotification.Name.init(pushInvestorNotification), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    

}

extension MyProjectReviewViewController {
    
    @objc func pushInvestorVC() {
        
        // FIXME:- to push investor vc and pass proj id
        /// call judgeDeliverValid first and then deliver project
        
        
    }
    
    func loadProjBasicInfo() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        guard let id = projID else { return }
        // MARK:- whole info
        
        NetWorkTool.shareInstance.previewProject(token: access_token!, id: id) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                
                weakSelf?.modelView = ProjectDetialModel.mj_object(withKeyValues: result!["result"])
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }

}


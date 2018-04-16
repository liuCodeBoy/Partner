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
    
    var isPushedFromHome = false
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}

extension MyProjectReviewViewController {
    
    @objc func pushInvestorVC(_ notification: Notification) {
        
        guard let operation = notification.object as? Int else { return }
        
        // FIXME:- to push investor vc and pass proj id
        /// call judgeDeliverValid first and then deliver project
        
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            presentLoginController()
            return
        }
        NetWorkTool.shareInstance.getMyPageInfo(token: access_token!, finished: { [weak self] (result, error) in
            if result!["code"] as! Int == 200 {
                let model = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
                if model?.auth != 2 {
                    SCLAlertView().showNotice("请完成投资商认证", subTitle: "")
                    return
                } else {
                    // auth success
                    self?.operateProject(id: operation)
                }
            }
            
        })
        
    }
    
    func operateProject(id: Int) {
        guard let projId = self.projID else { return }
        let userId = UserDefaults.standard.integer(forKey: "uid")
        
        // 操作类型，1投递项目 2融资提交 3融资审核中 4已融资 5认证投资人
        switch id {
        case 1:
            NetWorkTool.shareInstance.deliverProject(token: access_token!, userId: userId, projectIds: "\(projId)", finished: { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    SCLAlertView().showSuccess("投递成功", subTitle: "")
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            })
        case 2:
            NetWorkTool.shareInstance.applyFinancing(token: access_token!, id: projId) { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    SCLAlertView().showSuccess("提交成功", subTitle: "")
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        default: break
        }
        
        
    }
    
    func loadProjBasicInfo() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        guard let id = projID else { return }
        // MARK:- whole info
        
        if isPushedFromHome {
            NetWorkTool.shareInstance.getProjectDetailInfo(token: access_token!, id: id) { (result, error) in
                weak var weakSelf = self
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data into model
                    
                    let tempModelView = ProjectDetialModel.mj_object(withKeyValues: result!["result"])
                    
                    // fix api bug -> member info
                    NetWorkTool.shareInstance.getMemberList(token: access_token!, projectId: id) { (result, error) in
                        if error != nil {
                            SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                            return
                        }
                        if result!["code"] as! Int == 200 {
                            // TODO:- save data into model
                            
                            tempModelView?.membInfos = result!["result"] as? [NSDictionary]
                            
                            weakSelf?.modelView = tempModelView
                            
                        } else {
                            SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                        }
                    }
                    
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
            
        } else {
            NetWorkTool.shareInstance.previewProject(token: access_token!, id: id) { (result, error) in
                weak var weakSelf = self
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data into model
                    
                    let tempModelView = ProjectDetialModel.mj_object(withKeyValues: result!["result"])
                    
                    // fix api bug -> member info
                    NetWorkTool.shareInstance.getMemberList(token: access_token!, projectId: id) { (result, error) in
                        if error != nil {
                            SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                            return
                        }
                        if result!["code"] as! Int == 200 {
                            // TODO:- save data into model
                            
                            tempModelView?.membInfos = result!["result"] as? [NSDictionary]
                            
                            weakSelf?.modelView = tempModelView
                            
                        } else {
                            SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                        }
                    }
                    
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        }
        
    }

}


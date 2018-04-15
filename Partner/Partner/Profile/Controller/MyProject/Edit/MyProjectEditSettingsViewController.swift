//
//  MyProjectEditSettingsViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class MyProjectEditSettingsViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var projID: Int? {
        didSet {
            loadProjSettingStatus()
        }
    }
    
    var projStatus: Int = 1 {
        didSet {
            if projStatus == 1 {
                offlineBtn.isSelected = true
                openBtn.isSelected = false
            } else if projStatus == 2 {
                offlineBtn.isSelected = false
                openBtn.isSelected = true
            }
        }
    }

    @IBOutlet weak var offlineBtn: UIButton!
    @IBAction func offlineClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            projStatus = 1
        } else {
            projStatus = 0
        }
    }
    @IBOutlet weak var openBtn: UIButton!
    @IBAction func openClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            projStatus = 2
        } else {
            projStatus = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        saveProjSettings()
    }
    @IBAction func deleteProjClicked(_ sender: ShadowButton) {
        deleteProj()
    }
    
    func loadProjSettingStatus() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        NetWorkTool.shareInstance.getProjectPublic(token: access_token!, id: id) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save status
                weakSelf?.projStatus = result!["result"] as! Int
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
    func saveProjSettings() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        
        presentConfirmationAlert(hint: "确定保存吗？") { (_) in
            weak var weakSelf = self
            NetWorkTool.shareInstance.setProject(token: access_token!, id: id, projPublic: (weakSelf?.projStatus)!) { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save status
                    weakSelf?.projStatus = result!["result"] as! Int
                    weakSelf?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        }
    }
    
    func deleteProj() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        
        presentConfirmationAlert(hint: "确定保存吗？") { (_) in
            weak var weakSelf = self
            NetWorkTool.shareInstance.deleteProject(token: access_token!, id: id, finished: { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save status
                    weakSelf?.presentHintMessage(hintMessgae: "删除成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            })
        }
    }
    
}

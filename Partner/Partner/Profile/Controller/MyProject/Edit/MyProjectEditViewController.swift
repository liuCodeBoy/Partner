//
//  MyProjectEditViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView
import ImagePicker
import Lightbox

class MyProjectEditViewController: UIViewController {
    
    var isEdited = false
    
    var projID: Int? {
        didSet {
            loadProjBasicInfo()
        }
    }
    
    var businessPlan: UIImage?
    
    var headerModelView: ProjectBasicInfoModel? {
        didSet {
            // MARK:- reload model
            tableView.headerModelView = headerModelView
        }
    }
    var modelView: ProjectDetialModel? {
        didSet {
            // MARK:- reload model
            // MARK:- reEdit
            if isEdited {
                modelView?.status = 0
                modelView?.isEdit = 1
            }
            tableView.modelView = modelView
            
            // 项目状态 0未提交 1审核中 2审核通过 3审核不通过
            if modelView?.status == 0 {
                settingsBtn.isHidden = true
            }
            
            
        }
    }
    
    var imagePicker: ImagePickerController?
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBOutlet weak var tableView: ProjectEditlTableView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadProjBasicInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushEditProjVC(_:)), name: NSNotification.Name.init(pushEditProjBasicInfoNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentImagePicker), name: NSNotification.Name.init(presentImagePickerNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deliverProject(_:)), name: NSNotification.Name.init(deliverProjectNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reEditProject(_:)), name: NSNotification.Name.init(reEditProjectNotification), object: nil)
    }
    
    @objc func presentImagePicker() {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    
    @objc func pushEditProjVC(_ notification: Notification) {
        let model = notification.object as! ProjectBasicInfoModel
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "CreateProject") as! MyProjectEditAndCreateViewController
        vc.editViewModel = model
        vc.isEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deliverProject(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
            let vc = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "InvestorListVCID") as! InvestorListVC
            
            vc.projId = userInfo["projID"] as? Int
            vc.isSingle = userInfo["isSingle"] as! Bool

            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @objc func reEditProject(_ notification: Notification) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProjectEdit") as! MyProjectEditViewController
        if let id = notification.object as? Int {
            vc.projID = id
            vc.isEdited = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination
        if let identifier = segue.identifier {
            switch identifier {
            case "MPEPushTMSegue":
                let dest = destnation as! MyProjectEditTeamMembersViewController
                // TODO:- pass id to dest controller
                dest.projID = projID
                // TODO:- pass proj status to dest controller
                dest.status = modelView?.status as? Int
            case "ProjectIntroductionSegue", "ProjectIntroductionEditSegue":
                let dest = destnation as! MyProjectEditProjectIntroductionViewController
                // TODO:- pass id and string to dest controller
                dest.projID = projID
                if let desc = modelView?.projDesc, let highlight = modelView?.projHighlights {
                    dest.str1 = desc
                    dest.str2 = highlight
                }
            case "ProjectMarketAnalysisSegue", "ProjectMarketAnalysisEditSegue":
                let dest = destnation as! MyProjectEditMarketAnalysisViewController
                // TODO:- pass id and string to dest controller
                dest.projID = projID
                if  let projUserGroup   = modelView?.projUserGroup,
                    let projProfitModel = modelView?.projProfitModel,
                    let projCompetitor  = modelView?.projCompetitor,
                    let projResources   = modelView?.projResources
                {
                    dest.str1 = projUserGroup
                    dest.str2 = projProfitModel
                    dest.str3 = projCompetitor
                    dest.str4 = projResources
                }
            case "ProjectRunStatusSegue", "ProjectRunStatusEditSegue" :
                let dest = destnation as! MyProjectEditRunStatusViewController
                // TODO:- pass id and string to dest controller
                dest.projID = projID
                dest.editViewModel = modelView
            case "ProjectFundingSegue", "ProjectFundingEditSegue" :
                let dest = destnation as! MyProjectEditFundingNeedViewController
                // TODO:- pass id and string to dest controller
                dest.projID = projID
                dest.editViewModel = modelView
            case "MPESettingSegue":
                let dest = destnation as! MyProjectEditSettingsViewController
                // TODO:- pass id and string to dest controller
                dest.projID = projID
            case "MPEPushReviewSegue":
                let dest = destnation as! MyProjectReviewViewController
                dest.projID = projID
            case "MPEPushMPRIssueSegue":
                let dest = destnation as! MyProjectRejectedIssueViewController
                dest.projId = projID
            default: break
            }
            
        }
    }
    
}


extension MyProjectEditViewController {
    
    func loadProjBasicInfo() {
        
        guard let id = projID else { return }
        // MARK:- whole info
        NetWorkTool.shareInstance.getProjectEditInfo(token: access_token!, id: id) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                
                weakSelf?.modelView = ProjectDetialModel.mj_object(withKeyValues: result!["result"])
                
                // MARK:- save scan and view num
                weakSelf?.headerModelView?.foucsNum =  weakSelf?.modelView?.foucsNum
                weakSelf?.headerModelView?.scanNum =  weakSelf?.modelView?.scanNum
                weakSelf?.headerModelView?.status = weakSelf?.modelView?.status
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
        // MARK:- header cell info
        NetWorkTool.shareInstance.getProjectBasicInfo(token: access_token!, id: id) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                
                weakSelf?.headerModelView = ProjectBasicInfoModel.mj_object(withKeyValues: result!["result"])
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
    func uploadBusinessPlanBook() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        guard let businessPlan = businessPlan else { return }
        NetWorkTool.shareInstance.uploadProjectPlan(token: access_token!, id: id, businessPlan: businessPlan) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                weakSelf?.imagePicker?.presentHintMessage(hintMessgae: "上传成功", completion: { (_) in
                    weakSelf?.imagePicker?.dismiss(animated: true, completion: nil)
                })
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
}

extension MyProjectEditViewController: ImagePickerDelegate {
    
    // MARK:- image picker protocol functions
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        self.imagePicker = imagePicker
        weak var weakSelf = self
        for img in images {
            weakSelf?.businessPlan = img
        }
        imagePicker.presentConfirmationAlert(hint: "是否上传图片？") { (_) in
            weakSelf?.uploadBusinessPlanBook()
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}



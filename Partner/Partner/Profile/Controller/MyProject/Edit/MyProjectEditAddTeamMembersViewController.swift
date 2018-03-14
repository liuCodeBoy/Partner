//
//  MyProjectEditAddTeamMembersViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import ImagePicker
import Lightbox
import SCLAlertView

class MyProjectEditAddTeamMembersViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate, ImagePickerDelegate {
    
    var projID: Int?
    var memberID: Int? {
        didSet {
            modelView.id = memberID as NSNumber?
            loadMemberInfo()
        }
    }
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var isEditMember: Bool = false
    
    var identityData = [[Int : String]]()
    
    var modelView: ProjectMemberModel = ProjectMemberModel()
    
    var viewModel: ProjectMemberModel? {
        didSet {
            if let avatar = viewModel?.imgUrl {
                avatarImg.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_small"), options: .continueInBackground, completed: nil)
            }
            if let name = viewModel?.name {
                nickName.text = name
                modelView.name = name
            }
            if let identity = viewModel?.idenName, let id = viewModel?.idenId {
                idTypeLbl.text = identity
                modelView.idenId = id
            }
            if let job = viewModel?.jobName {
                jobLbl.text = job
                modelView.jobName = job
            }
            if let email = viewModel?.mail {
                emailLbl.text = email
                modelView.mail = email
            }
            if let desc = viewModel?.desc {
                inputTF.text = desc
                inputString = desc
                placeholderLbl.isHidden = true
                modelView.desc = desc
            }
        }
    }
    
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var avatarImg: RoundRectImage!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var idTypeLbl: UILabel!
    @IBOutlet weak var jobLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContentViewHCons: NSLayoutConstraint!
    @IBOutlet weak var scrollviewButtonCons: NSLayoutConstraint!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    @IBOutlet weak var inputTVSuperView: UIView!
    
    @IBOutlet weak var editView: UIView!
    
    var str: String?
    var inputString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
            // MARK:- save description
            modelView.desc = inputString
        }
    }
    @IBAction func identityClicked(_ sender: UIButton) {
        // MARK:- save identoity id
        popupPartnerPicker(bindingLabel: idTypeLbl, type: .projEditMember, model: modelView, componentDict: identityData)
    }
    
    @IBAction func uploadImg(_ sender: UIButton) {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func showInputVC(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "InputDetial") as! InputDetialViewController
        
        // MARK:- save input data
        switch sender.inputTitleID {
        case "MPEATName":
            let title = "姓名"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save name
                weakSelf?.modelView.name = vc.inputText
                weakSelf?.nickName.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "MPEATJob":
            let title = "职位"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save job name
                weakSelf?.modelView.jobName = vc.inputText
                weakSelf?.jobLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "MPEATMail":
            let title = "邮箱"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save mail
                weakSelf?.modelView.mail = vc.inputText
                weakSelf?.emailLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        default: break
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditMember == false {
            editView.isHidden = true
            navTitleLbl.text = "添加成员"
        } else {
            editView.isHidden = false
            navTitleLbl.text = "编辑成员"
        }
        
        if isIPHONEX {
            scrollviewButtonCons.constant = 40
        } else {
            scrollviewButtonCons.constant = 60
        }
        
        // load string from source controller, hide placeholder
        if str != nil {
            inputTF.text = str
            placeholderLbl.isHidden = true
            // change limit lbl
            inputString = str!
        }
        
        loadPickerData()

    }
    
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        deleteMember()
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
        if isEditMember == true {
            editAndSaveInfo()
        } else {
            createMember()
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputTF.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTF.text
    }
    
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
        imagePicker.dismiss(animated: true) {
            weak var weakSelf = self
            for img in images {
                weakSelf?.avatarImg.image = img
                weakSelf?.modelView.image = img
                
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

}

extension MyProjectEditAddTeamMembersViewController {
    // MARK:- operate member functions

    // MARK:- edit member info
    func editAndSaveInfo() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        modelView.image = avatarImg.image
        guard let id = modelView.id,
            let membName = modelView.name,
            let membJobName = modelView.jobName,
            let membMail = modelView.mail,
            let idenId = modelView.idenId
            else {
                presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
                return
        }
        
        weak var weakSelf = self
        presentConfirmationAlert(hint: "确认保存修改吗？", completion: { (_) in
            NetWorkTool.shareInstance.editMember(token: access_token!,
                                                 image: weakSelf?.modelView.image,
                                                 id: id as! Int,
                                                 membName: membName,
                                                 membJobName: membJobName,
                                                 membMail: membMail,
                                                 membDesc: weakSelf?.modelView.desc,
                                                 idenId: idenId as! Int)
            { (result, error) in
                
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    weakSelf?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        })
    }
    
    // MARK:- add member
    func createMember() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        if modelView.image != #imageLiteral(resourceName: "profile_my_project_camera_small") {
            modelView.image = avatarImg.image
        } else {
            modelView.image = nil
        }
        guard let projectId = projID,
            let membName = modelView.name,
            let membJobName = modelView.jobName,
            let membMail = modelView.mail,
            let idenId = modelView.idenId
            else {
                presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
                return
        }
        
        weak var weakSelf = self
        presentConfirmationAlert(hint: "确认添加成员吗？", completion: { (_) in
            NetWorkTool.shareInstance.addMember(token: access_token!,
                                                image: weakSelf?.modelView.image,
                                                membName: membName,
                                                membJobName: membJobName,
                                                membMail: membMail,
                                                membDesc: weakSelf?.modelView.desc,
                                                idenId: idenId as! Int,
                                                projectId: projectId)
            { (result, error) in
                
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    weakSelf?.presentHintMessage(hintMessgae: "添加成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        })
        
    }
    
    // MARK:- delete member
    func deleteMember() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID, let memberId = memberID else { return }
        
        presentConfirmationAlert(hint: "确认删除成员吗？", completion: { (_) in
            NetWorkTool.shareInstance.deleteMember(token: access_token!, id: id, memberId: memberId) { (result, error) in
                weak var weakSelf = self
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    weakSelf?.presentHintMessage(hintMessgae: "删除成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        })
        
    }
    
    // MARK:- load data
    func loadPickerData() {
        // identity data
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        NetWorkTool.shareInstance.getIndentityList(token: access_token!, type: 3) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save identity data into an array
                for dict in result!["result"] as! [[String: AnyObject]] {
                    let id = dict["id"] as! Int
                    let idenName = dict["idenName"] as! String
                    let dictElement = [id : idenName]
                    weakSelf?.identityData.append(dictElement)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    func loadMemberInfo() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        guard let memberID = memberID else { return }
        
        NetWorkTool.shareInstance.getMemberInfo(token: access_token!, memberId: memberID) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                weakSelf?.viewModel = ProjectMemberModel.mj_object(withKeyValues: result!["result"])
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
        
    }
}

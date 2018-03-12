//
//  MyProjectEditAndCreateViewController.swift
//  Partner
//
//  Created by Weslie on 25/01/2018.
//

import UIKit
import ImagePicker
import Lightbox

class MyProjectEditAndCreateViewController: UIViewController, ImagePickerDelegate {
    
    var isEdit: Bool = false
    
    var editViewModel: ProjectBasicInfoModel? {
        didSet {
            if let logo = editViewModel?.logoUrl {
                projectLogoImg.sd_setImage(with: URL.init(string: logo), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_small"), options: .continueInBackground, completed: nil)
            }
            if let name = editViewModel?.projName {
                projNameLbl.text = name
                projModel.projName = name
            }
            if let companyName = editViewModel?.compName {
                comFullNameLbl.text = companyName
                projModel.projCompName = companyName
            }
            if let contact = editViewModel?.connName {
                contactNameLbl.text = contact
                projModel.projConnName = contact
            }
            if let phone = editViewModel?.phone {
                contactPhoneLbl.text = phone
                projModel.projPhone = phone
            }
            if let mail = editViewModel?.mail {
                emailLbl.text = mail
                projModel.projMail = mail
            }
            if let identity = editViewModel?.idenName, let id = editViewModel?.idenId {
                identityLbl.text = identity
                projModel.idenId = id
            }
            if let area = editViewModel?.areaName, let id = editViewModel?.areaId {
                locationLbl.text = area
                projModel.areaId = id
            }
            if let fieldDictArray = editViewModel?.fields {
                industryLbl.text = "\(fieldDictArray.count)个"
                var str = ""
                for dict in fieldDictArray {
                    let id = dict["id"] as! Int
                    str += "\(id),"
                }
                str.removeLast(1)
                projModel.fields = str
            }
            if let round = editViewModel?.roundName, let id = editViewModel?.roundId {
                financingLbl.text = round
                projModel.roundId = id
            }
        }
    }
    
    var projModel: ProjectModel = ProjectModel()
    
    var identityData = [[Int : String]]()
    var areaData = [[String : AnyObject]]()
    
    var financingData = [[Int : String]]()
    
    @IBOutlet weak var projectLogoImg   : UIImageView!
    @IBOutlet weak var projNameLbl      : UILabel!
    @IBOutlet weak var comFullNameLbl   : UILabel!
    @IBOutlet weak var contactNameLbl   : UILabel!
    @IBOutlet weak var contactPhoneLbl  : UILabel!
    @IBOutlet weak var emailLbl         : UILabel!
    @IBOutlet weak var identityLbl      : UILabel!
    @IBOutlet weak var locationLbl      : UILabel!
    @IBOutlet weak var industryLbl      : UILabel!
    @IBOutlet weak var financingLbl     : UILabel!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadAvatarClicked(_ sender: UIButton) {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func identityClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: identityLbl, type: .projIdentity, model: projModel, componentDict: identityData)
    }
    
    @IBAction func areaClicked(_ sender: UIButton) {
        popupSecondaryPicker(bindingLabel: locationLbl, type: .projLocation
            , model: projModel, componentDict: areaData)
    }
    
    @IBAction func financingClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: financingLbl, type: .projFinancing, model: projModel, componentDict: financingData)
        
    }
    
    @IBOutlet weak var creatProjBtn: ShadowButton!
    @IBAction func createProjBtnClicked(_ sender: UIButton) {
        if isEdit == false {
            // check wheather the infomation is completed
            presentConfirmationAlert(hint: "确认要创建项目吗") { [weak self](_) in
                // MARK:- create project
                self?.saveAndCreateProj()
            }
        } else {
            presentConfirmationAlert(hint: "确认保存吗") { [weak self](_) in
                // MARK:- save project
                self?.editAndSaveProjInfo()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAndSacePickerData()
        
        if isEdit == false {
            creatProjBtn.setTitle("创建项目", for: .normal)
        } else {
            creatProjBtn.setTitle("保存信息", for: .normal)
        }

    }
    
    // MARK:- network request
    
    func loadAndSacePickerData() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        // identity data
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
        
        // province and city
        NetWorkTool.shareInstance.getProvinceAndCityList { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save province and city an array
                for dict in result!["result"]! as! [[String : AnyObject]] {
                    weakSelf?.areaData.append(dict)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
        // industry
        NetWorkTool.shareInstance.getInvestIndustryList { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save identity data into an array
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
        // financing data
        NetWorkTool.shareInstance.getRoundList { (result, error) in
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
                    let idenName = dict["roundName"] as! String
                    let dictElement = [id : idenName]
                    weakSelf?.financingData.append(dictElement)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    func saveAndCreateProj() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let logo = projModel.logo,
              let fields = projModel.fields,
              let projName = projModel.projName,
              let projcompNmae = projModel.projCompName,
              let projConnName = projModel.projConnName,
              let projPhone = projModel.projPhone,
              let projMail = projModel.projMail,
              let idenId = projModel.idenId,
              let areaId = projModel.areaId,
              let roundId = projModel.roundId
        else {
            presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
            return
        }
        NetWorkTool.shareInstance.createProject(token: access_token!, logo: logo, fields: fields, projName: projName, projCompName: projcompNmae, projConnName: projConnName, projPhone: projPhone, projMail: projMail, idenId: idenId as! Int, areaId: areaId as! Int, roundId: roundId as! Int) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- create success
                weakSelf?.presentHintMessage(hintMessgae: "创建成功", completion: { (_) in
                    weakSelf?.navigationController?.popViewController(animated: true)
                })
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    func editAndSaveProjInfo() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        projModel.logo = projectLogoImg.image
        guard let logo = projModel.logo,
            let fields = projModel.fields,
            let projName = projModel.projName,
            let projCompName = projModel.projCompName,
            let projConnName = projModel.projConnName,
            let projPhone = projModel.projPhone,
            let projMail = projModel.projMail,
            let idenId = projModel.idenId,
            let areaId = projModel.areaId,
            let roundId = projModel.roundId
            else {
                presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
                return
        }
        
        guard let id = editViewModel?.projectId else { return }
        
        NetWorkTool.shareInstance.editProject(token: access_token!,
                                              logo: logo,
                                              fields: fields,
                                              id: id as! Int,
                                              projName: projName, 
                                              projCompName: projCompName,
                                              projConnName: projConnName,
                                              projPhone: projPhone,
                                              projMail: projMail,
                                              idenId: idenId as! Int,
                                              areaId: areaId as! Int,
                                              roundId: roundId as! Int)
        { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                weakSelf?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                    weakSelf?.navigationController?.popViewController(animated: true)
                })
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination
        if destnation is InputDetialViewController {
            let dest = destnation as! InputDetialViewController
            switch segue.identifier! {
            case "projNameSegue":
                dest.navTitle           = "项目名称"
                dest.inputPlaceholder   = "请输入您的项目名称"
            case "comFullNameSegue":
                dest.navTitle           = "公司全称"
                dest.inputPlaceholder   = "请输入您的公司全称"
            case "contactNameSegue":
                dest.navTitle           = "联系人姓名"
                dest.inputPlaceholder   = "请输入联系人姓名"
            case "contactPhoneSegue":
                dest.navTitle           = "联系电话"
                dest.inputPlaceholder   = "请输入联系电话"
            case "emailSegue":
                dest.navTitle           = "邮箱"
                dest.inputPlaceholder   = "请输入邮箱"
            default: break
            }
            dest.sourceSegue = segue
        } else if destnation is MyProjectCreateIndustrySelectViewController {
            let dest = destnation as! MyProjectCreateIndustrySelectViewController
            dest.segue = segue
        }
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
                weakSelf?.projectLogoImg.image = img
                weakSelf?.projModel.logo = img
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

}

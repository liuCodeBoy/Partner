//
//  AuthResubmitEnterpriseApplianceViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/8.
//

import UIKit
import ImagePicker
import Lightbox

class AuthResubmitEnterpriseApplianceViewController: UIViewController, ImagePickerDelegate {
    
//    var containerSegue: UIStoryboardSegue?
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var viewModel: AuthModel = AuthModel()
    
    
    var areaData = [[String : AnyObject]]()
    var typeData = [[String : AnyObject]]()
    
    var authID: Int?
    
    @IBOutlet weak var entLicenseImg            : RoundRectImage!
    @IBOutlet weak var entLicenseImgBtn         : ShadowButton!
    @IBOutlet weak var entLogoImg               : RoundRectImage!
    @IBOutlet weak var entLogoImgBtn            : ShadowButton!
    @IBOutlet weak var entNameLbl               : UILabel!
    @IBOutlet weak var entTypeLbl               : UILabel!
    @IBOutlet weak var entRealNameLbl           : UILabel!
    @IBOutlet weak var entPhoneLbl              : UILabel!
    @IBOutlet weak var entMailLbl               : UILabel!
    @IBOutlet weak var entIntroLbl              : UILabel!
    @IBOutlet weak var entCreditCodeLbl         : UILabel!
    @IBOutlet weak var entLegalLbl              : UILabel!
    @IBOutlet weak var entLegalIDNumLbl         : UILabel!
    @IBOutlet weak var entLocationLbl           : UILabel!
    @IBOutlet weak var entDetialAddressLbl      : UILabel!
    
    var reSubmitSegueReceiveModel: AuthEnterpriseInfoModel?
    var reSubmitViewModel: AuthEnterpriseInfoModel? {
        didSet {
            if let license = reSubmitViewModel?.licenceUrl {
                entLicenseImg.sd_setImage(with: URL.init(string: license), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_small"), options: .continueInBackground, completed: nil)
            }
            if let logo = reSubmitViewModel?.logoUrl {
                entLogoImg.sd_setImage(with: URL.init(string: logo), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_small"), options: .continueInBackground, completed: nil)
            }
            if let name = reSubmitViewModel?.compName {
                entNameLbl.text = name
                viewModel.compName = name
            }
            if let typeList = reSubmitViewModel?.compTypeList {
                /////
                let dict = typeList.first
                let id = dict!["id"] as! Int
                let typeName = dict!["name"] as! String
                entTypeLbl.text = typeName
                viewModel.typeIds = "\(id)"
            }
            if let realName = reSubmitViewModel?.compConn {
                entRealNameLbl.text = realName
                viewModel.compConn = realName
            }
            if let phone = reSubmitViewModel?.phone {
                entPhoneLbl.text = phone
                viewModel.compConnPhone = phone
            }
            if let mail = reSubmitViewModel?.mail {
                entMailLbl.text = mail
                viewModel.compConnMail = mail
            }
            if let desc = reSubmitViewModel?.compDesc {
                entIntroLbl.text = "已输入"
                viewModel.compDesc = desc
            }
            if let creditCode = reSubmitViewModel?.creditCode {
                entCreditCodeLbl.text = creditCode
                viewModel.compCreditCode = creditCode
            }
            if let legal = reSubmitViewModel?.represent {
                entLegalLbl.text = legal
                viewModel.compRepresent = legal
            }
            if let area = reSubmitViewModel?.area, let id = reSubmitViewModel?.areaId {
                entLocationLbl.text = area
                viewModel.areaId = id
            }
            if let address = reSubmitViewModel?.detailAddr {
                entDetialAddressLbl.text = address
                viewModel.compAddrDetail = address
            }
            
        }
    }
    
    @IBAction func uploadImg(_ sender: ShadowButton) {
        // change status to not selected
        entLicenseImgBtn.isSelected = false
        entLogoImgBtn.isSelected = false
        
        // set the selected button image
        sender.isSelected = true
        
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    @IBAction func enterpriseTypeClicked(_ sender: UIButton) {
        popupSecondaryPicker(bindingLabel: entTypeLbl, type: .enterpriseType, model: viewModel, componentDict: typeData)
    }
    @IBAction func areaClicked(_ sender: UIButton) {
        popupSecondaryPicker(bindingLabel: entLocationLbl, type: .enterpriseLocation, model: viewModel, componentDict: areaData)
    }
    
    @IBAction func showInputVC(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "InputDetial") as! InputDetialViewController
        
        // MARK:- save input data
        switch sender.inputTitleID {
        case "entName":
            let title = "企业名称"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compName = vc.inputText
                weakSelf?.entNameLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entRealName":
            let title = "真实姓名"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compConn = vc.inputText
                weakSelf?.entRealNameLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entPhone":
            let title = "手机号"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compConnPhone = vc.inputText
                weakSelf?.entPhoneLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entMail":
            let title = "邮箱"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compConnMail = vc.inputText
                weakSelf?.entMailLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
            
        case "entCreditCode":
            let title = "统一信用代码"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compCreditCode = vc.inputText
                weakSelf?.entCreditCodeLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entLegal":
            let title = "法定代表人"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compRepresent = vc.inputText
                weakSelf?.entLegalLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entLegalID":
            let title = "法人身份证号"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compCardNo = vc.inputText
                weakSelf?.entLegalIDNumLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entLegalID":
            let title = "法人身份证号"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compCardNo = vc.inputText
                weakSelf?.entLegalIDNumLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "entDetialAddress":
            let title = "详细地址"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.compAddrDetail = vc.inputText
                weakSelf?.entDetialAddressLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        default: break
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func enterpriseAuthSubmit(_ sender: ShadowButton) {
        uploadEnterpriseAuthInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadModelData()
        loadAndSavePickerData()
        
        // MARK:- assign view model after UIObject initialized
        reSubmitViewModel = reSubmitSegueReceiveModel
        
    }
    
    func loadModelData() {
        guard authID != nil else { return }
        
        NetWorkTool.shareInstance.getAuthEditInfo(token: access_token!, type: 2, id: authID!, finished: { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data to model
                weakSelf?.reSubmitViewModel = AuthEnterpriseInfoModel.mj_object(withKeyValues: result!["result"])
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        })
    }
    
    func loadAndSavePickerData() {
        
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
        
        // enterprise type
        NetWorkTool.shareInstance.getCompanyTypeList(token: access_token!) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save province and city an array
                for dict in result!["result"]! as! [[String : AnyObject]] {
                    weakSelf?.typeData.append(dict)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
    }
    
    func uploadEnterpriseAuthInfo() {
        
        viewModel.licence = entLicenseImg.image
        viewModel.logo = entLogoImg.image
        
        guard let logo = viewModel.logo,
            let licence = viewModel.licence,
            let typeIds = viewModel.typeIds,
            let compName = viewModel.compName,
            let compConn = viewModel.compConn,
            let compConnPhone = viewModel.compConnPhone,
            let compConnMail = viewModel.compConnMail,
            let compDesc = viewModel.compDesc,
            let compCreditCode = viewModel.compCreditCode,
            let compRepresent = viewModel.compRepresent,
            let compCardNo = viewModel.compCardNo,
            let compAddrDetail = viewModel.compAddrDetail,
            let areaId = viewModel.areaId
            else {
                presentHintMessage(hintMessgae: "请完善信息后提交", completion: nil)
                return
        }
        
        // FIXME:- string value do not support unicode, else it will be 500 error
        
        guard let id = authID else { return } 
        NetWorkTool.shareInstance.editCompanyAuth(token: access_token!,
                                                  logo: logo,
                                                  licence: licence,
                                                  typeIds: typeIds,
                                                  id: id,
                                                  compName: compName,
                                                  compConn: compConn,
                                                  compConnPhone: compConnPhone,
                                                  compConnMail: compConnMail,
                                                  compDesc: compDesc,
                                                  compCreditCode: compCreditCode,
                                                  compRepresent: compRepresent,
                                                  compCardNo: compCardNo,
                                                  compAddrDetail: compAddrDetail,
                                                  areaId: areaId as! Int,
        finished: { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                
                weakSelf?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                    weakSelf?.navigationController?.popToRootViewController(animated: true)
                })
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        })
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
                // TODO:- set image and save to model
                if (weakSelf?.entLicenseImgBtn.isSelected)! {
                    weakSelf?.entLicenseImg.image = img
                    weakSelf?.viewModel.licence = img
                } else if (weakSelf?.entLogoImgBtn.isSelected)! {
                    weakSelf?.entLogoImg.image = img
                    weakSelf?.viewModel.logo = img
                }
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination
        if destnation is AuthInputEnterpriseDescriptionViewController {
            let dest = destnation as! AuthInputEnterpriseDescriptionViewController
            dest.segue = segue
            dest.str = viewModel.compDesc
        }
    }


}

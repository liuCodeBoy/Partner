//
//  AuthApplyEnterpriseViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/8.
//

import UIKit
import ImagePicker
import Lightbox

class AuthApplyEnterpriseViewController: UIViewController, ImagePickerDelegate {
    
    var containerSegue: UIStoryboardSegue?
    
    var viewModel: AuthModel = AuthModel()
    
    var entViewModel: AuthEnterpriseInfoModel? {
        didSet {
            if let logoUrl = entViewModel?.logoUrl {
                eentLogoImg.sd_setImage(with: URL.init(string: logoUrl), placeholderImage: #imageLiteral(resourceName: "project_logo_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let licenceUrl = entViewModel?.licenceUrl {
                eentLicenseImg.sd_setImage(with: URL.init(string: licenceUrl), placeholderImage: UIImage.init(color: #colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1), size: entLicenseImg.frame.size), options: .continueInBackground, completed: nil)
            }
            if let compName = entViewModel?.compName {
                eentNameLbl.text = compName
            }
            if let compTypeList = entViewModel?.compTypeList {
                var count = 0
                var title = [String]()
                for dict in compTypeList {
                    let name = dict["name"]
                    title.append(name as! String)
                    count += 1
                }
                // set label title
                //                for i in 0..<count {
                //                    invIndustryLbl[i].text = title[i]
                //                }
                // hide unused label
                //                for j in count..<9 {
                //                    invIndustryLbl[j].isHidden = true
                //                }
                for i in 0..<8 {
                    eentTypeLbl[i].isHidden = true
                }
                eentTypeLbl[1].isHidden = false
                eentTypeLbl[1].text = title.first
            }
            if let compConn = entViewModel?.compConn {
                eentRealNameLbl.text = compConn
            }
            if let phone = entViewModel?.phone {
                eentPhoneLbl.text = phone
            }
            if let mail = entViewModel?.mail {
                eentMailLbl.text = mail
            }
            if let compDesc = entViewModel?.compDesc {
                eentIntroLbl.text = compDesc
            }
            if let creditCode = entViewModel?.creditCode {
                eentCreditCodeLbl.text = creditCode
            }
            if let represent = entViewModel?.represent {
                eentLegalLbl.text = represent
            }
            if let area = entViewModel?.area {
                eentLocationLbl.text = area
            }
            if let detailAddr = entViewModel?.detailAddr {
                eentDetialAddressLbl.text = detailAddr
            }
            if let auth = entViewModel?.auth {
                // 0未认证 1认证中 2通过 3不通过
                switch auth {
                case 0:
                    inReviewView.isHidden = false
                    rejectedView.isHidden = true
                    inReviewBtn.setTitle("未认证", for: .normal)
                case 1:
                    inReviewView.isHidden = false
                    rejectedView.isHidden = true
                    inReviewBtn.setTitle("审核中", for: .normal)
                case 2:
                    inReviewView.isHidden = false
                    rejectedView.isHidden = true
                    inReviewBtn.setTitle("已通过", for: .normal)
                    inReviewBtn.setTitleColor(#colorLiteral(red: 0.5411764979, green: 0.631372571, blue: 0.6980392337, alpha: 1), for: .normal)
                case 3:
                    inReviewView.isHidden = true
                    rejectedView.isHidden = false
                default: break
                }
            }
        }
    }
    
    var areaData = [[String : AnyObject]]()
    var typeData = [[String : AnyObject]]()
    
    @IBOutlet weak var enterpriseAuthScrollView: UIScrollView!
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
    
    @IBOutlet weak var eenterpriseAuthScrollView : UIScrollView!
    @IBOutlet weak var eentLicenseImg            : RoundRectImage!
    @IBOutlet weak var eentLogoImg               : RoundRectImage!
    @IBOutlet var eentTypeLbl                    : [StrokeLabel]!
    
    @IBOutlet weak var eentNameLbl               : UILabel!
    @IBOutlet weak var eentRealNameLbl           : UILabel!
    @IBOutlet weak var eentPhoneLbl              : UILabel!
    @IBOutlet weak var eentMailLbl               : UILabel!
    @IBOutlet weak var eentIntroLbl              : UILabel!
    @IBOutlet weak var eentCreditCodeLbl         : UILabel!
    @IBOutlet weak var eentLegalLbl              : UILabel!
    @IBOutlet weak var eentLocationLbl           : UILabel!
    @IBOutlet weak var eentDetialAddressLbl      : UILabel!
    
    @IBOutlet weak var inReviewView: UIView!
    @IBOutlet weak var inReviewBtn: ShadowButton!
    @IBOutlet weak var rejectedView: UIView!
    
    @IBOutlet weak var inReviewHCons: NSLayoutConstraint!
    @IBOutlet weak var rejectHCons: NSLayoutConstraint!
    
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
        let mainVC = containerSegue?.source as! AuthApplyUploadViewController
        mainVC.popupSecondaryPicker(bindingLabel: entTypeLbl, type: .enterpriseType, model: viewModel, componentDict: typeData)
    }
    @IBAction func areaClicked(_ sender: UIButton) {
        let mainVC = containerSegue?.source as! AuthApplyUploadViewController
        mainVC.popupSecondaryPicker(bindingLabel: entLocationLbl, type: .enterpriseLocation, model: viewModel, componentDict: areaData)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        loadAndSavePickerData()
        judgeAuthStatus()
        
        eenterpriseAuthScrollView.isHidden = true
        
        if isIPHONEX {
            inReviewHCons.constant += 14
            rejectHCons.constant += 14
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func judgeAuthStatus() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        // MARK:- load enterprise auth info
        NetWorkTool.shareInstance.getAuthInfo(token: access_token!, type: 2) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- judge the auth status
                if (result!["result"] as? [String : AnyObject]) != nil {
                    if let auth = result!["result"]!["auth"] as? Int, auth == 0 {
                        // not verified
                        // TODO:- hide cover view
                        weakSelf?.enterpriseAuthScrollView.isHidden = false
                        weakSelf?.eenterpriseAuthScrollView.isHidden = true
                        weakSelf?.rejectedView.isHidden = true
                        weakSelf?.inReviewView.isHidden = true
                    } else {
                        // TODO:- save to model
                        let resultDict = result!["result"] as! [String : AnyObject]
                        weakSelf?.entViewModel = AuthEnterpriseInfoModel.mj_object(withKeyValues: resultDict)

                        // TODO:- show infomation
                        let auth = weakSelf?.entViewModel?.auth as! Int //0未认证 1认证中 2通过 3不通过
                        
                        switch auth {
                        case 0:
                            weakSelf?.enterpriseAuthScrollView.isHidden = false
                            weakSelf?.eenterpriseAuthScrollView.isHidden = true
                            weakSelf?.rejectedView.isHidden = true
                            weakSelf?.inReviewView.isHidden = true
                        case 1:
                            weakSelf?.enterpriseAuthScrollView.isHidden = true
                            weakSelf?.eenterpriseAuthScrollView.isHidden = false
                            weakSelf?.rejectedView.isHidden = true
                            weakSelf?.inReviewView.isHidden = false
                        case 2:
                            weakSelf?.enterpriseAuthScrollView.isHidden = true
                            weakSelf?.eenterpriseAuthScrollView.isHidden = false
                            weakSelf?.rejectedView.isHidden = true
                            weakSelf?.inReviewView.isHidden = true
                        case 3:
                            weakSelf?.enterpriseAuthScrollView.isHidden = true
                            weakSelf?.eenterpriseAuthScrollView.isHidden = false
                            weakSelf?.rejectedView.isHidden = false
                            weakSelf?.inReviewView.isHidden = true
                        default: break
                        }
                    }
                } else {
                    // not verified
                    // TODO:- hide cover view
                    weakSelf?.enterpriseAuthScrollView.isHidden = false
                    weakSelf?.eenterpriseAuthScrollView.isHidden = true
                    weakSelf?.rejectedView.isHidden = true
                    weakSelf?.inReviewView.isHidden = true
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    func uploadEnterpriseAuthInfo() {
        
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
        
        NetWorkTool.shareInstance.authCompany(token: access_token!,
                                              logo: logo,
                                              licence: licence,
                                              typeIds: typeIds,
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
                    weakSelf?.navigationController?.popViewController(animated: true)
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
        if destnation is AuthInvestIndustrySelectViewController {
            let dest = destnation as! AuthInvestIndustrySelectViewController
            dest.segue = segue
        } else if destnation is AuthResubmitEnterpriseApplianceViewController {
            let dest = destnation as! AuthResubmitEnterpriseApplianceViewController
//            dest.containerSegue = containerSegue
            dest.reSubmitSegueReceiveModel = entViewModel
            dest.authID = entViewModel?.compAuthId as? Int
        } else if destnation is AuthInputEnterpriseDescriptionViewController {
            let dest = destnation as! AuthInputEnterpriseDescriptionViewController
            dest.segue = segue
            dest.str = entViewModel?.compDesc
        }
    }
    
}

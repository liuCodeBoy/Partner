//
//  AuthApplyUploadViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit
import ImagePicker
import Lightbox

class AuthApplyUploadViewController: UIViewController, ImagePickerDelegate {
    
    var viewModel: AuthModel = AuthModel()
    
    var datePicker: UIDatePicker?
    
    var idenID: NSNumber? {
        didSet {
            // judge weather is the investor organization
            if idenID == 5 {
                invAgencyView.isHidden = false
            } else {
                invAgencyView.isHidden = true
            }
        }
    }
    
    var identityData = [[Int : String]]()
    var financingData = [[Int : String]]()
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // invest auth
    @IBOutlet weak var investAuth               : ShadowButton!
    @IBOutlet weak var investAuthScrollView     : UIScrollView!
    @IBOutlet weak var invAvatarImg             : RoundRectImage!
    @IBOutlet weak var invAvatarImgBtn          : ShadowButton!
    @IBOutlet weak var invCardImg               : RoundRectImage!
    @IBOutlet weak var invCardImgBtn            : ShadowButton!
    @IBOutlet weak var invRealNameLbl           : UILabel!
    @IBOutlet weak var invPhoneNumLbl           : UILabel!
    @IBOutlet weak var invEmailLbl              : UILabel!
    @IBOutlet weak var invIndustryLbl           : UILabel!
    @IBOutlet weak var invRoundLbl              : UILabel!
    @IBOutlet weak var invIdentityLbl           : UILabel!
    @IBOutlet weak var invAgencyView            : UIView!
    @IBOutlet weak var invAgencyNameLbl         : UILabel!
    @IBOutlet weak var invAgencyJobLbl          : UILabel!
    @IBOutlet weak var invAgencyOnWorkTimeLbl   : UILabel!
    
    // enterprise auth
    @IBOutlet weak var enterpriseAuth           : ShadowButton!
    @IBOutlet weak var enterpriseAuthScrollView : UIScrollView!
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
    
    
    @IBAction func investAuthClicked(_ sender: ShadowButton) {
        investAuth.setSelected()
        enterpriseAuth.reverseSelected()
        investAuthScrollView.isHidden = false
        enterpriseAuthScrollView.isHidden = true
    }
    
    @IBAction func enterpriseAuthClicked(_ sender: ShadowButton) {
        investAuth.reverseSelected()
        enterpriseAuth.setSelected()
        investAuthScrollView.isHidden = true
        enterpriseAuthScrollView.isHidden = false
    }
    
    @IBAction func showInputVC(_ sender: UIButton) {
        
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "InputDetial") as! InputDetialViewController
        
        // MARK:- save input data
        switch sender.inputTitleID {
        case "invRealName":
            let title = "真实姓名"
            vc.navTitle = "真实姓名"
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                self.viewModel.inveRealName = vc.inputText
                self.invRealNameLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invPhoneNum":
            let title = "手机号"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                self.viewModel.invePhone = vc.inputText
                self.invPhoneNumLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invEmail":
            let title = "邮箱"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                self.viewModel.inveMail = vc.inputText
                self.invEmailLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invAgencyName":
            let title = "机构名称"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                self.viewModel.instName = vc.inputText
                self.invAgencyNameLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invAgencyJob":
            let title = "职位"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                self.viewModel.instJobName = vc.inputText
                self.invAgencyJobLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        default: break
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func financingRoundClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: invRoundLbl, type: .authFinancing, model: viewModel, componentDict: financingData)
    }
    @IBAction func identityClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: invIdentityLbl, type: .authIdentity, model: viewModel, componentDict: identityData)
        
    }
    @IBAction func workTimeClicked(_ sender: UIButton) {
        
        let picker = Bundle.main.loadNibNamed("PartnerTimePicker", owner: nil, options: nil)?.first as! PartnerTimePicker
        picker.frame = UIScreen.main.bounds
        picker.pickerTitle.text = "选择任职时间"
        datePicker = picker.datePicker
        
        self.view.addSubview(picker)
        
    }
    
    
    @IBAction func uploadImg(_ sender: ShadowButton) {
        // change status to not selected
        invAvatarImgBtn.isSelected = false
        invCardImgBtn.isSelected = false
        entLicenseImgBtn.isSelected = false
        entLogoImgBtn.isSelected = false
        
        // set the selected button image 
        sender.isSelected = true
        
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func investAuthSumbit(_ sender: ShadowButton) {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        uploadInvestAuthInfo()
        
        
    }
    @IBAction func enterpriseAuthSubmit(_ sender: ShadowButton) {
    }
    
    override func viewWillLayoutSubviews() {
        // show or hide the agency select view
        idenID = viewModel.idenId
        // save date
        if datePicker != nil {
            let year = datePicker!.date.year()
            let month = datePicker!.date.month()
            let day = datePicker!.date.day()
            let date = "\(year)-\(month)-\(day)"
            viewModel.inTime = date
            invAgencyOnWorkTimeLbl.text = date
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAndSavePickerData()
        
        invAgencyView.isHidden = true
        
    }

    func loadAndSavePickerData() {
        
        // identity data
        NetWorkTool.shareInstance.getIndentityList(token: access_token!, type: 2) { (result, error) in
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
    
    func uploadInvestAuthInfo() {
        guard   let image = viewModel.image,
                let nameCard = viewModel.nameCard,
                let industryIds = viewModel.industryIds,
                let inveRealName = viewModel.inveRealName,
                let invePhone = viewModel.invePhone,
                let inveMail = viewModel.inveMail,
                let inveRound = viewModel.inveRound,
                let idenId = viewModel.idenId
        else {
            presentHintMessage(hintMessgae: "请完善信息后提交", completion: nil)
            return
        }
        if idenId == 5 && (viewModel.instName == nil || viewModel.instJobName == nil || viewModel.inTime == nil) {
            presentHintMessage(hintMessgae: "请完善信息后提交", completion: nil)
            return
        }
        NetWorkTool.shareInstance.authInvestor(token: access_token!,
                                               image: image,
                                               nameCard: nameCard,
                                               industryIds: industryIds,
                                               inveRealName: inveRealName,
                                               invePhone: invePhone,
                                               inveMail: inveMail,
                                               inveRound: inveRound as! Int,
                                               idenId: idenId as! Int,
                                               instName: viewModel.instName,
                                               instJobName: viewModel.instJobName,
                                               inTime: viewModel.inTime)
        { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save identity data into an array
                weakSelf?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                    weakSelf?.navigationController?.popViewController(animated: true)
                })
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
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
                // TODO:- set image and save to model
                if (weakSelf?.invAvatarImgBtn.isSelected)! {
                    weakSelf?.invAvatarImg.image = img
                    weakSelf?.viewModel.image = img
                } else if (weakSelf?.invCardImgBtn.isSelected)! {
                    weakSelf?.invCardImg.image = img
                    weakSelf?.viewModel.nameCard = img
                } else if (weakSelf?.entLicenseImgBtn.isSelected)! {
                    weakSelf?.entLicenseImg.image = img
                    weakSelf?.viewModel.logo = img
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
        let dest = segue.destination as! AuthInvestIndustrySelectViewController
        dest.segue = segue
    }


}

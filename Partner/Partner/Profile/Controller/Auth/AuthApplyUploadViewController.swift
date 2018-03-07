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
    
    var areaData = [[String : AnyObject]]()
    var typeData = [[String : AnyObject]]()
    
    var isResumbit: Bool = false
    var authID: Int? 
    
    var reSubmitViewModel: AuthInfoModel? {
        didSet {
            invSumbitBtn.setTitle("重新提交", for: .normal)
            if let avatar = reSubmitViewModel?.imgUrl {
                invAvatarImg.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_small"), options: .continueInBackground, completed: nil)
            }
            if let card = reSubmitViewModel?.nameCardUrl {
                invCardImg.sd_setImage(with: URL.init(string: card), placeholderImage: #imageLiteral(resourceName: "profile_my_project_business_card_small"), options: .continueInBackground, completed: nil)
            }
            if let realName = reSubmitViewModel?.realName {
                invRealNameLbl.text = realName
                // resubmit upload
                viewModel.inveRealName = realName
            }
            if let phone = reSubmitViewModel?.phone {
                invPhoneNumLbl.text = phone
                // resubmit upload
                viewModel.invePhone = phone
            }
            if let mail = reSubmitViewModel?.mail {
                invEmailLbl.text = mail
                // resubmit upload
                viewModel.inveMail = mail
            }
            if let industry = reSubmitViewModel?.industryList {
                // TODO:- show the count of the list
                let count = industry.count
                invIndustryLbl.text = "\(count)个"
                // TODO:- pass data to next view controller
                
                // resubmit upload
                var idString = ""
                for dict in industry {
                    let id = dict["id"] as! Int
                    idString += "\(id),"
                }
                idString.removeLast(1)
                viewModel.industryIds = idString
            }
            if let industryName = reSubmitViewModel?.instName {
                invAgencyNameLbl.text = industryName
            }
            if let round = reSubmitViewModel?.inveRound, let id = reSubmitViewModel?.roundId {
                invRoundLbl.text = round
                // resubmit upload
                viewModel.inveRound = id
            }
            if let identity = reSubmitViewModel?.inveIdentity, let id = reSubmitViewModel?.inveIdenId {
                invIdentityLbl.text = identity
                // resubmit upload
                viewModel.idenId = id
            }
            if let name = reSubmitViewModel?.instName {
                invAgencyNameLbl.text = name
                // resubmit upload
                viewModel.instName = name
            }
            if let job = reSubmitViewModel?.instJobName {
                invAgencyJobLbl.text = job
                // resubmit upload
                viewModel.instJobName = job
            }
            if let time = reSubmitViewModel?.inTime {
                invAgencyOnWorkTimeLbl.text = time
                // resubmit upload
                viewModel.inTime = time
            }
            
        }
    }
    
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
    @IBOutlet weak var invSumbitBtn: ShadowButton!
    
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
                weak var weakSelf = self
                weakSelf?.viewModel.inveRealName = vc.inputText
                weakSelf?.invRealNameLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invPhoneNum":
            let title = "手机号"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.invePhone = vc.inputText
                weakSelf?.invPhoneNumLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invEmail":
            let title = "邮箱"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.inveMail = vc.inputText
                weakSelf?.invEmailLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invAgencyName":
            let title = "机构名称"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.instName = vc.inputText
                weakSelf?.invAgencyNameLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "invAgencyJob":
            let title = "职位"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                weakSelf?.viewModel.instJobName = vc.inputText
                weakSelf?.invAgencyJobLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
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
    
    @IBAction func financingRoundClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: invRoundLbl, type: .authFinancing, model: viewModel, componentDict: financingData)
    }
    @IBAction func identityClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: invIdentityLbl, type: .authIdentity, model: viewModel, componentDict: identityData)
    }
    @IBAction func enterpriseTypeClicked(_ sender: UIButton) {
        popupSecondaryPicker(bindingLabel: entTypeLbl, type: .enterpriseType, model: viewModel, componentDict: typeData)
    }
    @IBAction func areaClicked(_ sender: UIButton) {
        popupSecondaryPicker(bindingLabel: entLocationLbl, type: .location, model: viewModel, componentDict: areaData)
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
    
    // MARK:- update auth infomation
    @IBAction func investAuthSumbit(_ sender: ShadowButton) {
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
        // show or hide agency view
        if reSubmitViewModel?.inveIdentity == "投资机构" {
            invAgencyView.isHidden = false
        } else {
            invAgencyView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
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
        
        if isResumbit == true {
            
            guard authID != nil else { return }
            
            NetWorkTool.shareInstance.getAuthEditInfo(token: access_token!, type: 1, id: authID!, finished: { (result, error) in
                weak var weakSelf = self
                if error != nil {
                    weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                    print(error as AnyObject)
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data to model
                    weakSelf?.reSubmitViewModel = AuthInfoModel.mj_object(withKeyValues: result!["result"])
                } else {
                    weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
                }
            })
        }
    }
    
    func uploadInvestAuthInfo() {
        
        // MARK:- resubmit upload image
        if isResumbit == true {
            viewModel.image = invAvatarImg.image
            viewModel.nameCard = invCardImg.image
        }
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
        
        // MARK:- judge the value if it is nil
        if idenId == 5 {
            guard let instName = viewModel.instName, let instJobName = viewModel.instJobName, let inTime = viewModel.inTime else {
                presentHintMessage(hintMessgae: "请完善信息后提交", completion: nil)
                return
            }
            if instName.isEmptyString || instJobName.isEmptyString || inTime.isEmptyString {
                presentHintMessage(hintMessgae: "请完善信息后提交", completion: nil)
                return
            }
        }
        
        // MARK:- wheather is the first sumbit
        if isResumbit == false {
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
        } else {
            // MARK:- not the first commit
            guard let id = authID else { return }
            NetWorkTool.shareInstance.editInvestorAuth(token: access_token!,
                                                       image: image,
                                                       nameCard: nameCard,
                                                       industryIds: industryIds,
                                                       id: id,
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
        }
    }


}

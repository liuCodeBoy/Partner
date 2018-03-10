//
//  AuthResubmitInvestAppliacneViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/8.
//

import UIKit
import ImagePicker
import Lightbox

class AuthResubmitInvestAppliacneViewController: UIViewController, ImagePickerDelegate {
    
//    var containerSegue: UIStoryboardSegue?
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var viewModel: AuthModel = AuthModel()
    
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
    
    var authID: Int?
    
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
    
    var datePicker: UIDatePicker?
    
    var reSubmitSegueReceiveModel: AuthInvestInfoModel?
    var reSubmitViewModel: AuthInvestInfoModel? {
        didSet {
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
            
        default: break
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func uploadImg(_ sender: ShadowButton) {
        // change status to not selected
        invAvatarImgBtn.isSelected = false
        invCardImgBtn.isSelected = false
        // set the selected button image
        sender.isSelected = true
        
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
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
    // MARK:- update auth infomation
    @IBAction func investAuthSumbit(_ sender: ShadowButton) {
        uploadInvestAuthInfo()
    }

    override func viewWillLayoutSubviews() {
        // show or hide agency view
        if reSubmitViewModel?.inveIdentity == "投资机构" {
            invAgencyView.isHidden = false
        } else {
            invAgencyView.isHidden = true
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadModelData()
        loadAndSavePickerData()
        
        invAgencyView.isHidden = true
        
        // MARK:- assign view model after UIObject initialized
        reSubmitViewModel = reSubmitSegueReceiveModel

    }
    
    func loadModelData() {
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
                weakSelf?.reSubmitViewModel = AuthInvestInfoModel.mj_object(withKeyValues: result!["result"])
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        })
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
        
        viewModel.image = invAvatarImg.image
        viewModel.nameCard = invCardImg.image
        
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
                    weakSelf?.navigationController?.popToRootViewController(animated: true)
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
        } else if destnation is AuthInputEnterpriseDescriptionViewController {
            let dest = destnation as! AuthInputEnterpriseDescriptionViewController
            dest.segue = segue
            dest.str = viewModel.compDesc
        }
    }
    

}

//
//  AuthApplyInvestViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/8.
//

import UIKit
import ImagePicker
import Lightbox

class AuthApplyInvestViewController: UIViewController, ImagePickerDelegate {
    
    var viewModel: AuthModel = AuthModel()
    
    var invViewModel: AuthInvestInfoModel? {
        didSet {
            // MARK:- assign value to the label etc.
            if let imgUrl = invViewModel?.imgUrl {
                invAvatarImg.sd_setImage(with: URL.init(string: imgUrl), placeholderImage: #imageLiteral(resourceName: "profile_my_project_camera_big"), options: .continueInBackground, completed: nil)
            }
            if let nameCardUrl = invViewModel?.nameCardUrl {
                invCardImg.sd_setImage(with: URL.init(string: nameCardUrl), placeholderImage: #imageLiteral(resourceName: "profile_my_project_business_card_big"), options: .continueInBackground, completed: nil)
            }
            if let inveRound = invViewModel?.inveRound {
                invRoundLbl.text = inveRound
            }
            if let realName = invViewModel?.realName {
                invRealNameLbl.text = realName
            }
            if let inveIndentity = invViewModel?.inveIndentity {
                if inveIndentity.hasPrefix("机构") {
                    iinvIdentityBtn.setTitle("机构", for: .normal)
                } else if inveIndentity.hasPrefix("个人") {
                    iinvIdentityBtn.setTitle("个人", for: .normal)
                }
            }
            if let industryList = invViewModel?.industryList {
                var count = 0
                var title = [String]()
                for dict in industryList {
                    let name = dict["name"]
                    title.append(name as! String)
                    count += 1
                }
                // set label title
                for i in 0..<count {
                    iinvIndustryLbl[i].text = title[i]
                }
                // hide unused label
                for j in count..<9 {
                    iinvIndustryLbl[j].isHidden = true
                }
            }
            if let phone = invViewModel?.phone {
                invPhoneNumLbl.text = phone
            }
            if let mail = invViewModel?.mail {
                invEmailLbl.text = mail
            }
            if let instName = invViewModel?.instName {
                invAgencyNameLbl.text = instName
            }
            if let instJobName = invViewModel?.instJobName {
                invAgencyJobLbl.text = instJobName
            }
            if let auth = invViewModel?.auth {
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
            if let time = invViewModel?.inTime {
                invAgencyOnWorkTimeLbl.text = time
            }
        }
    }
    
    var identityData = [[Int : String]]()
    var financingData = [[Int : String]]()
    
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
    
    @IBOutlet weak var iinvestAuthScrollView     : UIScrollView!
    @IBOutlet weak var iinvAvatarImg             : RoundRectImage!
    @IBOutlet weak var iinvCardImg               : RoundRectImage!
    @IBOutlet weak var iinvRealNameLbl           : UILabel!
    @IBOutlet weak var iinvPhoneNumLbl           : UILabel!
    @IBOutlet weak var iinvEmailLbl              : UILabel!
    @IBOutlet var iinvIndustryLbl                : [StrokeLabel]!
    
    @IBOutlet weak var iinvRoundLbl              : UILabel!
    @IBOutlet weak var iinvIdentityBtn           : UIButton!
    @IBOutlet weak var iinvAgencyView            : UIView!
    @IBOutlet weak var iinvAgencyNameLbl         : UILabel!
    @IBOutlet weak var iinvAgencyJobLbl          : UILabel!
    @IBOutlet weak var iinvAgencyOnWorkTimeLbl   : UILabel!
    
    var datePicker: UIDatePicker?
    
    @IBOutlet weak var inReviewView: UIView!
    @IBOutlet weak var inReviewBtn: ShadowButton!
    @IBOutlet weak var rejectedView: UIView!
    
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
        
        loadAndSavePickerData()
        judgeAuthStatus()
        
        invAgencyView.isHidden = true
        iinvestAuthScrollView.isHidden = true

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
    
    func judgeAuthStatus() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        // MARK:- load invest auth info
        NetWorkTool.shareInstance.getAuthInfo(token: access_token!, type: 1) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- judge the auth status
                if result!["result"]!["auth"] as! Int == 0 {
                    // not verified
                    // TODO:- hide cover view
                    weakSelf?.iinvestAuthScrollView.isHidden = true
                } else {
                    // verified
                    // TODO:- save to model
                    let resultDict = result!["result"] as! [String : AnyObject]
                    weakSelf?.invViewModel = AuthInvestInfoModel.mj_object(withKeyValues: resultDict)
                    // TODO:- show infomation
                    weakSelf?.iinvestAuthScrollView.isHidden = false
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
        } else if destnation is AuthResubmitInvestAppliacneViewController {
            let dest = destnation as! AuthResubmitInvestAppliacneViewController
            dest.reSubmitViewModel = invViewModel
            dest.authID = invViewModel?.inveAuthId as? Int
        }
    }

}

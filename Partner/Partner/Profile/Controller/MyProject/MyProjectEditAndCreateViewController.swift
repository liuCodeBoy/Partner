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
    
    var identityData = [[Int : String]]()
    var identityId: Int?
    
    var areaData = [[String : AnyObject]]()
    var areaID: NSInteger = 2
    
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
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func identityClicked(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("PartnerSinglePickerView", owner: nil, options: nil)?.first as! PartnerSinglePickerView
        picker.frame = UIScreen.main.bounds
        var nameArray = [String]()
        for dict in identityData {
            nameArray.append((dict.first?.value)!)
        }
        picker.componentArray = nameArray
        picker.pickerTitle.text = "选择身份"
        picker.inputLbl = identityLbl
        self.view.addSubview(picker)
    }
    
    @IBAction func areaClicked(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("PartnerPickerView", owner: nil, options: nil)?.first as! PartnerPickerView
        picker.frame = UIScreen.main.bounds
        picker.twoDimensionArray = areaData
        picker.pickerTitle.text = "选择所在区域"
        picker.inputLbl = locationLbl
        picker.areaId = areaID
        self.view.addSubview(picker)
    }
    
    @IBAction func industryClicked(_ sender: UIButton) {
        print(areaID)
    }
    
    @IBAction func financingClicked(_ sender: UIButton) {
    }
    
    @IBAction func createProjBtnClicked(_ sender: ShadowButton) {
        // check wheather the infomation is completed
        if  projectLogoImg.image    !=   #imageLiteral(resourceName: "profile_my_project_camera_small")     &&
            projNameLbl.text        != "请输入"  &&
            comFullNameLbl.text     != "请输入"  &&
            contactNameLbl.text     != "请输入"  &&
            contactPhoneLbl.text    != "请输入"  &&
            emailLbl.text           != "请输入"  &&
            identityLbl.text        != "请选择"  &&
            locationLbl.text        != "请选择"  &&
            industryLbl.text        != "请选择"  &&
            financingLbl.text       != "请选择"
        {
            // TODO:- the infomation has completed, post request to upload
            
            presentHintMessage(hintMessgae: "创建成功", completion: { [weak self](_) in
                self?.navigationController?.popViewController(animated: true)
            })
        } else {
            presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
        }
        
        presentConfirmationAlert(hint: "确认要创建项目吗") { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAndSacePickerData()

    }
    
    func loadAndSacePickerData() {
        checkLoginStatus()
        // MARK:- identity data
        NetWorkTool.shareInstance.getIndentityList(token: access_token!, type: 3) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
            }
            if result!["code"] as! Int == 200 {
               // TODO:- save identity data into an array
                for dict in result!["result"] as! [[String: AnyObject]] {
                    let id = dict["id"] as! Int
                    let idenName = dict["idenName"] as! String
                    let dictElement = [id : idenName]
                    weakSelf?.identityData.append(dictElement)
                }
                weakSelf?.identityId = weakSelf?.identityData.first?.first?.key
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
        // MARK:- province and city
        NetWorkTool.shareInstance.getProvinceAndCityList { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(identityData)
        let dest = segue.destination as! InputDetialViewController
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
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

}

//
//  InputDetialViewController.swift
//  Partner
//
//  Created by Weslie on 25/01/2018.
//

import UIKit

class InputDetialViewController: UIViewController {
    
    var sourceSegue: UIStoryboardSegue?
    var keyboardType: UIKeyboardType?
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc var saveClousre: (() -> Void)?
    
    var navTitle: String?
    var inputPlaceholder: String?
    var inputLimit: Int = 24
    
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var inputTF: UITextField!
    
    var inputText: String? {
        didSet {
            // change the button's state
            if inputText == nil || inputText!.isEmptyString {
                saveBtn.isEnabled = false
            } else {
                saveBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func inputTextChanged(_ sender: UITextField) {
        inputText = inputTF.text
    }
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if inputText == nil || inputText!.isEmptyString {
            presentHintMessage(hintMessgae: "输入不能为空", completion: nil)
        }
        if inputText!.count > inputLimit {
            presentConfirmationAlert(hint: "输入字数不能超过\(inputLimit)字", completion: nil)
            return
        }
        
        // MARK:- judge
        if navTitle == "转让股份（%）", (Int(inputText!)! >= 0 && Int(inputText!)! <= 100) == false {
            presentHintMessage(hintMessgae: "请输入有效的百分数", completion: nil)
            return
        } else if navTitle == "手机号", inputText!.isValidePhoneNumber == false {
            presentHintMessage(hintMessgae: "请输入有效的手机号", completion:  nil)
            return
        } else if navTitle == "邮箱", inputText!.isValidEmail == false {
            presentHintMessage(hintMessgae: "请输入有效的邮箱", completion:  nil)
            return
        } else  if navTitle == "法人身份证号", inputText!.isValidIDNumber == false {
            presentHintMessage(hintMessgae: "请输入有效的身份证", completion:  nil)
            return
        }
        
        guard let identifier = sourceSegue?.identifier else { return }
        guard let sourceSegue = sourceSegue else { return }
        
        // judge the segue source view controller 
        // pass data to the segue source view controller
        
        if sourceSegue.source.isKind(of: MyProjectEditAndCreateViewController.self) {
            let source = sourceSegue.source as! MyProjectEditAndCreateViewController
            switch identifier {
            case "projNameSegue":
                source.projNameLbl.text         = inputText
                source.projModel.projName       = inputText
            case "comFullNameSegue":
                source.comFullNameLbl.text      = inputText
                source.projModel.projCompName   = inputText
            case "contactNameSegue":
                source.contactNameLbl.text      = inputText
                source.projModel.projConnName   = inputText
            case "contactPhoneSegue":
                if inputText!.isValidePhoneNumber == false {
                    presentHintMessage(hintMessgae: "请输入正确的手机号", completion: nil)
                    return
                }
                source.contactPhoneLbl.text     = inputText
                source.projModel.projPhone      = inputText
            case "emailSegue":
                if inputText!.isValidEmail == false {
                    presentHintMessage(hintMessgae: "请输入正确的手机号", completion: nil)
                    return
                }
                source.emailLbl.text            = inputText
                source.projModel.projMail       = inputText
            default: break
            }
        } else if sourceSegue.source.isKind(of: MyHomePageAddEntrepreneurshipExperienceViewController.self) {
            let source = sourceSegue.source as! MyHomePageAddEntrepreneurshipExperienceViewController
            switch identifier {
            case "MHPEEProjNameSegue":
                source.projNameLbl.text = inputText
                source.modelView?.entrProjName = inputText
            case "MHPEELocationSegue":
                source.locationLbl.text = inputText
                source.modelView?.entrIndustry = inputText
            case "MHPEEBelongedSegue":
                source.belongedLbl.text = inputText
                source.modelView?.entrArea = inputText
            default: break
            }
        } else if sourceSegue.source.isKind(of: MyHomePageAddWorkExperienceViewController.self) {
            let source = sourceSegue.source as! MyHomePageAddWorkExperienceViewController
            switch identifier {
            case "MHPWEComNameSegue":
                source.companyNameLbl.text = inputText
                source.modelView?.jobCompName = inputText
            case "MHPWEJobNameSegue":
                source.positionLbl.text = inputText
                source.modelView?.jobName = inputText
            default: break
            }
        } else if sourceSegue.source.isKind(of: MyHomePageAddEducationExperienceViewController.self) {
            let source = sourceSegue.source as! MyHomePageAddEducationExperienceViewController
            switch identifier {
            case "MHPEduEMajorSegue":
                source.majorLbl.text = inputText
                source.modelView?.eduSpecialty = inputText
            case "MHPEduESchoolSegue":
                source.schoolLbl.text = inputText
                source.modelView?.eduSchool = inputText
            default: break
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputTF.becomeFirstResponder()
    }
    
    @objc func saveBtnCallBack() {
        saveClousre!()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitleLbl.text = navTitle
        inputTF.placeholder = inputPlaceholder
        
        if saveClousre != nil {
            saveBtn.addTarget(self, action: #selector(saveBtnCallBack), for: .touchUpInside)
        }
        
        if keyboardType != nil {
            inputTF.keyboardType = keyboardType!
        }
    }
    

}

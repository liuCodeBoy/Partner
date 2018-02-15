//
//  InputDetialViewController.swift
//  Partner
//
//  Created by Weslie on 25/01/2018.
//

import UIKit

class InputDetialViewController: UIViewController {
    
    var sourceSegue: UIStoryboardSegue?
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var navTitle: String?
    var inputPlaceholder: String?
    
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
        
        guard let identifier = sourceSegue?.identifier else { return }
        guard let sourceSegue = sourceSegue else { return }
        
        // judge the segue source view controller 
        // pass data to the segue source view controller
        
        if sourceSegue.source.isKind(of: MyProjectEditAndCreateViewController.self) {
            let source = sourceSegue.source as! MyProjectEditAndCreateViewController
            switch identifier {
            case "projNameSegue":
                source.projNameLbl.text     = inputText
            case "comFullNameSegue":
                source.comFullNameLbl.text  = inputText
            case "contactNameSegue":
                source.contactNameLbl.text  = inputText
            case "contactPhoneSegue":
                source.contactPhoneLbl.text = inputText
            case "emailSegue":
                source.emailLbl.text        = inputText
            default: break
            }
        } else if sourceSegue.source.isKind(of: MyHomePageAddEntrepreneurshipExperienceViewController.self) {
            let source = sourceSegue.source as! MyHomePageAddEntrepreneurshipExperienceViewController
            switch identifier {
            case "MHPEEProjNameSegue":
                source.projNameLbl.text = inputText
            case "MHPEELocationSegue":
                source.locationLbl.text = inputText
            case "MHPEEBelongedSegue":
                source.belongedLbl.text = inputText
            default: break
            }
        } else if sourceSegue.source.isKind(of: MyHomePageAddWorkExperienceViewController.self) {
            let source = sourceSegue.source as! MyHomePageAddWorkExperienceViewController
            switch identifier {
            case "MHPWEComNameSegue":
                source.companyNameLbl.text = inputText
            default: break
            }
        } else if sourceSegue.source.isKind(of: MyHomePageAddEducationExperienceViewController.self) {
            let source = sourceSegue.source as! MyHomePageAddEducationExperienceViewController
            switch identifier {
            case "MHPEduEMajorSegue":
                source.majorLbl.text = inputText
            case "MHPEduESchoolSegue":
                source.schoolLbl.text = inputText
            default: break
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputTF.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitleLbl.text = navTitle
        inputTF.placeholder = inputPlaceholder
    }
    

}

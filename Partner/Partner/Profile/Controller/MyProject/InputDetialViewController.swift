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
        
        // pass data to the segue source view controller
        let source = sourceSegue?.source as! MyProjectEditAndCreateViewController
        guard let identifier = sourceSegue?.identifier else { return }
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
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitleLbl.text = navTitle
        inputTF.placeholder = inputPlaceholder
    }
    

}

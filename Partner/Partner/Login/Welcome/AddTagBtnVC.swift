//
//  AddTagBtnVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/29.
//

import UIKit

class AddTagBtnVC: UIViewController {
    var sourceSegue: UIStoryboardSegue?
    var tag  = 0
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
        if sourceSegue?.identifier == "InterestedID" {
             let source = sourceSegue?.source as! InterestedVC
            source.diyButtonText.append(inputText!)
        }else if sourceSegue?.identifier == "skilledID"{
             let source = sourceSegue?.source as! SkillViewController
             source.diyButtonText.append(inputText!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputTF.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}





//
//  AuthInputEnterpriseDescriptionViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/8.
//

import UIKit

class AuthInputEnterpriseDescriptionViewController: UIViewController, UITextViewDelegate {
    
    var segue: UIStoryboardSegue?
    
    var str: String?
    
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    
    var inputString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
        }
    }
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputTF.becomeFirstResponder()
        inputTF.text = str
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTF.text = str
        if str != nil {
            placeholderLbl.isHidden = true
        }

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTF.text
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if inputString.isEmpty {
            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
            return
        } else if Int(inputTF.text.count) > 500 {
            presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            return
        }
        
        let sourceViewController = segue?.source
        if sourceViewController is AuthApplyEnterpriseViewController {
            let source = sourceViewController as! AuthApplyEnterpriseViewController
            source.viewModel.compDesc = inputString
            source.entIntroLbl.text = "已输入"
        }
        
        
        self.navigationController?.popViewController(animated: true)

    }

}

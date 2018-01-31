//
//  CooperativedemandVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/29.
//

import UIKit

class CooperativedemandVC: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var imgHCons: NSLayoutConstraint!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    
    var feedbackString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/200"
            if charCount > 200 {
                presentHintMessage(hintMessgae: "字符不能超过200字", completion: nil)
            }
        }
    }
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if Int(inputTF.text.count) == 0 || inputTF.text.replacingOccurrences(of: " ", with: "") == "" {
            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
        } else if Int(inputTF.text.count) > 200 {
            presentHintMessage(hintMessgae: "字符不能超过200字", completion: nil)
            return
        } else {
            // TODO:- post request
            //保存身份选择
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                return
            }
            NetWorkTool.shareInstance.perfectUserRequireInfo(token: access_token, require: inputTF.text, finished: { [weak self](result, error) in
                if error == nil {
                    // MARK:- judge the return data from server
                    if  result?["code"] as? Int == 200  {
                        self?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                            self?.navigationController?.dismiss(animated: true , completion: nil)
                        })
                    } else {
                        let  errorShow  =  result!["msg"] as! String
                        self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                        
                    }
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTF.delegate = self
        setAttributes()
        
        if isIPHONE_SE { imgHCons.constant -= 50 }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputTF.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        feedbackString = inputTF.text
    }
    
    func setAttributes() {
        lineLbl.layer.borderWidth = 1
        lineLbl.layer.borderColor = #colorLiteral(red: 0.6745098233, green: 0.7921568751, blue: 0.8549019694, alpha: 1)
    }
    
    
}


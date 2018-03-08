//
//  FeedbackViewController.swift
//  Partner
//
//  Created by Weslie on 17/01/2018.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var imgHCons: NSLayoutConstraint!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    
    var feedbackString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/300"
            if charCount > 300 {
                presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
            }
        }
    }
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func contactServiceBtnClicked(_ sender: UIButton) {
        makePhoneCall(with: "36468436")
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if Int(inputTF.text.count) == 0 || inputTF.text.replacingOccurrences(of: " ", with: "") == "" {
            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
            return
        } else if Int(inputTF.text.count) > 300 {
            presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
            return
        } else {
            // TODO:- post request
            
            guard UserDefaults.standard.string(forKey: "token") != nil else {
                presentLoginController()
                return
            }
            
            NetWorkTool.shareInstance.sendFeedback(token: access_token!, feedContent: feedbackString, finished: { (result, error) in
                weak var weakSelf = self
                if error != nil {
                    weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                    print(error as AnyObject)
                    return
                }
                if result!["code"] as! Int == 200 {
                    weakSelf?.presentHintMessage(hintMessgae: "提交反馈信息成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputTF.becomeFirstResponder()
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

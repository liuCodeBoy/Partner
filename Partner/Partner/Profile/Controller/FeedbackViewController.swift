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
        } else if Int(inputTF.text.count) > 300 {
            presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
            return
        } else {
            // TODO:- post request
            
            // pop view controller
            self.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
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

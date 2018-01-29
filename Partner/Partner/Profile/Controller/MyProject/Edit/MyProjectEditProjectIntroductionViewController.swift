//
//  MyProjectEditProjectIntroductionViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class MyProjectEditProjectIntroductionViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var placeholderLbl1: UILabel!
    @IBOutlet weak var placeholderLbl2: UILabel!
    @IBOutlet weak var inputTV1: UITextView!
    @IBOutlet weak var inputTV2: UITextView!
    @IBOutlet weak var inputLimitLbl1: UILabel!
    @IBOutlet weak var inputLimitLbl2: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var introductionString: String = "" {
        didSet {
//            let charCount = Int(inputTF.text.count)
//            inputLimitLbl.text = "\(charCount)/300"
//            if charCount > 300 {
//                presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
//            }
        }
    }
    
    var highlightString: String = "" {
        didSet {
            
        }
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
//        if Int(inputTF.text.count) == 0 || inputTF.text.replacingOccurrences(of: " ", with: "") == "" {
//            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
//        } else if Int(inputTF.text.count) > 300 {
//            presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
//            return
//        } else {
//            // TODO:- post request
//
//            // pop view controller
//            self.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
//                self.navigationController?.popViewController(animated: true)
//            })
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        let dict = notification.userInfo
        let bounds = (dict?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (dict?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var deltaY = bounds.size.height
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == inputTV1 {
            placeholderLbl1.isHidden = true
        } else if textView == inputTV2 {
            placeholderLbl2.isHidden = true

        }
    }

}

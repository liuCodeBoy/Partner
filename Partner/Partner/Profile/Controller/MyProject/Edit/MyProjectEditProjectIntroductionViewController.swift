//
//  MyProjectEditProjectIntroductionViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class MyProjectEditProjectIntroductionViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var placeholderLbl1: UILabel!
    @IBOutlet weak var placeholderLbl2: UILabel!
    @IBOutlet weak var inputTV1: UITextView!
    @IBOutlet weak var inputTV2: UITextView!
    @IBOutlet weak var inputLimitLbl1: UILabel!
    @IBOutlet weak var inputLimitLbl2: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var keyboardRect: CGRect = CGRect()
    var keyboardChangeFrameAnimationDuration: Double = 0.0
    
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
        let keyboardRect = (dict?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.keyboardRect = keyboardRect
        let duration = (dict?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.keyboardChangeFrameAnimationDuration = duration

    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == inputTV1 {
            placeholderLbl1.isHidden = true
        } else if textView == inputTV2 {
            placeholderLbl2.isHidden = true
        }
        
        let coverView = UIView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight))
        coverView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.view.insertSubview(coverView, at: self.view.subviews.count)

        // FIXME:- click several times will cause offset unexpectedly
        
        if let firstResponder = (self.view.currentFirstResponder() as! UIView).superview {
            let responderConvertedFrame = scrollView.convert(firstResponder.accessibilityFrame, to: self.view)
            let keyboardConvertedFrame = self.view.window?.convert(keyboardRect, to: self.view)
            let navigationBarConvertedFrame = self.navigationController!.view.convert(self.navigationController!.navigationBar.frame, to: self.view)
            // if the input view's button side is under keyboard's top side
            let upOffset = responderConvertedFrame.origin.y + 92 - keyboardConvertedFrame!.origin.y // 92 is input view's height
            // if the input view's top side is on the upper of the big title's button side
            let downOffset = responderConvertedFrame.origin.y - (navigationBarConvertedFrame.origin.y + navigationBarConvertedFrame.size.height + 42) // 42 is big title's height
            print(responderConvertedFrame)

            if upOffset > 0 {
                let deltaY = scrollView.contentOffset.y + upOffset
                UIView.animate(withDuration: keyboardChangeFrameAnimationDuration, delay: 0, options: .curveLinear, animations: {
                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: deltaY), animated: true)
                }, completion: nil)
            }
            if downOffset < 0 {
                let deltaY = scrollView.contentOffset.y + downOffset
                UIView.animate(withDuration: keyboardChangeFrameAnimationDuration, delay: 0, options: .curveLinear, animations: {
                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: deltaY), animated: true)
                }, completion: nil)
            }
        }
    }

}

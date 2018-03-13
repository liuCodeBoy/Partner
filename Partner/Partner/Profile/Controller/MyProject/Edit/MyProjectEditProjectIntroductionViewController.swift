//
//  MyProjectEditProjectIntroductionViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class MyProjectEditProjectIntroductionViewController: UIViewController, UITextViewDelegate {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var projID: Int?
    
    @IBOutlet weak var placeholderLbl1: UILabel!
    @IBOutlet weak var placeholderLbl2: UILabel!
    @IBOutlet weak var inputTV1: UITextView!
    @IBOutlet weak var inputTV2: UITextView!
    @IBOutlet weak var inputLimitLbl1: UILabel!
    @IBOutlet weak var inputLimitLbl2: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    var keyboardRect: CGRect = CGRect()
//    var keyboardChangeFrameAnimationDuration: Double = 0.0
//    var coverView: UIView?
    
    
    var str1: String?
    var str2: String?
    
    var introductionString: String = "" {
        didSet {
            placeholderLbl1.isHidden = true
            let charCount = Int(inputTV1.text.count)
            inputLimitLbl1.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
        }
    }
    
    var highlightString: String = "" {
        didSet {
            placeholderLbl2.isHidden = true
            let charCount = Int(inputTV2.text.count)
            inputLimitLbl2.text = "\(charCount)/200"
            if charCount > 300 {
                presentHintMessage(hintMessgae: "字符不能超过200字", completion: nil)
            }
        }
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        if introductionString.isEmpty {
            presentHintMessage(hintMessgae: "项目简介不能为空", completion: nil)
        } else if highlightString.isEmpty {
            presentHintMessage(hintMessgae: "项目亮点不能为空", completion: nil)
        } else if introductionString.count > 500 || highlightString.count > 300 {
            presentHintMessage(hintMessgae: "您的字数不满足要求", completion: nil)
        } else {
            // TODO:- post request
            saveProjIntro()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:- show text from the segue source
        if str1 != nil && str2 != nil {
            inputTV1.text = str1
            inputTV2.text = str2
            introductionString = str1!
            highlightString = str2!
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == inputTV1 {
            introductionString = inputTV1.text
        } else if textView == inputTV2 {
            highlightString = inputTV2.text
        }
    }
    
    func saveProjIntro() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        
        weak var weakSelf = self
        presentConfirmationAlert(hint: "确认保存吗？", completion: { (_) in
            NetWorkTool.shareInstance.updateProjectDesc(token: access_token!, id: id, projDesc: (weakSelf?.introductionString)!, projHighlights: (weakSelf?.highlightString)!) { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save changes succeeded
                    weakSelf?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == inputTV1 {
            placeholderLbl1.isHidden = true
        } else if textView == inputTV2 {
            placeholderLbl2.isHidden = true
        }
    }
    
}

extension MyProjectEditProjectIntroductionViewController {
//    @objc func keyboardWillChangeFrame(_ notification: Notification) {
//        let dict = notification.userInfo
//        let keyboardRect = (dict?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        self.keyboardRect = keyboardRect
//        let duration = (dict?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        self.keyboardChangeFrameAnimationDuration = duration
//
//    }
//
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//
//        // scroll cover view to dismiss keyboard
//        let coverView = KeyboardBackgroundCoverView()
//        coverView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight)
//        //        coverView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        self.coverView = coverView
//        let coverViewTap = UISwipeGestureRecognizer(target: self, action: #selector(coverViewSwipeToDismissKeyboard))
//        coverViewTap.direction = .up
//        coverView.addGestureRecognizer(coverViewTap)
//        self.view.insertSubview(coverView, at: self.view.subviews.count)
//
//        // FIXME:- click several times will cause offset unexpectedly
//
//        if let firstResponder = (self.view.currentFirstResponder() as! UIView).superview {
//            let responderConvertedFrame = scrollView.convert(firstResponder.accessibilityFrame, to: self.view)
//            let keyboardConvertedFrame = self.view.window?.convert(keyboardRect, to: self.view)
//            let navigationBarConvertedFrame = self.navigationController!.view.convert(self.navigationController!.navigationBar.frame, to: self.view)
//            // if the input view's button side is under keyboard's top side
//            let upOffset = responderConvertedFrame.origin.y + 92 - keyboardConvertedFrame!.origin.y // 92 is input view's height
//            // if the input view's top side is on the upper of the big title's button side
//            let downOffset = responderConvertedFrame.origin.y - (navigationBarConvertedFrame.origin.y + navigationBarConvertedFrame.size.height + 42) // 42 is big title's height
//            print(responderConvertedFrame)
//
//            if upOffset > 0 {
//                let deltaY = scrollView.contentOffset.y + upOffset
//                UIView.animate(withDuration: keyboardChangeFrameAnimationDuration, delay: 0, options: .curveLinear, animations: {
//                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: deltaY), animated: true)
//                }, completion: nil)
//            }
//            if downOffset < 0 {
//                let deltaY = scrollView.contentOffset.y + downOffset
//                UIView.animate(withDuration: keyboardChangeFrameAnimationDuration, delay: 0, options: .curveLinear, animations: {
//                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: deltaY), animated: true)
//                }, completion: nil)
//            }
//        }
//    }
//
//    @objc func coverViewSwipeToDismissKeyboard() {
//        self.view.endEditing(true)
//        UIView.animate(withDuration: keyboardChangeFrameAnimationDuration, delay: 0, options: .curveEaseInOut, animations: {
//            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
//        }, completion: nil)
//        self.coverView?.removeFromSuperview()
//    }
}

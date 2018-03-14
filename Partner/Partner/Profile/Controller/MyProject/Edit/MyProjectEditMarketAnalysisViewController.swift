//
//  MyProjectEditMarketAnalysisViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class MyProjectEditMarketAnalysisViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var projID: Int?
    
    @IBOutlet weak var placeholderLbl1: UILabel!
    @IBOutlet weak var placeholderLbl2: UILabel!
    @IBOutlet weak var placeholderLbl3: UILabel!
    @IBOutlet weak var placeholderLbl4: UILabel!
    @IBOutlet weak var inputTV1: UITextView!
    @IBOutlet weak var inputTV2: UITextView!
    @IBOutlet weak var inputTV3: UITextView!
    @IBOutlet weak var inputTV4: UITextView!
    @IBOutlet weak var inputLimitLbl1: UILabel!
    @IBOutlet weak var inputLimitLbl2: UILabel!
    @IBOutlet weak var inputLimitLbl3: UILabel!
    @IBOutlet weak var inputLimitLbl4: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var str1: String?
    var str2: String?
    var str3: String?
    var str4: String?

    var aimUserGroupString: String = "" {
        didSet {
            placeholderLbl1.isHidden = true
            let charCount = Int(inputTV1.text.count)
            inputLimitLbl1.text = "\(charCount)/200"
            if charCount > 200 {
                presentHintMessage(hintMessgae: "字符不能超过200字", completion: nil)
            }
        }
    }
    var profitModelString: String = "" {
        didSet {
            placeholderLbl2.isHidden = true
            let charCount = Int(inputTV2.text.count)
            inputLimitLbl2.text = "\(charCount)/200"
            if charCount > 200 {
                presentHintMessage(hintMessgae: "字数不能超过200字", completion: nil)
            }
        }
    }
    var competeOponentString: String = "" {
        didSet {
            placeholderLbl3.isHidden = true
            let charCount = Int(inputTV3.text.count)
            inputLimitLbl3.text = "\(charCount)/200"
            if charCount > 200 {
                presentHintMessage(hintMessgae: "字数不能超过200字", completion: nil)
            }
        }
    }
    var advantageResourceString: String = "" {
        didSet {
            placeholderLbl4.isHidden = true
            let charCount = Int(inputTV4.text.count)
            inputLimitLbl4.text = "\(charCount)/200"
            if charCount > 200 {
                presentHintMessage(hintMessgae: "字数不能超过200字", completion: nil)
            }
        }
    }

    @IBAction func saveClicked(_ sender: UIButton) {
        if aimUserGroupString.isEmpty || profitModelString.isEmpty || competeOponentString.isEmpty || advantageResourceString.isEmpty {
            presentHintMessage(hintMessgae: "请完善所有信息后再保存", completion: nil)
        } else if aimUserGroupString.count > 200 || profitModelString.count > 200 || competeOponentString.count > 200 || advantageResourceString.count > 200 {
            presentHintMessage(hintMessgae: "您的字数不满足要求", completion: nil)
        } else {
            // TODO:- post request
            saveMarketInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK:- show text from the segue source
        if str1 != nil && str2 != nil && str3 != nil && str4 != nil {
            inputTV1.text = str1
            inputTV2.text = str2
            inputTV3.text = str3
            inputTV4.text = str4
            aimUserGroupString      = str1!
            profitModelString       = str2!
            competeOponentString    = str3!
            advantageResourceString = str4!
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case inputTV1: aimUserGroupString      = inputTV1.text
        case inputTV2: profitModelString       = inputTV2.text
        case inputTV3: competeOponentString    = inputTV3.text
        case inputTV4: advantageResourceString = inputTV4.text
        default: break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case inputTV1: placeholderLbl1.isHidden = true
        case inputTV2: placeholderLbl2.isHidden = true
        case inputTV3: placeholderLbl3.isHidden = true
        case inputTV4: placeholderLbl4.isHidden = true
        default: break
        }
    }
    
    func saveMarketInfo() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        
        weak var weakSelf = self
        presentConfirmationAlert(hint: "确认保存吗？", completion: { (_) in
            NetWorkTool.shareInstance.updateMarketAnalysis(token: access_token!,
                                                           id: id,
                                                           projUserGroup: (weakSelf?.aimUserGroupString)!,
                                                           projProfitModel: (weakSelf?.profitModelString)!,
                                                           projCompetitor: (weakSelf?.competeOponentString)!,
                                                           projResources: (weakSelf?.advantageResourceString)!)
            { (result, error) in
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
}

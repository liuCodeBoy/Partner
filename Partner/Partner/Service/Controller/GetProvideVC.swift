//
//  GetProvideVC.swift
//  Partner
//
//  Created by Weslie on 13/03/2018.
//

import UIKit
import SCLAlertView

class GetProvideVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var describLab: UILabel!
    @IBOutlet weak var typeLab: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var submitBtn: ShadowButton!
    @IBOutlet weak var phoneBtn: UIButton!
    
    var provideID : Int?
    var showTypeName : String?
    var modelArr = [ServiceProvideListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getPhoneNum()
        self.detailTextView.delegate = self
        typeLab.text = showTypeName
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.describLab.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.detailTextView.resignFirstResponder()
    }
    
    @IBAction func phoneCallAction(_ sender: Any) {
        
        let urlString = self.phoneBtn.titleLabel?.text
        makePhoneCall(with: urlString!)
    }
    
    @IBAction func dismissaction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func provideAction(_ sender: Any) {
         getProvider()
    }
    
    func  getProvider() -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        guard detailTextView.text.count < 1 else {
            SCLAlertView().showError("输入框不能为空", subTitle: "")
            return
        }
      
        NetWorkTool.shareInstance.supportCommit(token: access_token, typeId: provideID!, suppContent: detailTextView.text) {(result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data into model
                    SCLAlertView().showSuccess("", subTitle: "\(String(describing: result!["msg"]!))")
                    self.navigationController?.popViewController(animated: true)
                    
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
          }
     }
    
    func getPhoneNum(){
        NetWorkTool.shareInstance.getPhone(phoneType: 3) { (result, error) in
            weak var  weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                let  phoneStr = result!["result"]
                weakSelf?.phoneBtn.setTitle(phoneStr as? String, for: .normal)
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
}




extension  UINavigationController : UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //同时禁用系统原先的侧滑返回功能
        self.interactivePopGestureRecognizer?.delegate = self
        self.interactivePopGestureRecognizer?.isEnabled = true
    }
    
}

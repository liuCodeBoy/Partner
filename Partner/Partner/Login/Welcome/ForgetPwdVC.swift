//
//  ForgetPwdVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/25.
//

import UIKit

class ForgetPwdVC: UIViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var identifyCodetextField: UITextField!
    @IBOutlet weak var identifyingbtn: UIButton!
    //定时器方法
    fileprivate var countDownTimer: Timer?
    @IBAction func closeControllerAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            identifyingbtn.setTitle("重新发送\(newValue)秒", for: .normal)
            if newValue <= 0 {
                identifyingbtn.setTitle("发送验证码", for: .normal)
                isCounting = false
            }
        }
    }
    fileprivate var isCounting = false {
        willSet {
            if newValue {
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 60
            } else {
                countDownTimer?.invalidate()
                countDownTimer = nil
            }
            identifyingbtn.isEnabled = !newValue
        }
    }
    @objc fileprivate func updateTime() {
        remainingSeconds -= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func ensureChangeAction(_ sender: Any) {
            if phoneTextField.text == "" {
            self.presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
            return
        }else if pwdTextField.text == "" {
            self.presentHintMessage(hintMessgae: "请输入手机密码", completion: nil)
            return
        }else if identifyCodetextField.text == "" {
            self.presentHintMessage(hintMessgae: "请输入手机验证码", completion: nil)
            return
        }else if pwdTextField.text?.isValidPassword == false {
            self.presentHintMessage(hintMessgae: "密码应为6-20位字母和数字组合", completion: nil)
            return
        }
        NetWorkTool.shareInstance.forgetPwd(phone: self.phoneTextField.text!, password: self.pwdTextField.text!, code: self.identifyCodetextField.text!) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if result?["code"] as? Int == 200 {
                    self?.presentHintMessage(hintMessgae: result!["msg"] as! String, completion: { (action) in
                        self?.navigationController?.popViewController(animated: true)})
                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
        
    }

    @IBAction func sendIdentifyCodeAction(_ sender: Any) {
     
            if phoneTextField.text == "" {
                self.presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
                return
            }
            
            NetWorkTool.shareInstance.getDynamicpw(phone: self.phoneTextField.text!) { [weak self](result, error) in
                if error == nil {
                    // MARK:- judge the return data from server
                    if result?["code"] as? Int == 200 {
                        self?.presentHintMessage(hintMessgae: "验证码发送成功", completion: nil)
                        self?.phoneTextField.endEditing(true)
                        self?.isCounting = true
                    } else {
                        let  errorShow  =  result!["msg"] as! String
                        self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                        
                    }
                }
            }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.phoneTextField.resignFirstResponder()
        self.pwdTextField.resignFirstResponder()
        self.identifyCodetextField.resignFirstResponder()
  
    }
  

}

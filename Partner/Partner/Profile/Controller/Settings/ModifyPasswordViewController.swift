//
//  ModifyPasswordViewController.swift
//  Partner
//
//  Created by Weslie on 17/01/2018.
//

import UIKit

class ModifyPasswordViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var idNumTF: UITextField!
    @IBOutlet weak var sendIDNumBtn: UIButton!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    
    // define a timer
    fileprivate var countDownTimer: Timer?
    
    // send id number count down
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            sendIDNumBtn.setTitle("重新发送\(newValue)秒", for: .normal)
            if newValue <= 0 {
                sendIDNumBtn.setTitle("发送验证码", for: .normal)
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
            sendIDNumBtn.isEnabled = !newValue
        }
    }
    @objc fileprivate func updateTime() {
        remainingSeconds -= 1
    }
    
    
    @IBAction func sendIDNumClicked(_ sender: UIButton) {
        guard let phone = phoneNumTF.text else {
            presentHintMessage(hintMessgae: "请输入手机号", completion: { (_) in
                return
            })
            return
        }
        NetWorkTool.shareInstance.getDynamicpw(phone: phone) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
            }
            if result!["code"] as! Int == 200 {
                weakSelf?.presentHintMessage(hintMessgae: "验证码发送成功", completion: nil)
            } else {
                weakSelf?.presentHintMessage(hintMessgae: "\(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    @IBAction func confirmModifyBtnClicked(_ sender: UIButton) {
        guard let phone = phoneNumTF.text else {
            presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
            return
        }
        guard let idNum = idNumTF.text else {
            presentHintMessage(hintMessgae: "请输入验证码", completion: nil)
            return
        }
        guard let newPwd = newPwdTF.text, let confirmPwd = confirmPwdTF.text, newPwdTF.text != "" && confirmPwdTF.text != "" else {
            presentHintMessage(hintMessgae: "请输入新密码", completion: nil)
            return
        }
        guard newPwd == confirmPwd else {
            presentHintMessage(hintMessgae: "您两次输入的密码不一样", completion: nil)
            return
        }
        checkLoginStatus()
        // MARK:- post request
        NetWorkTool.shareInstance.changePwd(token: access_token!, phone: phone, newPwd: newPwd, code: idNum) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
            }
            if result!["code"] as! Int == 200 {
                weakSelf?.presentHintMessage(hintMessgae: "密码修改成功", completion: { (_) in
                    weakSelf?.navigationController?.popViewController(animated: true)
                })
            } else {
                weakSelf?.presentHintMessage(hintMessgae: "\(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }

}

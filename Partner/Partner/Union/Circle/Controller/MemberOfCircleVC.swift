//
//  MemberOfCircleVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit

class MemberOfCircleVC: UIViewController {
    @IBOutlet weak var circleNameText: UILabel!
    var   circleID = 0
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func reportClick(_ sender: Any) {
    }
    @IBAction func leaveCircleClick(_ sender: Any) {
        self.presentAlert(title: "确认退出", hint: "", confirmTitle: "确定", cancelTitle: "取消", confirmation: { (action) in
            self.withdrawCircle()
        }, cancel: nil)
    }
    
    
    func  withdrawCircle(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.withdrawCircle(token: access_token, id: circleID) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                self?.presentHintMessage(hintMessgae:  "退出成功", completion: { (action) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
}

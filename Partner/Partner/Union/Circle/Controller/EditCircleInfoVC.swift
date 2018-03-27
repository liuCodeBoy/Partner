//
//  EditCircleInfoVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/27.
//

    import UIKit
    
    class EditCircleInfoVC: UIViewController {
        var circlenameSegue : UIStoryboardSegue?
        var circleId   = 0
        @IBOutlet weak var editTextField: UITextField!
        @IBAction func dismissVCAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        
        
        @IBAction func submitAction(_ sender: Any) {
            guard  editTextField.text  != ""  else {
                self.presentHintMessage(hintMessgae: "修改不能为空", completion: nil)
                return
            }
            let  sourceVC = circlenameSegue?.source as! CircleManageVC
            sourceVC.circleInfoLab.text = self.editTextField.text
            
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
                return
            }
            //修改圈名称
            NetWorkTool.shareInstance.updateSocialCircle(token: access_token, circleId: circleId, type: 3, circleName: nil, image: nil, desc: editTextField.text) { [weak self](result, error) in
                if  result?["code"] as? Int == 200  {
                    guard   result != nil else{
                        return
                    }
                    self?.presentHintMessage(hintMessgae: "保存完成", completion: { (action) in
                        self?.navigationController?.popViewController(animated: true)})
                }else{
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
        
}


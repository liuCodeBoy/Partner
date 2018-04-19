//
//  SearchUserVC.swiftr
//  Partner
//
//  Created by LiuXinQiang on 2018/2/23.
//

import UIKit

class SearchUserVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var userTableView: UserSearchTableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    var   seague : UIStoryboardSegue?
    var  modelArr = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.postModelClouse = { [weak self](model)
            in
        
            let  sourceVC =  self?.seague?.source as! CreateCricleVC
            sourceVC.userModelArr.append(model)
            self?.navigationController?.popViewController(animated: true)
        }
       
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let fuzzy = (currentText as NSString).replacingCharacters(in: range, with: string)

        self.modelArr.removeAll()
        searchUser(fuzzy: fuzzy)
        return true
    }
    

    @IBAction func searchAction(_ sender: Any) {
        self.modelArr.removeAll()
        //searchUser()
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //网络请求
    func searchUser(fuzzy : String) -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
//            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        
        guard searchTextField.text != nil else {
            self.presentHintMessage(hintMessgae: "请输入需查询用户名", completion: nil)
            return
        }
        
        NetWorkTool.shareInstance.searchUserList(token: access_token, type: 1, fuzzy: fuzzy, circleId: 0) { [weak self](result, error) in
            
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                for dict in dictArr{
                    if  let statusViewModel = UserModel.mj_object(withKeyValues: dict){
                        self?.modelArr.append(statusViewModel)
                    }
                }
                 self?.userTableView.userModelArr = (self?.modelArr)!
                   
                }
                if self?.modelArr.count == 0 {
                    self?.userTableView.addPlaceholder()
                }else{
                    self?.userTableView.removePlaceholder()
                }
            }else{
              //  let  errorShow  =  result!["msg"] as! String
               
            }
        }
    }
}

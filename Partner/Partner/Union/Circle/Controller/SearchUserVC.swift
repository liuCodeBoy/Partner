//
//  SearchUserVC.swiftr
//  Partner
//
//  Created by LiuXinQiang on 2018/2/23.
//

import UIKit

class SearchUserVC: UIViewController {
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
    
    
  

    @IBAction func searchAction(_ sender: Any) {
        self.modelArr.removeAll()
        searchUser()
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //网络请求
    func searchUser() -> () {
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
        
        NetWorkTool.shareInstance.searchUserList(token: access_token, type: 1, fuzzy: searchTextField.text!, circleId: 0) { [weak self](result, error) in
            
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
                    if dictArr.count == 0 {
                     self?.presentHintMessage(hintMessgae: "未查找到数据", completion: nil)
                    }
                }
            
                
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
}

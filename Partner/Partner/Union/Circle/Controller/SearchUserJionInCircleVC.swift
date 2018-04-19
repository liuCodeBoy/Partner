//
//  SearchUserJionInCircleVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit

class SearchUserJionInCircleVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource, UITextFieldDelegate{
 
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    var   seague : UIStoryboardSegue?
    var   circleID  = 0
    var  modelArr = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
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
    }
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //网络请求
    func searchUser(fuzzy: String) -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
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
                    self?.userTableView.reloadData()
                   
                }
                
                if self?.modelArr.count == 0 {
                    self?.userTableView.addPlaceholder()
                }else{
                    self?.userTableView.removePlaceholder()
                }

            }else{
                
            }
        }
    }
}


extension SearchUserJionInCircleVC {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchBarCellID", for: indexPath) as! UserSearchBarCell
        if  modelArr.count > 0 {
            cell.viewModel = modelArr[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取出模型
        let  model = modelArr[indexPath.row]
        
        
        inviteJoin(userID: model.uid as! Int)
    }
    
    
    
    func inviteJoin(userID : Int){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.inviteJoin(token: access_token, id: circleID, userId: userID) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                self?.presentHintMessage(hintMessgae: "邀请成功", completion: { (action) in
                    self?.navigationController?.popViewController(animated: true)})
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
        
    }
    
    
}

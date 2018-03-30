//
//  CircleMemberListTableView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit
import SCLAlertView
class CircleMemberListTableView: UITableView ,UITableViewDelegate,UITableViewDataSource{
    
    var circleID : Int?
    var  userModelArr = [UserModel]() {
        didSet {
            self.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "UserSearchBarCellID", for: indexPath) as! UserSearchBarCell
        if  userModelArr.count > 0 {
            cell.viewModel = userModelArr[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //MARK: - left slide to delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: remove form data source
        if editingStyle == .delete {
            // MARK:- post request to server
            
            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
           guard let id = userModelArr[indexPath.row].uid as? Int else {
               return
            }
            
            NetWorkTool.shareInstance.memberDelete(token: access_token, circleId: circleID!, userId: id, finished: { [weak self](result, error) in
                if error != nil {
                    //print(error as AnyObject)
                } else if result?["code"] as? Int == 200 {
                     SCLAlertView().showSuccess("删除成功", subTitle: "")
                    self?.userModelArr.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                       let  errorShow  =  result!["msg"] as! String
                    SCLAlertView().showError(errorShow, subTitle: "")
                }
            })
            
          
           
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取出模型
        let  model = userModelArr[indexPath.row]
     
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate   = self
        self.dataSource = self
    }
}

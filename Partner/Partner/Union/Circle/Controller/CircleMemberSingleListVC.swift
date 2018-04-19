//
//  CircleMemberSingleListVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/4/19.
//

import UIKit

class CircleMemberSingleListVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var circleMemberTableView: UITableView!
    var circleMemberSegue : UIStoryboardSegue?
    var circleId   = 0
    var  modelArr = [UserModel]()
    var  watingJionInArr = [UserModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.circleMemberTableView.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "UserListCellID")
       
       // circleMemberTableView.circleID = self.circleId
        getCircleMemberListFunc()
    }
    // 获取用户列表
    func getCircleMemberListFunc(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.getCircleMemberList(token: access_token, id: circleId) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictResult = result!["result"] as? [NSDictionary]{
                for dict in dictResult{
                    if  let statusViewModel = UserModel.mj_object(withKeyValues: dict){
                     self?.modelArr.append(statusViewModel)
                      }
                    }
                self?.circleMemberTableView.reloadData()
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCellID") as! UserListCell
        if  self.modelArr.count > 0 {
            let model = self.modelArr[indexPath.row]
            cell.viewModel = model
     }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

class UserListCell : UITableViewCell{
    @IBOutlet weak var imageHeaderView: UIImageView!
    @IBOutlet weak var userIndentifyBtn: UIButton!
    @IBOutlet weak var nameTextLab: UILabel!
    @IBOutlet weak var communityLab: UILabel!
    
    var  indexRowNum : NSNumber?
    
    var viewModel: UserModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let create  = viewModel.create{
                if create == 1 {
                    self.userIndentifyBtn.setTitle("管理员", for: .normal)
                    self.userIndentifyBtn.setTitleColor(#colorLiteral(red: 0.6219195724, green: 0.7407949567, blue: 0.8080993295, alpha: 1), for: .normal)
                }else{
                    self.userIndentifyBtn.setTitle("", for: .normal)
                }

            }
            if let name = viewModel.userName{
                self.nameTextLab.text = name
            }
            
            if let userComm  = viewModel.userComm{
                self.communityLab.text = userComm

            }
            if let  imageUrl =  viewModel.userImgUrl {
                self.imageHeaderView.setImageWith(URL.init(string: imageUrl)!, placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            }
        }
    }
}

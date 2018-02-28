//
//  CircleMemberListVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit

class CircleMemberListVC: UIViewController {
    var circleMemberSegue : UIStoryboardSegue?
    @IBOutlet weak var circleMemberBtn: ShadowButton!
    @IBOutlet weak var watingJionInBtn: ShadowButton!
    @IBOutlet weak var tableScrollView: UIScrollView!
    var circleId   = 0
    var  modelArr = [UserModel]()
    var  watingJionInArr = [UserModel]()
    @IBOutlet weak var CircleWatingJoinInListTableView: CircleWatingJoinInListTableView!
    @IBOutlet weak var circleMemberTableView: CircleMemberListTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getCircleMemberListFunc()
    }
    
    
    // 获取用户列表
    func getCircleMemberListFunc(){
         guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        //修改圈名称
        NetWorkTool.shareInstance.getCircleMemberList(token: access_token, id: circleId) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictResult =   result!["result"] as? NSDictionary{
                    if let passUsersdictArr = dictResult["passUsers"] as? [NSDictionary]{
                        for dict in passUsersdictArr{
                            if  let statusViewModel = UserModel.mj_object(withKeyValues: dict){
                                self?.modelArr.append(statusViewModel)
                        }
                    }
                    self?.circleMemberTableView.userModelArr = (self?.modelArr)!
                  }
                   if let otherUsersdictArr = dictResult["otherUsers"] as? [NSDictionary]{
                        for dict in otherUsersdictArr{
                        if  let statusViewModel = UserModel.mj_object(withKeyValues: dict){
                          self?.watingJionInArr.append(statusViewModel)
                            }
                        }
                    self?.CircleWatingJoinInListTableView.userModelArr = (self?.watingJionInArr)!
//                    if passUsersdictArr.count == 0 {
//                            self?.presentHintMessage(hintMessgae: "未查找到数据", completion: nil)
//                   }
                   }
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    
    
    
    
    @IBAction func circleMemberClick(_ sender: UIButton) {
        circleMemberBtn.setSelected()
        watingJionInBtn.reverseSelected()
        UIView.animate(withDuration: 0.5) {
            weak var weakself = self
            weakself?.tableScrollView.contentOffset.x = 0
        }
    }
    
    @IBAction func watingJionInClick(_ sender: UIButton) {
        watingJionInBtn.setSelected()
        circleMemberBtn.reverseSelected()
        UIView.animate(withDuration: 0.5) {
            weak var weakself = self
            weakself?.tableScrollView.contentOffset.x = screenWidth
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SearchUserJionInCircleVC
        destVC.circleID = circleId
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

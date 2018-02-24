//
//  CircleManageVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/24.
//

import UIKit

class CircleManageVC: UIViewController {
    var  circleDetailSeague : UIStoryboardSegue?
    @IBOutlet weak var circleImageView: UIImageView!
    @IBOutlet weak var numberText: UILabel!
    @IBOutlet weak var CircleNameText: UILabel!
    @IBAction func dismissSelfVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailInfoVC()
    }
    
    
    func loadDetailInfoVC() -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        let  sourceVC = circleDetailSeague?.source as! CircleDetailVC
        NetWorkTool.shareInstance.getCircleSetInfo(token: access_token, id: sourceVC.circleId) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dict  =   result!["result"] as? NSDictionary{
                if  let detailModel = CircleSettingInfoModel.mj_object(withKeyValues: dict){
                   self?.circleImageView.sd_setImage(with: URL.init(string: detailModel.imgUrl!), placeholderImage:nil)
                  
                    
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
 }
}

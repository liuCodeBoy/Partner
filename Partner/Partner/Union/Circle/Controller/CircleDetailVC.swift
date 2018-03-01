//
//  CircleDetailVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/23.
//

import UIKit
import SDWebImage
class CircleDetailVC: UIViewController {
    @IBOutlet weak var firstImg: RoundRectImage!
    @IBOutlet weak var secondImg: RoundRectImage!
    @IBOutlet weak var thirdImg: RoundRectImage!
    var   circleId : Int = 0
    var   create   : Int = 0
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var CircleDetImag: UIImageView!
    @IBOutlet weak var detailTableview: DetailInfoTableView!
    @IBOutlet weak var detailHCons: NSLayoutConstraint!
    @IBOutlet weak var commandView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        getCircleDetInfo()
        //添加子控
        addchildVC()
        //设置设置按钮的切换
        changeBtnType()
    }
    
    //添加子控
    func addchildVC(){
        let circledetailCommandVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleDetailCommandVCID")
        circledetailCommandVC.view.frame = CGRect.init(x: 0, y: 0, width: commandView.frame.width, height: commandView.frame.height)
        self.addChildViewController(circledetailCommandVC)
        commandView.addSubview(circledetailCommandVC.view)
    }

    //设置设置按钮的切换
    func changeBtnType(){
        if create == 1 {
         settingBtn.isHidden = false
         reportBtn.isHidden = true
        }else {
         settingBtn.isHidden = true
         reportBtn.isHidden = false
        }
    }
    
    // 网络请求圈详情数据
    func  getCircleDetInfo(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        NetWorkTool.shareInstance.getCircleDetailInfo(token: access_token, id: circleId) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                        return
                    }
                    if  let dict  =   result!["result"] as? NSDictionary{
                    if  let statusViewModel = CicrleDetailModel.mj_object(withKeyValues: dict){
                        self?.detailTableview.topDetailModel = statusViewModel
                        if statusViewModel.status == 2 {
                            self?.detailHCons.constant = 0
                        }
                        self?.detailTableview.reloadData()
                        self?.CircleDetImag.sd_setImage(with: URL.init(string: statusViewModel.imgUrl!), placeholderImage:nil)
                        if let imageStrArr = statusViewModel.membImgUrls{
                            for i  in 0..<imageStrArr.count {
                                switch i {
                                case 0:
                                    self?.firstImg.sd_setImage(with: URL.init(string: imageStrArr[0]), placeholderImage: nil)
                                    self?.firstImg.isHidden = false
                                    self?.secondImg.isHidden = true
                                    self?.thirdImg.isHidden = true
                                case 1:
                                    self?.secondImg.sd_setImage(with: URL.init(string: imageStrArr[1]), placeholderImage: nil)
                                    self?.secondImg.isHidden = false
                                    self?.firstImg.isHidden = false
                                    self?.thirdImg.isHidden = true
                                case 2:
                                    self?.thirdImg.sd_setImage(with: URL.init(string: imageStrArr[2]), placeholderImage: nil)
                                    self?.firstImg.isHidden = false
                                    self?.secondImg.isHidden = false
                                    self?.thirdImg.isHidden = false
                                default: break
                                    
                            }
                          }
                        }
                      }
                    }
                    
                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
        
    }

    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CircleManageVCID" {
            let  destVC = segue.destination as! CircleManageVC
            destVC.circleDetailSeague = segue
        }else if segue.identifier == "MemberOfCircleVCID" {
            let  destVC = segue.destination as! MemberOfCircleVC
            destVC.circleID = circleId
             //destVC.circleDetailSeague = segue
        }

    }
    
    @IBAction func reportAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "请选择操作类型", preferredStyle: .actionSheet)
        let report = UIAlertAction(title: "举报", style: .destructive) { [weak  self](_) in
             let circleReportVc  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleReportVCID") as! CircleReportVC
            circleReportVc.reportType = 3
            circleReportVc.circleId = (self?.circleId)!
            self?.navigationController?.pushViewController(circleReportVc, animated: true)
            
        }
        let leave = UIAlertAction(title: "退出圈子", style: .destructive) { [weak self](_) in
            self?.leaveCircle()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(report)
        if  create != 2 {
            alert.addAction(leave)
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
     //MARK: - 退出圈子
    //CircleReportVCID
    
   
    func leaveCircle(){
        self.presentAlert(title: "确认退出", hint: "", confirmTitle: "确定", cancelTitle: "取消", confirmation: { (action) in
            self.withdrawCircle()
        }, cancel: nil)
    }
    
    
    func  withdrawCircle(){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.withdrawCircle(token: access_token, id: circleId) { [weak self](result, error) in
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

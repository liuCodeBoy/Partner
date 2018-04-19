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
        
        //设置设置按钮的切换
        changeBtnType()
        addPushBtn()
    }
    
    //添加子控
    func addchildVC(){
        let circledetailCommandVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleDetailCommandVCID") as!  CircleDetailCommandVC
        circledetailCommandVC.circleId = circleId
        circledetailCommandVC.view.frame = CGRect.init(x: 0, y: 0, width: commandView.frame.width, height: commandView.frame.height)
        self.addChildViewController(circledetailCommandVC)
        commandView.addSubview(circledetailCommandVC.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.childViewControllers.count == 0{
            //添加子控
            addchildVC()
        }else{
            let vc = self.childViewControllers.first as! CircleDetailCommandVC
            detailTableview.reloadData()
            vc.refresh()
        }
       
    }
    
    @IBAction func userdetailPushAction(_ sender: Any) {
        if create == 1 {
            let destVC = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleMemberListVCID") as! CircleMemberListVC
            destVC.circleId = circleId
            self.navigationController?.pushViewController(destVC, animated: true)
        }else if create == 0{
            let destVC = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleMemberSingleListVCID") as! CircleMemberSingleListVC
           destVC.circleId = circleId
            self.navigationController?.pushViewController(destVC, animated: true)
        }
      
    }
    
    //添加发布按钮
    func   addPushBtn(){

        if  create != 2 {
            let  btn = UIButton.init(frame: CGRect.init(x: screenWidth - 58 , y: screenHeight  - (self.tabBarController?.tabBar.frame.height)! - 76, width: 46, height: 46))
            btn.addTarget(self, action: #selector(pushSendOutVC), for: .touchUpInside)
            btn.setImage(UIImage.init(named: "pushBtn"), for: .normal)
            self.view.addSubview(btn)
        }
    }
    
    @objc func pushSendOutVC(){
        let statusPushVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "StatusPushVCID") as!  StatusPushVC
        statusPushVC.circleViewisHidden = true
        statusPushVC.circleName = detailTableview.topDetailModel?.circleName
        statusPushVC.circleId = detailTableview.topDetailModel?.circleId as? Int
        self.navigationController?.pushViewController(statusPushVC, animated: true)
    }

    //设置按钮的切换
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
                         }
                        self?.detailTableview.reloadData()
                        self?.CircleDetImag.sd_setImage(with: URL.init(string: statusViewModel.imgUrl!), placeholderImage:nil)
                        if let imageStrArr = statusViewModel.membImgUrls{
                            for i  in 0..<imageStrArr.count {
                                switch i {
                                case 0:
                                    self?.firstImg.sd_setImage(with: URL.init(string: imageStrArr[0]), placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    self?.firstImg.isHidden = false
                                    self?.secondImg.isHidden = true
                                    self?.thirdImg.isHidden = true
                                case 1:
                                    self?.secondImg.sd_setImage(with: URL.init(string: imageStrArr[1]), placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
                                    self?.secondImg.isHidden = false
                                    self?.firstImg.isHidden = false
                                    self?.thirdImg.isHidden = true
                                case 2:
                                    self?.thirdImg.sd_setImage(with: URL.init(string: imageStrArr[2]), placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
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
                     NotificationCenter.default.post(name: NSNotification.Name.init("Refresh"), object: nil)
                    self?.navigationController?.popViewController(animated: true)
                })
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    

    
    
}

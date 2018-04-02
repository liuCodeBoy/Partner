//
//  NoticeListViewController.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/28.
//

import UIKit
import SDWebImage
import JXPhotoBrowser
import MJRefresh
import NVActivityIndicatorView
class NoticeListViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    //初始化pageNums
    var   pageNum  = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    var  type : Int?
    @IBOutlet weak var noticeTableView: UITableView!
    @IBOutlet weak var topTitleLab: UIButton!
    var  modelArr = [NoticeSocialConnListModel]()
    var  statusViewModelArr = StatusViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        noticeTableView.delegate = self
        noticeTableView.dataSource = self
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(AppDelegate.activityData)
        loadRefreshComponet(tableView: noticeTableView)
        
        if type == 0 {
           loadNotice()
            topTitleLab.setTitle("社联通知", for: .normal)
        }else if type == 1{
            loadServiceNotice()
            topTitleLab.setTitle("服务动态消息", for: .normal)
        }else if type  == 2 {
            topTitleLab.setTitle("合伙人小助手", for: .normal)
            loadHelperNotice()
        }
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    fileprivate   func loadNotice() {
        if  self.nextPage == 0 {
            self.noticeTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.getNoticeSocialConnList(token: access_token, pageNum: pageNum) { [weak self](result, error) in
            if error != nil {
                return }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if  result?["code"] as? Int == 200  {
                guard let resultArray = result else{
                    return
                }
                self?.noticeTableView.mj_header.endRefreshing()
                let dict  =   resultArray["result"] as? NSDictionary
                if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
                {
                    self?.statusViewModelArr =  statusViewModel
                    if self?.statusViewModelArr.nextPage == 0 {
                        self?.nextPage = 0
                    }else{
                        self?.nextPage = self?.statusViewModelArr.nextPage as! Int
                    }
                    self?.pageNum += 1
                }
                
                if  let listDict = dict!["list"] as? [NSDictionary]  {
                    for dict in listDict{
                        let model =  NoticeSocialConnListModel.mj_object(withKeyValues: dict)
                        self?.modelArr.append(model!)
                    }
                    self?.noticeTableView.mj_footer.endRefreshing()
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self?.noticeTableView.reloadData()
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    
    fileprivate  func loadServiceNotice() {
        if  self.nextPage == 0 {
            self.noticeTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.getSeriviceList(token: access_token, pageNum: pageNum) { [weak self](result, error) in
            if error != nil {
                return }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if  result?["code"] as? Int == 200  {
                guard let resultArray = result else{
                    return
                }
                self?.noticeTableView.mj_header.endRefreshing()
                let dict  =   resultArray["result"] as? NSDictionary
                if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
                {
                    self?.statusViewModelArr =  statusViewModel
                    if self?.statusViewModelArr.nextPage == 0 {
                        self?.nextPage = 0
                    }else{
                        self?.nextPage = self?.statusViewModelArr.nextPage as! Int
                    }
                    self?.pageNum += 1
                }
                
                if  let listDict = dict!["list"] as? [NSDictionary]  {
                    for dict in listDict{
                        let model =  NoticeSocialConnListModel.mj_object(withKeyValues: dict)
                        self?.modelArr.append(model!)
                    }
                    self?.noticeTableView.mj_footer.endRefreshing()
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self?.noticeTableView.reloadData()
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    //小助手通知列表（notice/api/helper/list）
    fileprivate  func loadHelperNotice() {
        if  self.nextPage == 0 {
            self.noticeTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.gethelperList(token: access_token, pageNum: pageNum) { [weak self](result, error) in
            if error != nil {
                return }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if  result?["code"] as? Int == 200  {
                guard let resultArray = result else{
                    return
                }
                self?.noticeTableView.mj_header.endRefreshing()
                let dict  =   resultArray["result"] as? NSDictionary
                if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
                {
                    self?.statusViewModelArr =  statusViewModel
                    if self?.statusViewModelArr.nextPage == 0 {
                        self?.nextPage = 0
                    }else{
                        self?.nextPage = self?.statusViewModelArr.nextPage as! Int
                    }
                    self?.pageNum += 1
                }
                
                if  let listDict = dict!["list"] as? [NSDictionary]  {
                    for dict in listDict{
                        let model =  NoticeSocialConnListModel.mj_object(withKeyValues: dict)
                        self?.modelArr.append(model!)
                    }
                    self?.noticeTableView.mj_footer.endRefreshing()
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self?.noticeTableView.reloadData()
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    
    @IBAction func deleteAllNotice(_ sender: Any) {
        self.presentAlert(title: "确认删除", hint: "", confirmTitle: "确定", cancelTitle: "取消", confirmation: { [weak self](action) in
            self?.deleteAll()
        }, cancel: nil)
        
    }
    
    
    func deleteAll() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
      
        
        var noticeType = 0
        if type == 0 {
            noticeType = 2
        }else if type == 1{
            noticeType = 1
        }else if type  == 2 {
            noticeType = 4
        }
        
        NetWorkTool.shareInstance.apiClear(token: access_token, type: noticeType) { [weak self](result, error) in
            if error != nil {
                //print(error as AnyObject)
            } else if result?["code"] as? Int == 200 {
                self?.presentHintMessage(hintMessgae: "删除成功", completion: nil)
                self?.modelArr.removeAll()
                self?.noticeTableView.reloadData()
            } else {
                //print("post request failed with exit code \(result!["code"] as! String)")
            }
        }
        
        

    }
}


extension NoticeListViewController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 0 {
            if modelArr.count > 0 {
                let model = modelArr[indexPath.row]
                if model.momentId != nil{
                    let destVC = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "DynamicDetailVCID") as! DynamicDetailVC
                    destVC.momentId = model.momentId as? Int
                    self.navigationController?.pushViewController(destVC, animated: true)
                }else if model.circleId != nil {
                    let destVC = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleDetailVCID") as! CircleDetailVC
                    destVC.circleId = (model.circleId as? Int)!
                    self.navigationController?.pushViewController(destVC, animated: true)
                    
                }
//                destVC.projID = model.projectId as? Int
//                self.navigationController?.pushViewController(destVC, animated: true)
            }
      
        }else if type == 1{
            let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
            if modelArr.count > 0 {
                let model = modelArr[indexPath.row]
                destVC.projID = model.projectId as? Int
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }else if type  == 2 {
            let destVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthApplyUploadViewControllerID") as!  AuthApplyUploadViewController
                self.navigationController?.pushViewController(destVC, animated: true)
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell.init()
        if type == 0 {
           let  tempCell = tableView.dequeueReusableCell(withIdentifier: "NoticeSocialConnListCellID", for: indexPath) as! NoticeSocialConnListCell
            if  modelArr.count > 0 {
            tempCell.viewModel = modelArr[indexPath.row]
            }
            cell = tempCell
        }else {
              let  tempCell = tableView.dequeueReusableCell(withIdentifier: "ServiceListCellID", for: indexPath) as! ServiceListCell
            if type == 2 {
                tempCell.imageHeaderView?.image = #imageLiteral(resourceName: "noticeFile")
            }
            if  modelArr.count > 0 {
                tempCell.viewModel = modelArr[indexPath.row]
            }
           cell = tempCell
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
            guard let id = modelArr[indexPath.row].noticeId as? Int else {
                return
            }
            
            var noticeType = 0
            if type == 0 {
                noticeType = 2
            }else if type == 1{
                noticeType = 1
            }else if type  == 2 {
                noticeType = 4
            }
          
            NetWorkTool.shareInstance.apiDelete(token: access_token, type: noticeType, id: id, finished: { [weak self](result, error) in
                if error != nil {
                    //print(error as AnyObject)
                } else if result?["code"] as? Int == 200 {
                    self?.presentHintMessage(hintMessgae: "删除成功", completion: nil)
                } else {
                    //print("post request failed with exit code \(result!["code"] as! String)")
                }
            })
            
            modelArr.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}


//初始化加载控件
extension  NoticeListViewController {
    func loadRefreshComponet(tableView : UITableView) -> () {
        //默认下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    
    @objc func refresh() -> () {
        self.pageNum = 1
        self.nextPage = 1
        self.modelArr.removeAll()
        if type == 0 {
            loadNotice()
        }else if type == 1{
            loadServiceNotice()
        }else if type  == 2 {
            loadHelperNotice()
        }
    }
    @objc func  endrefresh() -> (){
        if type == 0 {
            loadNotice()
        }else if type == 1{
            loadServiceNotice()
        }else if type  == 2 {
            loadHelperNotice()
        }
    }
    
}

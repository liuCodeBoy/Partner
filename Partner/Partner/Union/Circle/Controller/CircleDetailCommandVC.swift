//
//  CircleDetailCommandVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/27.
//

import UIKit
import SDWebImage
import JXPhotoBrowser
import MJRefresh
import NVActivityIndicatorView
class CircleDetailCommandVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,PhotoBrowserDelegate {
    @IBOutlet weak var statusTableview: UITableView!
    var  modelView =  [UnionListModel]()
    var  statusViewModelArr = StatusViewModel()
    var   browser : PhotoBrowser?
    var   picStrsArr : [String]?
    var   collectionView : UICollectionView?
    var   circleId : Int = 0

    //初始化pageNums
    var   pageNum  = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTableview.rowHeight = UITableViewAutomaticDimension
        statusTableview.estimatedRowHeight = 200
        statusTableview.separatorStyle = .none
        //加载动画
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(AppDelegate.activityData)
        loadRefreshComponet(tableView: statusTableview)
        loadStatuses()
        //添加按钮
       // self.addPushBtn()
    }
    
    
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
        self.modelView.removeAll()
        loadStatuses()
        //          momentTableView.mj_header.endRefreshing()
    }
    @objc func  endrefresh() -> (){
        loadStatuses()
    }
    
    
    
    
    //生成照片控制器
    func addPictrueVC(){
        // 创建实例，传入present发起者，和delegate实现者
        browser = PhotoBrowser(showByViewController: self, delegate: self as PhotoBrowserDelegate)
        browser?.pageControlDelegate = PhotoBrowserNumberPageControlDelegate(numberOfPages: (self.picStrsArr?.count)!)
    }
    
    // 作为delegate必须实现的协议方法
    /// 图片总数
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return (picStrsArr?.count)!
    }
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
    }
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        let cell = collectionView?.cellForItem(at: IndexPath(item: index, section: 0)) as?  PicCollectionViewCell
        // 取thumbnailImage
        return cell?.pictureCellView.image
    }
    
    
}



extension CircleDetailCommandVC {
    fileprivate   func loadStatuses() {
        if  self.nextPage == 0 {
            self.statusTableview.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        NetWorkTool.shareInstance.getCircleMomentList(token: access_token, type: circleId , pageNum: pageNum) { [weak self](result, error) in
            if error != nil {
                return }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if  result?["code"] as? Int == 200  {
                guard let resultArray = result else{
                    return
                }
                self?.statusTableview.mj_header.endRefreshing()
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
                        let model =  UnionListModel.mj_object(withKeyValues: dict)
                        self?.modelView.append(model!)
                    }
                    self?.statusTableview.mj_footer.endRefreshing()
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self?.statusTableview.reloadData()
                }
                self?.cacheImages((self?.modelView)!)
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    fileprivate func cacheImages(_ viewModels: [UnionListModel]) {
        let group = DispatchGroup()
        for viewModel in viewModels {
            if let urls = viewModel.imgUrls {
                for picStr in urls {
                    group.enter()
                    let picURL = URL(string: picStr as String)
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                        group.leave()
                    })
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.statusTableview.reloadData()
        }
        
    }
}





extension  CircleDetailCommandVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CircleListMomentCellID") as!  CircleListMomentCell
        cell.showVCClouse = {(momentId) in
            //DynamicDetailVCID
            let dynamicDetailVC  = AppDelegate.dynamicDetailVC
            dynamicDetailVC.momentId = momentId
            dynamicDetailVC.refresh()
            
            self.navigationController?.pushViewController(dynamicDetailVC, animated: true)
        }
        if  modelView.count > 0  {
            cell.viewModel = modelView[indexPath.row]
            
        }
        
        // 显示，并指定打开第几张图
        cell.pictureView.pushImageClouse = {[weak self](tempPictureView ,index , strArr) in
            self?.picStrsArr  =  strArr
            self?.addPictrueVC()
            self?.collectionView = tempPictureView
            self?.browser?.show(index: index.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dynamicDetailVC  = AppDelegate.dynamicDetailVC
        if  modelView.count > 0  {
            let viewModel = modelView[indexPath.row]
            dynamicDetailVC.momentId = viewModel.momentId as? Int
            dynamicDetailVC.inputTF.resignFirstResponder()
            dynamicDetailVC.refresh()
            self.navigationController?.pushViewController(dynamicDetailVC, animated: true)
        }
        
    }
    
}

//
//  MyHomePageBasicInfomationContainerViewController.swift
//  Partner
//
//  Created by Weslie on 07/02/2018.
//

import UIKit
import SDWebImage
import JXPhotoBrowser
import MJRefresh
import NVActivityIndicatorView

class ServiceInvestorBasicInfomationContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,PhotoBrowserDelegate {
    
    var segue: UIStoryboardSegue?
    var modelView: ProfileInfoModel?
    var id : Int?
    //
    var modelArr =  [UnionListModel]()
    var statusViewModelArr = StatusViewModel()
    var browser : PhotoBrowser?
    var picStrsArr : [String]?
    var collectionView : UICollectionView?
    var userid : Int = 0
    //初始化pageNums
    var   pageNum  = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    //
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
        NetWorkTool.shareInstance.getUserHomePageInfo(token: access_token!, userId: id!) { [weak self](result, error) in
            if error != nil {
                self?.presentConfirmationAlert(hint: "\(String(describing: error))", completion: nil)
            }
            if result!["code"] as! Int == 200 {
                self?.modelView = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
                self?.loadStatuses()
                self?.tableView.reloadData()
            } else {
                self?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!)))", completion: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        loadRefreshComponet(tableView: tableView)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func loadRefreshComponet(tableView : UITableView) -> () {
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
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
    
    
    
    // MARK:- down swipe to zoom the header image
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        
        guard segue != nil else { return }
        
        let source = segue?.source as! ServiceInvestorProfileViewController
        if point.y < 0 {
            // down swipe
            source.headerImgHCons.constant = -point.y + 160
            source.headerInfoTopCons.constant = -point.y + 100
            if isIPHONEX {
                source.headerImgHCons.constant += 24
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageBasicInfomationTableViewCell") as! MyHomePageBasicInfomationTableViewCell
            singleCell.viewModel = modelView
            cell = singleCell
        case 1:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageAllMomentsTableViewSectionHeaderCell") as! MyHomePageAllMomentsTableViewSectionHeaderCell
            cell = singleCell
        default:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "CircleListMomentCellID") as!  CircleListMomentCell
            singleCell.showVCClouse = {(momentId) in
                //DynamicDetailVCID
                let dynamicDetailVC  = AppDelegate.dynamicDetailVC
                dynamicDetailVC.momentId = momentId
                dynamicDetailVC.refresh()
                
                self.navigationController?.pushViewController(dynamicDetailVC, animated: true)
            }
            if  modelArr.count > 0  {
                singleCell.viewModel = modelArr[indexPath.row - 2]
                
            }
            // 显示，并指定打开第几张图
            singleCell.pictureView.pushImageClouse = {[weak self](tempPictureView ,index , strArr) in
                self?.picStrsArr  =  strArr
                self?.addPictrueVC()
                self?.collectionView = tempPictureView
                self?.browser?.show(index: index.row)
            }
            cell = singleCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dynamicDetailVC  = AppDelegate.dynamicDetailVC
        if  modelArr.count > 0  {
            let viewModel = modelArr[indexPath.row - 2]
            dynamicDetailVC.momentId = viewModel.momentId as? Int
            dynamicDetailVC.refresh()
            self.navigationController?.pushViewController(dynamicDetailVC, animated: true)
        }
        
    }
    
}


extension ServiceInvestorBasicInfomationContainerViewController {
    fileprivate   func loadStatuses() {
        if  self.nextPage == 0 {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
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
        guard self.modelView?.uid != nil else {
            return
        }
        
        NetWorkTool.shareInstance.getUserHomePageMomentList(token: access_token, userId: self.id! , pageNum: pageNum) { [weak self](result, error) in
            if error != nil {
                return }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if  result?["code"] as? Int == 200  {
                guard let resultArray = result else{
                    return
                }
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
                        model?.userImgUrl = (self?.modelView?.userImgUrl! as! NSString)
                        model?.userName = self?.modelView?.userName
                        self?.modelArr.append(model!)
                    }
                    self?.tableView.mj_footer.endRefreshing()
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self?.tableView.reloadData()
                }
                self?.cacheImages((self?.modelArr)!)
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
            self.tableView.reloadData()
        }
        
    }
}



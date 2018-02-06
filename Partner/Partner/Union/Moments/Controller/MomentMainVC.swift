//
//  MomentMainVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit
import SDWebImage
import JXPhotoBrowser
import MJRefresh
class MomentMainVC: UIViewController , UITableViewDelegate, UITableViewDataSource ,PhotoBrowserDelegate {
    @IBOutlet weak var momentTableView: UITableView!
    var  modelView =  [UnionListModel]()
    var  statusViewModelArr = StatusViewModel()
    var   browser : PhotoBrowser?
    var   picStrsArr : [String]?
    var   collectionView : UICollectionView?
    //初始化pageNums
    var   pageNum  = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        momentTableView.rowHeight = UITableViewAutomaticDimension
        momentTableView.estimatedRowHeight = 200
        momentTableView.separatorStyle = .none
        loadRefreshComponet(tableView: momentTableView)
        
        loadStatuses()
        
        //添加按钮
        self.addPushBtn()
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
        /// 高清图
        func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
            return URL(string: picStrsArr![index])
        }
}


//初始化加载控件
extension  MomentMainVC {
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
          self.modelView.removeAll()
          loadStatuses()
          momentTableView.mj_header.endRefreshing()
    }
    @objc func  endrefresh() -> (){
          loadStatuses()
    }
    
}





extension MomentMainVC {
    fileprivate func loadStatuses() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        
        NetWorkTool.shareInstance.getSocialCircleMomentList(token: access_token, type: 1, pageNum: pageNum) { [weak self](result, error) in
            if error != nil {
                return }
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
            
            if self?.nextPage == 0 {
                 self?.momentTableView.mj_footer.endRefreshingWithNoMoreData()
            }
            
        
            if  let listDict = dict!["list"] as? [NSDictionary]  {
                for dict in listDict{
                    let model =  UnionListModel.mj_object(withKeyValues: dict)
                    self?.modelView.append(model!)
                    self?.momentTableView.mj_footer.endRefreshing()
                    self?.momentTableView.reloadData()
                }
            }
            self?.cacheImages((self?.modelView)!)
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
            self.momentTableView.reloadData()
        }
        
    }
}

extension MomentMainVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelView.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusViewCell") as!  StatusViewCell
         cell.viewModel = modelView[indexPath.row]
        
        // 显示，并指定打开第几张图
        cell.pictureView.pushImageClouse = {[weak self](tempPictureView ,index , strArr) in
            self?.picStrsArr  =  strArr
            self?.addPictrueVC()
            self?.collectionView = tempPictureView
            self?.browser?.show(index: index.row)
        }
        return cell
    }

}


extension  MomentMainVC{
//添加发布按钮
func   addPushBtn(){
    let  btn = UIButton.init(frame: CGRect.init(x: screenWidth - 58 , y: screenHeight - 180 , width: 46, height: 46))
    btn.addTarget(self, action: #selector(pushSendOutVC), for: .touchUpInside)
    btn.setImage(UIImage.init(named: "pushBtn"), for: .normal)
    self.view.addSubview(btn)
    
}
    
    @objc func pushSendOutVC(){
        
        let StatusPushVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "StatusPushVCID")
        self.navigationController?.pushViewController(StatusPushVC, animated: true)
    }

}








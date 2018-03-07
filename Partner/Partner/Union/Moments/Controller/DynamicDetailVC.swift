//
//  DynamicDetailVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/5.

import UIKit
import SDWebImage
import JXPhotoBrowser
import MJRefresh
import NVActivityIndicatorView
class DynamicDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,PhotoBrowserDelegate {
    @IBOutlet weak var statusTableview: UITableView!
    var  modelView =  [UnionListModel]()
    var  statusViewModelArr = StatusViewModel()
    var  commentTotalArr = [[CommentListModel]]()
    var   browser : PhotoBrowser?
    var   picStrsArr : [String]?
    var   collectionView : UICollectionView?
    var   momentId : Int?
    var   tableRowNumArr = [Int]()
    var   btnStaustsArr = [CommandFooterStatusModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTableview.rowHeight = UITableViewAutomaticDimension
        statusTableview.estimatedRowHeight = 200
        statusTableview.separatorStyle = .none
        //加载动画
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(AppDelegate.activityData)
        loadRefreshComponet(tableView: statusTableview)
        loadStatuses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadRefreshComponet(tableView : UITableView) -> () {
        //默认下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    
    @objc func refresh() -> () {
        self.modelView.removeAll()
        self.commentTotalArr.removeAll()
        loadStatuses()
        //momentTableView.mj_header.endRefreshing()
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



extension DynamicDetailVC {
    fileprivate   func loadStatuses() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        
        NetWorkTool.shareInstance.momentDetail(token: access_token, id: momentId!) {[weak self](result, error) in
            if error != nil {
                return }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            if  result?["code"] as? Int == 200  {
                
                guard let resultArray = result else{
                    return
                }
                
                self?.statusTableview.mj_header.endRefreshing()
                if let dict  =   resultArray["result"] as? NSDictionary  {
                    let model =  UnionListModel.mj_object(withKeyValues: dict)
                    self?.modelView.append(model!)
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    if model?.comments == nil {
                        self?.presentHintMessage(hintMessgae: "评论暂时为空", completion: nil)
                    }else{
                        var  dynamicCommListArr = [CommentListModel]()
                         let listDict = model?.comments
                         for dict in listDict!{
                            if let commenyModel =  CommentListModel.mj_object(withKeyValues: dict){
                                dynamicCommListArr.append(commenyModel)
                                if commenyModel.comments != nil {
                                    if  let listDict = commenyModel.comments {
                                        for dict in listDict{
                                            if let commenyModel =  CommentListModel.mj_object(withKeyValues: dict){
                                                dynamicCommListArr.append(commenyModel)
                                            }
                                        }
                                    }
                                }
                            }
                           self?.commentTotalArr.append(dynamicCommListArr)
                            dynamicCommListArr.removeAll()
                    }
                }
                        for  model in (self?.commentTotalArr)!{
                            self?.tableRowNumArr.append(model.count)
                            let footerModel = CommandFooterStatusModel.init()
                            footerModel.btnStausts = "收起"
                            footerModel.btnImg = #imageLiteral(resourceName: "down_arrow")
                            self?.btnStaustsArr.append(footerModel)
                        }
                    
                self?.statusTableview.reloadData()
                self?.cacheImages((self?.modelView)!)
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
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





extension  DynamicDetailVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commentTotalArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var  rowNum = 0
        if section == 0 {
            rowNum = 1
        }else{
            rowNum = tableRowNumArr[section - 1]
        }
        return  rowNum
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell = UITableViewCell.init()
        if  indexPath.section == 0 {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "CircleStautsCellID") as!  CircleStautsCell
            if  modelView.count > 0  {
                firstCell.viewModel = modelView[indexPath.row]

            }
            // 显示，并指定打开第几张图
            firstCell.pictureView.pushImageClouse = {[weak self](tempPictureView ,index , strArr) in
                self?.picStrsArr  =  strArr
                self?.addPictrueVC()
                self?.collectionView = tempPictureView
                self?.browser?.show(index: index.row)
            }
            cell = firstCell
        }else{
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "DynamicCommonCellID") as!  DynamicCommonCell
             //取出模型数组
           if commentTotalArr.count > 0  {
           let modelArr = commentTotalArr[indexPath.section - 1]
            //取出模型
            if modelArr.count > 0  {
            let model = modelArr[indexPath.row]
             commentCell.viewModel = model
            }
          }
          cell = commentCell
       }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var sectionH = 0.1
        if section ==  0 {
            sectionH = 0.1
        }else{
//            取出模型数组
           if commentTotalArr.count > 0  {
           let modelArr = commentTotalArr[section - 1]
            //取出模型
           if modelArr.count > 1  {
              sectionH = 40
           }else{
             sectionH = 0.1
            }
          }
        }
        return CGFloat(sectionH)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let showOrHideView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 40))
        let showOrHideBtn = UIButton.init()
        showOrHideBtn.frame.size = CGSize.init(width: 100, height: 40)
        showOrHideBtn.center = showOrHideView.center
        let imgView = UIImageView.init(frame: CGRect.init(x: showOrHideBtn.centerX + 20, y: showOrHideBtn.centerY - 5, width: 10, height: 10))
        var  btnStausts : String?
        var  img   : UIImage?
        if section > 0 && tableRowNumArr[section - 1] > 1 {
            btnStaustsArr[section - 1].btnStausts! = "收起"
            btnStaustsArr[section - 1].btnImg! = #imageLiteral(resourceName: "up_arrow")
            btnStausts  = btnStaustsArr[section - 1].btnStausts!
            img = btnStaustsArr[section - 1].btnImg
        }else if section > 0 && tableRowNumArr[section - 1] == 1{
            btnStaustsArr[section - 1].btnStausts! = "展开"
            btnStaustsArr[section - 1].btnImg! = #imageLiteral(resourceName: "down_arrow")
            btnStausts = btnStaustsArr[section - 1].btnStausts!
            img = btnStaustsArr[section - 1].btnImg
        }
      
        showOrHideBtn.setTitle(btnStausts, for: .normal)
        showOrHideBtn.setTitleColor(UIColor.lightGray, for: .normal)
        imgView.image = img
        showOrHideBtn.contentMode = .bottomLeft
        showOrHideBtn.foldTag = section
        showOrHideBtn.addTarget(self, action: #selector(flodTale(btn:)), for: .touchUpInside)
        showOrHideView.addSubview(showOrHideBtn)
        showOrHideView.addSubview(imgView)
        
      //  取出模型数组
        if section > 0 && commentTotalArr.count > 0  {
            let modelArr = commentTotalArr[section - 1]
            //取出模型
            if modelArr.count > 1  {
                showOrHideView.isHidden = false
            }else{
              showOrHideView.isHidden = true
            }
        }
        return  showOrHideView
    }
    
    
    @objc func flodTale(btn : UIButton){
        
        let section = btn.foldTag
        if   tableRowNumArr[section - 1] == 1{
            tableRowNumArr[section - 1] =  commentTotalArr[section - 1].count
        }else{
            tableRowNumArr[section - 1] = 1
        }
        statusTableview.reloadData()
        
    }
    
    
}

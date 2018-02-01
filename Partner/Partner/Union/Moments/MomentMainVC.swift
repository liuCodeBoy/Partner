//
//  MomentMainVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit
import SDWebImage
import JXPhotoBrowser

class MomentMainVC: UIViewController , UITableViewDelegate, UITableViewDataSource ,PhotoBrowserDelegate {
    @IBOutlet weak var momentTableView: UITableView!
    var  modelView =  [UnionListModel]()
    var  statusViewModelArr = StatusViewModel()
    var   browser : PhotoBrowser?
    var   picStrsArr : [String]?
    var   collectionView : UICollectionView?
    override func viewDidLoad() {
        super.viewDidLoad()
          loadStatuses()
        momentTableView.rowHeight = UITableViewAutomaticDimension
        momentTableView.estimatedRowHeight = 200
        momentTableView.separatorStyle = .none
    }
    //生成照片控制器
    func addPictrueVC(){
        // 创建实例，传入present发起者，和delegate实现者
        browser = PhotoBrowser(showByViewController: self, delegate: self as! PhotoBrowserDelegate)
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





extension MomentMainVC {
    fileprivate func loadStatuses() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        
        NetWorkTool.shareInstance.getSocialCircleMomentList(token: access_token, type: 1, pageNum: 0) { [weak self](result, error) in
            if error != nil {
                return }
            guard let resultArray = result else{
                return
            }
            let dict  =   resultArray["result"] as? NSDictionary
          
            if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
            {
                self?.statusViewModelArr =  statusViewModel
                
            }
            if  let listDict = dict!["list"] as? [NSDictionary]  {
                for dict in listDict{
                    let model =  UnionListModel.mj_object(withKeyValues: dict)
                    self?.modelView.append(model!)
                }
            }
            self?.cacheImages((self?.modelView)!)
        }

    }
    
    fileprivate func cacheImages(_ viewModels: [UnionListModel]) {
        let group = DispatchGroup()
        for viewModel in viewModels {
            for picStr in viewModel.imgUrls! {
                group.enter()
                let picURL = URL(string: picStr as String)
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _) in
                group.leave()
                })
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

}








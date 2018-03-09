//
//  DynamicDetailVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/5.

import UIKit
import SDWebImage
import NoticeBar
import JXPhotoBrowser
import MJRefresh
import NVActivityIndicatorView

class DynamicDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource ,PhotoBrowserDelegate {
    @IBOutlet weak var inputDialogueView: UIView!
    @IBOutlet weak var inputTF: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var statusTableview: UITableView!
    
    var isPushedFromTabBarHidden = false
    var  modelView =  [UnionListModel]()
    var  statusViewModelArr = StatusViewModel()
    var  commentTotalArr = [[CommentListModel]]()
    var  browser : PhotoBrowser?
    var  picStrsArr : [String]?
    var  collectionView : UICollectionView?
    var  momentId : Int?
    var  tableRowNumArr = [Int]()
    var  btnStaustsArr = [CommandFooterStatusModel]()
   
    var  commentType = 1
    var  parentId : Int?
    var  socialCircleId : Int?
    var  dynamicIsMy = 3

    var inputText: String? {
        didSet {
            if inputText?.count == 0 {
                sendBtn.isEnabled = false
                sendBtn.backgroundColor = UIColor.init(white: 0.84, alpha: 1)
            } else {
                sendBtn.isEnabled = true
                sendBtn.backgroundColor = #colorLiteral(red: 0.3019607961, green: 0.6941176653, blue: 0.980392158, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTableview.rowHeight = UITableViewAutomaticDimension
        statusTableview.estimatedRowHeight = 200
        statusTableview.separatorStyle = .none
        
        //加载动画
       NVActivityIndicatorPresenter.sharedInstance.startAnimating(AppDelegate.activityData)
        loadRefreshComponet(tableView: statusTableview)
        
        //接受键盘输入通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notific:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //接受键盘收回通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        sendBtn.setTitleColor(UIColor.darkGray, for: .disabled)
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        inputTF.addTarget(self, action: #selector(passData), for: .allEditingEvents)
        
        loadStatuses()
    }
    
    @objc func passData() {
        inputText = inputTF.text
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
    @IBAction func sendBtnClicked(_ sender: Any) {
        if inputTF.text?.replacingOccurrences(of: " ", with: "") == "" || inputTF.text == nil || inputTF.text == "" {
            presentHintMessage(hintMessgae: "输入不能为空", completion: nil)
            return
        }
        if commentType  == 1 {
            parentId = nil
            socialCircleId = nil
        }
        commentFunc()
    }
    
    func loadRefreshComponet(tableView : UITableView) -> () {
        //默认下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    
    @objc func refresh() -> () {

        self.modelView.removeAll()
        self.btnStaustsArr.removeAll()
        self.commentTotalArr.removeAll()
        self.tableRowNumArr.removeAll()

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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



extension DynamicDetailVC {
    
    func loadStatuses() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            
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
    
    //coment function
    func commentFunc() -> () {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            
            self.presentAlert(title: "您还未登录", hint: "", confirmTitle: "登录", cancelTitle: "取消", confirmation: { (action) in
                let  navRegistAndLoginVC = UINavigationController.init(rootViewController: AppDelegate.RegisterAndLoginVC)
                self.present(navRegistAndLoginVC, animated: true, completion: nil)
            }, cancel: nil)
            return
        }
        
        var color = UIColor.red
        var showInfo = ""
        
        
        NetWorkTool.shareInstance.momentComment(token: access_token, type: commentType, momentId: momentId!, parentId: parentId, commContent: inputTF.text!, socialCircleId: socialCircleId) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "评论成功"
                self?.commentType = 1
                self?.inputTF.text = ""
                self?.inputTF.resignFirstResponder()
                self?.refresh()
            }else{
                showInfo =  result!["msg"] as! String
            }
            
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
         }
        
    }
    
}

// MARK:- tableview delegate function
extension  DynamicDetailVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        // 取出模型数组
        var numSection = 0
        if commentTotalArr.count > 0  {
            numSection =  self.commentTotalArr.count + 1
        }else{
            numSection = 2
        }
        return numSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var  rowNum = 0
        if section == 0 {
            rowNum = 1
        }else if(commentTotalArr.count != 0){
            rowNum = tableRowNumArr[section - 1]
        }else{
            rowNum = 1
        }
        return  rowNum
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell = UITableViewCell.init()
        if  indexPath.section == 0 {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "CircleStautsCellID") as!  CircleStautsCell
            
            firstCell.popClouse = {() in
                self.navigationController?.popViewController(animated: true)
                AppDelegate.momentVC.refresh()
            }
            
            if  modelView.count > 0  {
                firstCell.viewModel = modelView[indexPath.row]
                dynamicIsMy = modelView[indexPath.row].my as! Int
            }
            // 显示，并指定打开第几张图
            firstCell.pictureView.pushImageClouse = {[weak self](tempPictureView ,index , strArr) in
                self?.picStrsArr  =  strArr
                self?.addPictrueVC()
                self?.collectionView = tempPictureView
                self?.browser?.show(index: index.row)
            }
            cell = firstCell
        }else if(commentTotalArr.count != 0){
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "DynamicCommonCellID") as!  DynamicCommonCell
             //取出模型数组
           if commentTotalArr.count > 0  {
           let modelArr = commentTotalArr[indexPath.section - 1]
            //取出模型
            if modelArr.count > 0  {
            let model = modelArr[indexPath.row]
             commentCell.viewModel = model
             commentCell.dynamicIsMy = dynamicIsMy

            }
          }
          cell = commentCell
        }else if(commentTotalArr.count == 0){
             let commentCell = tableView.dequeueReusableCell(withIdentifier: "NoCommentCellID") as!  NoCommentCell
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
        let imgView = UIImageView.init(frame: CGRect.init(x: showOrHideBtn.centerX + 20, y: showOrHideBtn.centerY - 5, width: 13, height: 10))
        var  btnStausts : String?
        var  img   : UIImage?
        if commentTotalArr.count > 0 {
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


// MARK:- 键盘响应事件
extension DynamicDetailVC{
    //键盘的弹起监控
    @objc func keyboardWillChangeFrame(notific: NSNotification) {
        let info = notific.userInfo
        let  keyBoardBounds = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var deltaY = keyBoardBounds.size.height +  (self.inputDialogueView?.frame.height)!
            //keyBoardBounds.size.height - 2 * tabBarHeight + (self.inputDialogueView?.frame.height)!
        let animations:(() -> Void) = {
            //键盘的偏移量
            
            if self.isPushedFromTabBarHidden == true {
                deltaY = keyBoardBounds.size.height
            }
            
            self.inputDialogueView.transform = CGAffineTransform(translationX: 0 , y: -(deltaY))
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((info?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    //键盘的收起监控
    @objc func keyboardWillHidden(note: NSNotification) {
        let userInfo  = note.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.inputDialogueView.transform = .identity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    
}






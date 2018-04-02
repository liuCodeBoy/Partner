//
//  StatusViewCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit
import SDWebImage
import NoticeBar
 let edgeMargin: CGFloat = 10
 let itemMargin: CGFloat = 5
class StatusViewCell: UITableViewCell {
    var   showVCClouse : showVCType?
    @IBOutlet weak var collectionViewButtonDistanceCons: NSLayoutConstraint!
    @IBOutlet weak var collectionviewHCons: NSLayoutConstraint!
    @IBOutlet weak var collectionViewWCons: NSLayoutConstraint!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var identifyIcon: UIButton!
    
    @IBOutlet weak var createAt: UILabel!
    @IBOutlet weak var sourceFrom: UILabel!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var commentNumLab: UILabel!
    @IBOutlet weak var zanNumLab: UILabel!
    @IBOutlet weak var pictureView: PicCollectionView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var zanBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
     var pushVC : showVCType?
 
    
    var viewModel: UnionListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImage.sd_setImage(with: URL.init(string: viewModel.userImgUrl! as String), placeholderImage: nil)
            let guestrue = UITapGestureRecognizer.init(target: self, action: #selector(showUserInfo))
            avatarImage.addGestureRecognizer(guestrue)
           
            var   userIdentify : String?
            if let   IndentID = viewModel.userIdenId {
                switch Int(truncating: IndentID) {
                case 1:
                    userIdentify = "投资商"
                    break
                case 2:
                    userIdentify = "创业者"
                    break
                case 3:
                    userIdentify = "普通用户"
                    break
                default:
                    break
                }
            }
            //设置评论数
            if let  commentNum = viewModel.commentNum{
                if commentNum != 0 {
                    self.commentBtn.isSelected = true
                    self.commentNumLab.text = "\(commentNum)"
                }else{
                    self.commentBtn.isSelected = false
                    self.commentNumLab.text = "\(0)"
                }
            }
            //设置点赞数
            if let  thumbNum = viewModel.thumbNum{
                if thumbNum != 0 {
                    self.zanBtn.isSelected = true
                    self.zanNumLab.text = "\(thumbNum)"
                }else{
                    self.zanBtn.isSelected = false
                    self.zanNumLab.text = "\(0)"
                }
            }
            
            identifyIcon.setTitle(userIdentify, for: .normal)
            nickname.text = viewModel.userName
            createAt.text = viewModel.sendDate! as String
            if let name = viewModel.commName{
                sourceFrom.text = name as String
            }
            
            contentText.text = viewModel.content as String?
  
            
            var   urlArr = [URL]()
            if let urls = viewModel.imgUrls {
                for picStr in urls {
                    let picURL = URL(string: picStr as String)
                    urlArr.append(picURL!)
                }
                pictureView.picURLs = urlArr
                pictureView.picStrs =  viewModel.imgUrls! as [String]
            }else{
                pictureView.picURLs = [URL]()
            }
            let imageCount =  viewModel.imgUrls == nil ? 0  : viewModel.imgUrls?.count
        
            let pictureViewSize = calculatePictureSize(imageCount!)
            collectionviewHCons.constant = pictureViewSize.height
            collectionViewWCons.constant = pictureViewSize.width
       }
    
}
    
    @objc func showUserInfo(){
        if pushVC != nil {
            let uid = viewModel?.uid as? Int
            guard uid != nil else{
                return
            }
            // let  uid = UserDefaults.standard.integer(forKey: "uid")
            pushVC!(uid!)
        }
    }
    @IBAction func deleteStatus(_ sender: Any) {
        let alert = UIAlertController(title: "请选择操作类型", message: "", preferredStyle: .actionSheet)
        let ignoreAction = UIAlertAction(title: "屏蔽", style: .destructive) { [weak self](action) in
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                return
            }
            if let id = self?.viewModel?.momentId {
               self?.momentIgnore(access_token: access_token, id: Int(truncating: id))
            }
        }
        let reportAction = UIAlertAction(title: "举报", style: .destructive) { [weak self](action) in
            if let id = self?.viewModel?.momentId {
                let reportVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleReportVCID") as! CircleReportVC
                reportVC.circleId = Int(truncating: id)
                AppDelegate.momentVC.navigationController?.pushViewController(reportVC, animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(ignoreAction)
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        AppDelegate.momentVC.present(alert, animated: true, completion: nil)
    }
    @IBAction func commentAction(_ sender: Any) {
//        DynamicDetailVCID
        weak var weakself = self
        if weakself?.showVCClouse != nil{
            weakself?.showVCClouse!(weakself?.viewModel?.momentId as! Int)
        }
    }
    @IBAction func zanAction(_ sender: UIButton) {
        thumb(btn: sender, isThumb: self.viewModel?.thumb as! Int)
    }
    
override  func awakeFromNib() {
        super.awakeFromNib()
        let layout = pictureView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
    
        pictureView.isScrollEnabled = false
        let imageViewWH = (screenWidth - 20  - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }
    
}

extension StatusViewCell {
     func calculatePictureSize(_ count: Int) -> CGSize{
        if count == 0 {
            collectionViewButtonDistanceCons.constant = 0
            return CGSize.zero
        }
        
        if count == 1 {
            return CGSize(width: screenWidth - 20 - 2 * edgeMargin - 2 * itemMargin, height: 150)
        }
        collectionViewButtonDistanceCons.constant = 10
        let imageViewWH = (screenWidth - 20 - 2 * edgeMargin - 2 * itemMargin) / 3
        if count == 4 {
            let pictureViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: pictureViewWH, height: pictureViewWH)
        }
        let rows = CGFloat((count - 1) / 3 + 1)
        let pictureViewWidth = screenWidth - 20  - 2 * edgeMargin
        let pictureViewHeight = rows * imageViewWH + (rows - 1) * itemMargin
        return CGSize(width: pictureViewWidth, height: pictureViewHeight)
    }
}


extension  StatusViewCell {
    func thumb(btn : UIButton , isThumb : Int){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        guard let id = viewModel?.momentId else{
            return
        }
        if isThumb == 1 {
            cancelThumb(btn: btn, access_token: access_token, id: Int(truncating: id))
        }else{
            getNmomentThumb(btn: btn, access_token: access_token, id: Int(truncating: id))
        }
     
    }
    //MARK: - 点赞方法

   func getNmomentThumb(btn : UIButton , access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.getNmomentThumb(token: access_token, id: id) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "点赞成功"
                btn.isSelected = true
                self?.viewModel?.thumb = 1
                let thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) + 1
                 self?.viewModel?.thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) + 1 as NSNumber
                self?.zanNumLab.text = "\(thumbNum)"
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
    
  //MARK: - 取消点赞方法
    func cancelThumb(btn : UIButton , access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.cancelThumb(token: access_token, id: id) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                btn.isSelected = false
                 self?.viewModel?.thumb = 0
                 showInfo = "取消点赞成功"
                let thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) - 1
                 self?.viewModel?.thumbNum = Int(truncating: (self?.viewModel?.thumbNum)!) - 1 as NSNumber
                self?.zanNumLab.text = "\(thumbNum)"
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
    //MARK: - 屏蔽该动态
    func momentIgnore(access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.momentIgnore(token: access_token, id: id) {(result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "屏蔽成功"
                AppDelegate.momentVC.refresh()
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
}





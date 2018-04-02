//
//  CircleStautsCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/27.
//

import UIKit
import SDWebImage
import NoticeBar
typealias popVC = () -> ()
class CircleStautsCell: UITableViewCell {
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
    @IBOutlet weak var deleteLab: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
//
    @IBOutlet weak var pictureView: PicCollectionView!
    @IBOutlet weak var zanBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    var pushVC : showVCType?
    var popClouse : popVC?
    
    var viewModel: UnionListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImage.sd_setImage(with: URL.init(string: viewModel.userImgUrl! as String), placeholderImage: #imageLiteral(resourceName: "partner_img_placeholder"))
            let guestrue = UITapGestureRecognizer.init(target: self, action: #selector(showUserInfo))
            avatarImage.addGestureRecognizer(guestrue)
            
            var   userIdentify : String?
            if let identID = viewModel.userIdenId{
                switch Int(truncating: identID) {
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
                identifyIcon.setTitle(userIdentify, for: .normal)
            }
            if viewModel.my == 1 {
                deleteBtn.isHidden = false
                deleteLab.isHidden = false
            }else if viewModel.my == 0 {
                deleteBtn.isHidden = true
                deleteLab.isHidden = true
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
            let uid = viewModel?.userId as? Int
            guard uid != nil else{
                return
            }
            // let  uid = UserDefaults.standard.integer(forKey: "uid")
            pushVC!(uid!)
        }
    }
    @IBAction func deleteBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: "确定要删除改动态吗", message: "", preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确认", style: .destructive) { [weak self](action) in
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                return
            }
            if let id = self?.viewModel?.momentId {
                
                self?.deleteDynamicAction(access_token: access_token, id: Int(truncating: id))
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
       
        alert.addAction(sureAction)
        alert.addAction(cancelAction)
        AppDelegate.dynamicDetailVC.present(alert, animated: true, completion: nil)
      
    }
    
    @IBAction func commentAction(_ sender: Any) {
          AppDelegate.dynamicDetailVC.inputTF.becomeFirstResponder()
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

extension CircleStautsCell {
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


// MARK:- 请求函数体
extension  CircleStautsCell {
    
    //删除评论函数
    func  deleteAction( access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.deleteComment(token: access_token, commentId: id) {(result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "删除成功"
               
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
    //删除动态函数
    func  deleteDynamicAction( access_token : String ,id : Int){
        var color = UIColor.red
        var showInfo = ""
        NetWorkTool.shareInstance.deleteMoment(token: access_token, id: id) {[weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                color = #colorLiteral(red: 0.6242706776, green: 0.8754864931, blue: 0.8703722358, alpha: 1)
                showInfo = "删除成功"
                if self?.popClouse != nil {
                    self?.popClouse!()
                }
            }else{
                showInfo =  result!["msg"] as! String
            }
            let config = NoticeBarConfig(title: showInfo, image: nil, textColor: UIColor.white, backgroundColor: color, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
            let noticeBar = NoticeBar(config: config)
            noticeBar.show(duration: 1.5, completed: nil)
        }
    }
    
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

    //点赞按钮
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
    

    
}








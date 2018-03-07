//
//  CircleStautsCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/27.
//

import UIKit
import SDWebImage
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
    
    @IBOutlet weak var pictureView: PicCollectionView!
    @IBOutlet weak var zanBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    
    var viewModel: UnionListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImage.sd_setImage(with: URL.init(string: viewModel.userImgUrl! as String), placeholderImage: nil)
            
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
    

    @IBAction func commentAction(_ sender: Any) {
    }
    @IBAction func zanAction(_ sender: Any) {
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








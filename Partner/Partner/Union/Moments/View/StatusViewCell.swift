//
//  StatusViewCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit
import SDWebImage

 let edgeMargin: CGFloat = 10
 let itemMargin: CGFloat = 5
class StatusViewCell: UITableViewCell {

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
    
    
    var viewModel: UnionListModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            avatarImage.sd_setImage(with: URL.init(string: viewModel.userImgUrl! as String), placeholderImage: nil)
            
            var   userIdentify : String?
            switch Int(truncating: viewModel.userIdenId!) {
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
            nickname.text = viewModel.userName
            createAt.text = viewModel.sendDate! as String
            sourceFrom.text = viewModel.commName! as String
            contentText.text = viewModel.content as String?
  
            
            var   urlArr = [URL]()
            for picStr in viewModel.imgUrls! {
                let picURL = URL(string: picStr as String)
                urlArr.append(picURL!)
            }
            
            pictureView.picURLs = urlArr
            pictureView.picStrs =  viewModel.imgUrls! as [String]
            let pictureViewSize = calculatePictureSize((viewModel.imgUrls?.count)!)
            collectionviewHCons.constant = pictureViewSize.height
            collectionViewWCons.constant = pictureViewSize.width
       }
    
}
    
    
    @IBAction func deleteStatus(_ sender: Any) {
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

        let imageViewWH = (screenWidth - 20  - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        pictureView.isScrollEnabled = false
    }
    
}

extension StatusViewCell {
     func calculatePictureSize(_ count: Int) -> CGSize{
        if count == 0 {
            collectionViewButtonDistanceCons.constant = 0
            return CGSize.zero
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
    
    
}





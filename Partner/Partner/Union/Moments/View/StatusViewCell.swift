//
//  StatusViewCell.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/31.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 10
private let itemMargin: CGFloat = 10

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
   
    
    @IBOutlet weak var pictureView: PicCollectionView!
    

    
    var viewModel: StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
//            avatarImage.sd_setImage(with: viewModel.profileURL, placeholderImage: UIImage(named: "avatar_default_small"))
//            verifiedImage.image = viewModel.verifiedImage
//            nickname.text = viewModel.status?.user?.screen_name
//            createAt.text = viewModel.createAtText
//            sourceFrom.text = viewModel.sourceText
//            contentText.text = viewModel.status?.text
            
            let pictureViewSize = calculatePictureSize((viewModel.picURLs?.count)!)
            collectionviewHCons.constant = pictureViewSize.height
            collectionViewWCons.constant = pictureViewSize.width
            
            pictureView.picURLs = viewModel.picURLs!
        
               }
            }
    
    
    
override  func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.borderColor = UIColor.blue.cgColor
//        self.layer.borderWidth = 10
        let layout = pictureView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5

        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
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

        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3

        if count == 4 {
            let pictureViewWH = imageViewWH * 2 + itemMargin
            return CGSize(width: pictureViewWH, height: pictureViewWH)
        }

        let rows = CGFloat((count - 1) / 3 + 1)

        let pictureViewWidth = UIScreen.main.bounds.width - 2 * edgeMargin
        let pictureViewHeight = rows * imageViewWH + (rows - 1) * itemMargin


        return CGSize(width: pictureViewWidth, height: pictureViewHeight)
    }
}






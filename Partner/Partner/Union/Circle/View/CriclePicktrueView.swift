//
//  CriclePicktrueView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/2.
//

import UIKit
//定义跳转闭包
//typealias pushImageType = (UICollectionView ,IndexPath , [String]) -> ()
class CriclePicktrueView: UICollectionView {
    var   pushImageClouse : pushImageType?
//    var picURLs: [URL] = [URL]() {
 
    //        didSet {
//            sizeToFit()
//            self.reloadData()
//        }
//    }
   
   //picStrs var  picStrs = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate   = self
    }
    
}


extension CriclePicktrueView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return picURLs.count
        return  5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  2
    }
    
    
    //分区的header与footer
     func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview:UICollectionReusableView!
        
        //分区头
        if kind == UICollectionElementKindSectionHeader{
          
                reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "headerView", for: indexPath)
                //设置头部标题
                let label = reusableview.viewWithTag(1111) as! UILabel
                if indexPath.section == 0 {
                    label.text = "我的合伙圈"
                }else{
                    label.text = "其他社圈"
                }
        }else if kind == UICollectionElementKindSectionFooter{
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "footerView", for: indexPath)
        }
        return reusableview
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CriclePicCellID", for: indexPath) as! CriclePicktrueCell
        
        if  indexPath.row == 4{
            cell.addView.isHidden = false
        }else{
            cell.addView.isHidden = true
        }
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.pushImageClouse != nil{
//            self.pushImageClouse!(self , indexPath,picStrs)
        }
        
    }
    
    
    
    
}


class CriclePicktrueCell : UICollectionViewCell {
    @IBOutlet weak var CircleName: UILabel!
    @IBOutlet weak var member1Imag: UIImageView!
    @IBOutlet weak var member3Image: UIImageView!
    @IBOutlet weak var member2Image: UIImageView!
    @IBOutlet weak var CircleGrounpNum: UILabel!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var addView: UIView!
    
    var picURL: URL? {
        didSet {
            guard picURL != nil else {
                return
            }
          //  pictureCellView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    
//    @IBOutlet weak var pictureCellView: UIImageView!
    
    
}

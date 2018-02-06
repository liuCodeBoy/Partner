//
//  PicCollectionView.swift
//  DemoOfWeibo
//
//  Created by Weslie on 2017/6/1.
//  Copyright © 2017年 Weslie. All rights reserved.
//
//
import UIKit
//定义跳转闭包
typealias pushImageType = (UICollectionView ,IndexPath , [String]) -> ()
class PicCollectionView: UICollectionView {
    var   pushImageClouse : pushImageType?
    var picURLs: [URL] = [URL]() {
        didSet {
            sizeToFit()
            self.reloadData()
        }
    }
    
    var  picStrs = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate   = self
    }
    
}


extension PicCollectionView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        if  picURLs.count > 0  {
            cell.picURL = picURLs[indexPath.item]
        }else{
            cell.picURL = nil
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if self.pushImageClouse != nil{
            self.pushImageClouse!(self , indexPath,picStrs)
        }

    }
    
}


class PicCollectionViewCell: UICollectionViewCell {
    
    var picURL: URL? {
        didSet {
            guard picURL != nil else {
             pictureCellView.image = nil
                return
            }
            pictureCellView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var pictureCellView: UIImageView!
    
    
}

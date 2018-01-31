//
//  PicCollectionView.swift
//  DemoOfWeibo
//
//  Created by Weslie on 2017/6/1.
//  Copyright © 2017年 Weslie. All rights reserved.
//
//
import UIKit

class PicCollectionView: UICollectionView {

    var picURLs: [URL] = [URL]() {
        didSet {
            sizeToFit()
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
    }
    
}


extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        cell.picURL = picURLs[indexPath.item]
        
        return cell
    }
}


class PicCollectionViewCell: UICollectionViewCell {
    
    var picURL: URL? {
        didSet {
            guard picURL != nil else {
                return
            }
            pictureCellView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var pictureCellView: UIImageView!
    
}

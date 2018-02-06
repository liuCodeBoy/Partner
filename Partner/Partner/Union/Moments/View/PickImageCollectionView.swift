//
//  PickImageCollectionView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/5.
//

import UIKit

class PickImageCollectionView: UICollectionView {
    var   pushImageClouse : pushImageType?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate   = self
    }
    
}


extension PickImageCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return picURLs.count
        return  1
    }
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickImageCollectionViewCellID", for: indexPath) as! PickImageCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    
}


class PickImageCollectionViewCell : UICollectionViewCell {    
        @IBOutlet weak var pictureCellView: UIImageView!
    
    
}

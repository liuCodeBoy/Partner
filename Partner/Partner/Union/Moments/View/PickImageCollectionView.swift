//
//  PickImageCollectionView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/5.
//

import UIKit
import ImagePicker
import Lightbox
//定义跳转闭包
typealias pushVCType = (UIViewController) -> ()
class PickImageCollectionView: UICollectionView,ImagePickerDelegate {
    var   pushVCClouse : pushVCType?
    //定义初始化image数组
    var imageArr: [UIImage] = [UIImage]() {
        didSet {
            sizeToFit()
            self.reloadData()
        }
    }
    var  maxPictrues : Int  = 9
    override func awakeFromNib() {
        super.awakeFromNib()
        imageArr.append(UIImage.init(named: "society_add")!)
        self.layer.borderColor = #colorLiteral(red: 0.8796055317, green: 0.8868338466, blue: 0.9087586403, alpha: 1)
        self.layer.borderWidth = 1.0
        dataSource = self
        delegate   = self
    }
    
}


extension PickImageCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickImageCollectionViewCellID", for: indexPath) as! PickImageCollectionViewCell
        if  imageArr.count > 0  {
//            if imageArr.count == indexPath.item {
//                 cell.pictureCellView.image = UIImage.init(named: "plus")
//            }
//            else{
                 cell.pictureCellView.image = imageArr[indexPath.item]
           // }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
         let   number = maxPictrues - imageArr.count + 1
         if    number > 0 {
            imagePickerController.imageLimit = number
            if self.pushVCClouse != nil {
                self.pushVCClouse!(imagePickerController)
            }
         }
    }
    
    
    
   
    
    // MARK: - ImagePickerDelegate
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
         guard images.count > 0 else { return }
        imagePicker.dismiss(animated: true) {
            weak var  weakself = self
            for tempImage  in images{
                weakself?.imageArr.insert(tempImage, at: 0)
            }
        }       
    }
}


class PickImageCollectionViewCell : UICollectionViewCell {    
    @IBOutlet weak var pictureCellView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

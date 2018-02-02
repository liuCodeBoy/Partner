//
//  CricleViewController.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/2.
//

import UIKit

class CricleViewController: UIViewController {
    @IBOutlet weak var circlePickertrueView: CriclePicktrueView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = circlePickertrueView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        
        let imageViewWH = (screenWidth   - 3 * edgeMargin ) / 2
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        
        self.addPushBtn()
    }
    
    
    //添加发布按钮
    func   addPushBtn(){
        let  btn = UIButton.init(frame: CGRect.init(x: screenWidth - 58 , y: screenHeight - 180 , width: 46, height: 46))
        btn.setImage(UIImage.init(named: "pushBtn"), for: .normal)
        self.view.addSubview(btn)
        
    }
    

}

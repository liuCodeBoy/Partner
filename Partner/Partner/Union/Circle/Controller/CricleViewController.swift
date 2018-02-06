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
        
        
     
    }
}

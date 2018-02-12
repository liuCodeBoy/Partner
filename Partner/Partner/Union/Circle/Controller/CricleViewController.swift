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
         setLayout()
         showVCClouse()
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestNetwork), name: NSNotification.Name?.init(NSNotification.Name(rawValue: "Refresh")), object: nil)
    }


    @objc  func requestNetwork(){
        circlePickertrueView.awakeFromNib()
    }
    
    
//设置闭包弹出
    func showVCClouse() -> () {
        circlePickertrueView.showInfoTypeClouse = {(info) in
            self.presentHintMessage(hintMessgae: info, completion: { (action) in
            })
        }
        circlePickertrueView.showVCClouse = {() in
        let createVC = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CreateCricleVCID")
        self.navigationController?.show(createVC, sender: nil)
        }
    }
    
//添加布局
    func setLayout() -> () {
        let layout = circlePickertrueView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        let imageViewWH = (screenWidth   - 3 * edgeMargin ) / 2
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }
    
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
}




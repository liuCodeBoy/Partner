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
        circlePickertrueView.refresh()
    }
    
    
//设置闭包弹出
    func showVCClouse() -> () {
        var  isceate = 0
        circlePickertrueView.postiSCreateClouse = {(create) in
            isceate = create
        }
        
        circlePickertrueView.showInfoTypeClouse = {(info) in
            self.presentHintMessage(hintMessgae: info, completion: { (action) in
            })
        }
        circlePickertrueView.showVCClouse = {(circleID) in
            var  destVC : UIViewController?
            if circleID == 0 {
                destVC  = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CreateCricleVCID")
            }else{
                let  detailVC  = UIStoryboard.init(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "CircleDetailVCID") as! CircleDetailVC
                detailVC.circleId = circleID
                detailVC.create = isceate
                destVC = detailVC
            }
            self.navigationController?.show(destVC!, sender: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
    }
  
}




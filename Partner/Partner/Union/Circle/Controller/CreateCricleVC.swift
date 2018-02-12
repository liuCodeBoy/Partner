//
//  CreateCricleVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/9.
//

import UIKit
import NVActivityIndicatorView
class CreateCricleVC: UIViewController {
    @IBOutlet weak var pictrueCollectionView: PickImageCollectionView!
    @IBOutlet weak var placeholdView: LimitTextView!
    let   limitNumbers  = 20
    let   pictrueNumber = 1
 override func viewDidLoad() {
        super.viewDidLoad()
        placeholdView.limitNum    = limitNumbers
        pictrueCollectionView.maxPictrues = pictrueNumber
        showVCClouse()
        setLayout()
        
      
    }
    
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
 
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if Int(placeholdView.inputTF.text.count) == 0 || placeholdView.inputTF.text.replacingOccurrences(of: " ", with: "") == "" {
            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
        } else if Int(placeholdView.inputTF.text.count) > limitNumbers {
            presentHintMessage(hintMessgae: "字符不能超过\(limitNumbers)字", completion: nil)
            return
        } else {
            // TODO:- post request
            //保存身份选择
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                presentHintMessage(hintMessgae: "您还未登录", completion: nil)
                return
            }
        
            //加载动画
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(AppDelegate.activityData)
            NetWorkTool.shareInstance.circleCreated(token: access_token, membIds: UserDefaults.standard.string(forKey: "uid")!, circName: placeholdView.inputTF.text, circDesc: "", image: pictrueCollectionView.imageArr[0], finished: { [weak self](info, error) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                if error == nil {
                 // MARK:- judge the return data from server
                if  info?["code"] as? Int == 200  {
                self?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                    NotificationCenter.default.post(name: NSNotification.Name.init("Refresh"), object: nil)
                 self?.navigationController?.popViewController(animated: true)
                  })
              } else {
                     let  errorShow  =  info!["msg"] as! String
                     NVActivityIndicatorPresenter.sharedInstance.setMessage("提交成功")
                     self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
        
                  }
               }
            })

            
            
            
            
            
            //            NetWorkTool.shareInstance.perfectUserRequireInfo(token: access_token, require: inputTF.text, finished: { [weak self](result, error) in
            //                if error == nil {
            //                    // MARK:- judge the return data from server
            //                    if  result?["code"] as? Int == 500  {
            //                        self?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
            //                            self?.navigationController?.dismiss(animated: true , completion: nil)
            //                        })
            //                    } else {
            //                        let  errorShow  =  result!["msg"] as! String
            //                        self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            //
            //                    }
            //                }
            //            })
        }
        
    }
    
    
    
    
    
    
    
    //设置闭包弹出
    func showVCClouse() -> () {
        placeholdView.showInFoClouse = {(info) in
            self.presentHintMessage(hintMessgae: info, completion: { (action) in
            })}
        
        pictrueCollectionView.pushVCClouse = {[weak self](imagePickerController) in
            self?.present(imagePickerController, animated: true, completion: nil)
          }
        }
    
    
    //添加布局
    func setLayout() -> () {
        let layout = pictrueCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let imageViewWH = (screenWidth   - 6 * edgeMargin ) / 7
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
    }


}

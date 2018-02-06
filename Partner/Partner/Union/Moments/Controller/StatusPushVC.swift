//
//  StatusPushVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/5.
//

import UIKit

class StatusPushVC: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    
    
    var feedbackString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
        }
    }
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        if Int(inputTF.text.count) == 0 || inputTF.text.replacingOccurrences(of: " ", with: "") == "" {
            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
        } else if Int(inputTF.text.count) > 500 {
            presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            return
        } else {
            // TODO:- post request
            //保存身份选择
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                return
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTF.delegate = self
        
        
        let layout = imagePickerImageView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        
        let imageViewWH = (screenWidth   - 3 * edgeMargin ) / 2
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
       
    }
    @IBOutlet weak var imagePickerImageView: UICollectionView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.inputTF.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        feedbackString = inputTF.text
    }
  
    
}



//
//  StatusPushVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/5.
//

import UIKit
import NVActivityIndicatorView
class StatusPushVC: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var isArrow: UIButton!
    @IBOutlet weak var momePublicText: UIButton!
    @IBOutlet weak var isPublicBtn: UIButton!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    @IBOutlet weak var imagePickerImageView: PickImageCollectionView!
    @IBOutlet weak var showCircleView: CircleChooseTableView!
    @IBOutlet weak var publicView: UIView!
    @IBOutlet weak var circleLayoutView: UIView!
    @IBOutlet weak var publicViewH: NSLayoutConstraint!
    
    var circleViewisHidden = false
   
    var circleId : Int?
    var circleName : String?
    var selectedStrArr  = [String]()
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
    @IBAction func showPublicBtnStatus(_ sender: UIButton) {
        changeBtnStatus()
    }
    
    func changeBtnStatus(){
        self.isPublicBtn.isSelected =  !self.isPublicBtn.isSelected
        if isPublicBtn.isSelected {
            momePublicText.setTitle("公开", for: .normal)
        }else{
            momePublicText.setTitle("", for: .normal)
        }
    }
    //展示社圈
    @IBAction func changeArrowAction(_ sender: Any) {
        self.isArrow.isSelected = !self.isArrow.isSelected
        showCircleView.isHidden = self.isArrow.isSelected
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        selectedStrArr.removeAll()
        if Int(inputTF.text.count) == 0 || inputTF.text.replacingOccurrences(of: " ", with: "") == "" {
            presentHintMessage(hintMessgae: "输入内容不能为空", completion: nil)
        } else if Int(inputTF.text.count) > 500 {
            presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            return
        } else {
            // TODO:- post request
            //保存身份选择
            guard let access_token = UserDefaults.standard.string(forKey: "token") else{
                self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
                return
            }
            
            var momPublic = 1
            var circleIdString : String?
            circleIdString = nil
            if circleId == nil {
                if isPublicBtn.isSelected == true {
                    momPublic = 1
                    circleIdString =  nil
                }else{
                    momPublic = 2
                    circleIdString = getCircleIdString()
                    if self.selectedStrArr.count > 1 {
                        presentHintMessage(hintMessgae: "只能勾选一个社圈", completion: nil)
                        return
                    }
                }
            }else{
                momPublic = 2
                circleIdString = "\(String(describing: circleId!))"
            }
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(AppDelegate.activityData)
            NetWorkTool.shareInstance.momentSend(token: access_token, circleIds: circleIdString, momeContent: inputTF.text, momePublic: momPublic, image: imagePickerImageView.imageArr, finished: { [weak self](result, error) in
                if error == nil {
                    // MARK:- judge the return data from server
                    if  result?["code"] as? Int == 200  {
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        self?.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        let  errorShow  =  result!["msg"] as! String
                        self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                        
                    }
                }
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //获取圈ID字符串
    func getCircleIdString() -> (String){
        var resultStr = ""
        var isFirst   = 0
        let modelArr = self.showCircleView.userModelArr
        for i  in 0..<modelArr.count{
            let model = modelArr[i]
            if model.selected == 1 && isFirst == 0 {
                resultStr = "\(String(describing: model.id!))"
                selectedStrArr.append(resultStr)
                isFirst = 1
            }else if (model.selected == 1){
                selectedStrArr.append("\(String(describing: model.id!))")
                resultStr += "," + "\(String(describing: model.id!))"
            }
        }
        return resultStr
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTF.delegate = self
        
        self.publicView.isHidden = circleViewisHidden
        self.circleLayoutView.isHidden = circleViewisHidden
        self.showCircleView.isHidden = circleViewisHidden
        momePublicText.setTitle(self.circleName, for: .normal)
        
        let layout = imagePickerImageView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let imageViewWH = (screenWidth   - 6 * edgeMargin ) / 7
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        
        imagePickerImageView.pushVCClouse = {[weak self](imagePickerController) in
            self?.present(imagePickerController, animated: true, completion: nil)
        }
       
    }

    
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



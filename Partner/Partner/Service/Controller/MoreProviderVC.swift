//
//  MoreProviderVC.swift
//  Partner
//
//  Created by Weslie on 14/03/2018.
//

import UIKit
import SCLAlertView

class MoreProviderVC: UIViewController {

    var provideID : Int?
    var showTypeName : String?
    var modelArr = [ServiceProvideListModel]()

    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
      super.viewDidLoad()
      getListType()
      getPhoneNum()
    }

    
    
    @IBAction func submitClick(_ sender: Any) {
        getProvider()
    }
    
    @IBAction func phoneCall(_ sender: Any) {
        let urlString = self.phoneBtn.titleLabel?.text
        makePhoneCall(with: urlString!)
    }
    @IBAction func popVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func  getProvider() -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            SCLAlertView().showError("request error", subTitle: "您尚未登录")
            return
        }
        guard let id =  provideID  else {
            SCLAlertView().showError("request error", subTitle: "请选择类型")
            return
        }
        
        NetWorkTool.shareInstance.supportCommit(token: access_token, typeId: id, suppContent: "") {(result, error) in
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                SCLAlertView().showSuccess("", subTitle: "\(String(describing: result!["msg"]!))")
                self.navigationController?.popViewController(animated: true)
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
    func getPhoneNum(){
        NetWorkTool.shareInstance.getPhone(phoneType: 3) { (result, error) in
            weak var  weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                let  phoneStr = result!["result"]
                weakSelf?.phoneBtn.setTitle(phoneStr as? String, for: .normal)
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
    func getListType(){
        NetWorkTool.shareInstance.getTypeList(typeCate: 2) { [weak self](info, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if info?["code"] as? Int == 200 {
                    if  let  dictARR = info?["result"] as? [NSDictionary]{
                        for  dict in dictARR{
                            let   model = ServiceProvideListModel.mj_object(withKeyValues: dict)
                            self?.modelArr.append(model!)
                        }
                    }
                    self?.addBtn(modelArr: (self?.modelArr)!)
                } else {
                    let  errorShow  =  info!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
    }
    
    //初始化按钮
    func addBtn(modelArr : [ServiceProvideListModel]){
        for i  in  0..<modelArr.count{
          let model = modelArr[i]
          let row = CGFloat(i / 2)
          let col = CGFloat(i % 2)
          let width = CGFloat(screenWidth / 2)
          let button = UIButton.init(frame: CGRect.init(x: col * width , y: row * 80, width: width, height: 80))
          button.setTitle(model.typeName, for: .normal)
          button.setTitleColor(#colorLiteral(red: 0.6745098233, green: 0.7921568751, blue: 0.8549019694, alpha: 1), for: .normal)
          button.setTitleColor(UIColor.white, for: .selected)
          button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
          button.foldTag = model.id as! Int
          button.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
         self.scrollView.addSubview(button)
         self.scrollView.contentSize = CGSize.init(width: screenWidth, height: (row + 1) * 80)
        }
    }
    
    @objc func btnClick(btn : UIButton){
        for  childBtn in self.scrollView.subviews{
            if childBtn is UIButton{
                let tempBtn = childBtn as! UIButton
                if tempBtn.foldTag != btn.foldTag {
                     tempBtn.isSelected = false
                     tempBtn.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
                     self.provideID = btn.foldTag
                }else{
                     btn.isSelected = true
                     btn.backgroundColor = #colorLiteral(red: 0.6745098233, green: 0.7921568751, blue: 0.8549019694, alpha: 1)
                }
            }
        }
    }
}



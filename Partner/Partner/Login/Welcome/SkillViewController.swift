//
//  SkillViewController.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/22.
//

import UIKit

class SkillViewController: InterestedVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //请求标签
    override func getTagList(){
        //保存身份选择
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        self.buttonArr.removeAllObjects()
        NetWorkTool.shareInstance.getTagList(token: access_token, type: 1) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    for dict  in dictArr!{
                        let tagModel = TageModel.mj_object(withKeyValues: dict)
                        self?.buttonArr.add(tagModel?.tagName ?? "")
                    }
                    self?.buttonArr.add("+自定义")
                     self?.addButton()
                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    
                }
            }
        }
    }
    
    
    //完善标签信息
    override func  perfectTagInfo(selectedStr : String){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            return
        }
        NetWorkTool.shareInstance.perfectUsertagInfo(token: access_token, type: 1, tagName: selectedStr) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    self?.performSegue(withIdentifier: "intestedSeguePushID", sender: nil)
                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    
                }
            }
        }
    }
    
    @IBAction func backACtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
    }
  
    


}

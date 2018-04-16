//
//  SkillViewController.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/22.
//

import UIKit

class SkillViewController: InterestedVC {
    var  skillButtonArr = [String]()
//    override func viewWillAppear(_ animated: Bool) {
//        
//        buttonArr.removeAllObjects()
//        self.flowButtonView?.removeFromSuperview()
//        for i in 0..<skillButtonArr.count{
//            let str = skillButtonArr[i]
//            buttonArr.add(str)
//        }
//        getTagList()
//        
//    }
    
    //请求标签
    override func getTagList(){
        //保存身份选择
        guard let access_token = UserDefaults.standard.string(forKey: "temptoken") else{
            return
        }
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
    
    @objc override func editBySelf() -> () {
        self.performSegue(withIdentifier: "skilledID", sender: nil)
    }
    
    @IBAction func nextStepFunc(_ sender: Any) {
        self.selectedArr.removeAllObjects()
        var  nums = 0
        guard self.buttonList != nil else {
            return
        }
        for btn in self.buttonList!{
            let tempBtn =  btn as! UIButton
            if(tempBtn.isSelected){
                nums += 1
                self.selectedArr.add(tempBtn.titleLabel?.text ?? "")
            }
        }
        if(nums > 8){
            self.presentHintMessage(hintMessgae: "请不要选择过多的标签", completion: nil)
            return
        }else if(nums == 0){
            self.presentHintMessage(hintMessgae: "至少选择一种标签", completion: nil)
            return
        }else{
            var  selectedStr = ""
            for  i  in 0..<self.selectedArr.count {
                if i == 0 {
                    selectedStr.append((self.selectedArr[0] as? String)!)
                }else{
                    selectedStr.append(",")
                    selectedStr.append((self.selectedArr[i] as? String)!)
                }
            }
            perfectTagInfo(selectedStr : selectedStr)
        }
    }
    
    
    //完善标签信息
    override func  perfectTagInfo(selectedStr : String){
        guard let access_token = UserDefaults.standard.string(forKey: "temptoken") else{
            return
        }
        NetWorkTool.shareInstance.perfectUsertagInfo(token: access_token, type: 1, tagName: selectedStr) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                   self?.performSegue(withIdentifier: "CooperativedemandVCID", sender: nil)
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

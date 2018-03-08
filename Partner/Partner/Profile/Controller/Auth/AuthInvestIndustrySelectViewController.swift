//
//  AuthInvestIndustrySelectViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/6.
//

import UIKit

class AuthInvestIndustrySelectViewController: InterestedVC {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var skillButtonArr = [String]()
    
    var segue: UIStoryboardSegue?

    override func getTagList() {

        NetWorkTool.shareInstance.getInvestIndustryList { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                let  dictArr = result!["result"] as? [NSDictionary]
                for dict  in dictArr!{
                    let tagModel = TageModel.mj_object(withKeyValues: dict)
                    weakSelf?.buttonArr.add(tagModel as Any)
                }
                weakSelf?.addButton()
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
        var nums = 0
        var selectedStr = ""
        guard self.buttonList != nil else {
            return
        }
        for btn in self.buttonList! {
            let tempBtn = btn as! UIButton
            if(tempBtn.isSelected){
                nums += 1
                self.selectedArr.add(tempBtn.foldTag)
            }
        }
        // limit the count
        if (nums > 8) {
            self.presentHintMessage(hintMessgae: "请不要选择过多的标签", completion: nil)
            return
        } else if (nums == 0){
            self.presentHintMessage(hintMessgae: "至少选择一种标签", completion: nil)
            return
        } else {
            
            for i in 0..<self.selectedArr.count {
                if i == 0 {
                    selectedStr.append("\(self.selectedArr[0])")
                }else{
                    selectedStr.append(",")
                    selectedStr.append("\(self.selectedArr[i])")
                }
            }
        }
        
        guard segue != nil else { return }
        // save string and pass to the source
        let sourceVC = segue?.source
        if sourceVC is AuthApplyUploadViewController {
            let source = sourceVC as! AuthApplyInvestViewController
            source.viewModel.industryIds = selectedStr
            source.invIndustryLbl.text = "\(nums)个"
        } else if sourceVC is AuthResubmitInvestAppliacneViewController {
            let source = sourceVC as! AuthResubmitInvestAppliacneViewController
            source.viewModel.industryIds = selectedStr
            source.invIndustryLbl.text = "\(nums)个"
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    override func addButton() {
        let  tempArr = NSMutableArray.init()
        for i in 0..<self.buttonArr.count{
            let button = UIButton.init()
            let size   = CGSize.init(width: 600, height: 34)
            let   buttonText = (self.buttonArr[i] as! TageModel).induName
            let rectSize  = UIButton.getTextRectSize(text: buttonText! as NSString, font: UIFont.systemFont(ofSize: 16.0), size: size)
            
            button.setTitle(buttonText, for: .normal)
            button.foldTag = (self.buttonArr[i] as! TageModel).id as! Int
            button.frame = CGRect.init(x: 0, y: 0, width: rectSize.width + 48, height: 34)
            button.setTitleColor(#colorLiteral(red: 0.6188373566, green: 0.7203033566, blue: 0.781376183, alpha: 1), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 17
            button.layer.masksToBounds = true
            
            button.layer.borderColor = #colorLiteral(red: 0.6188373566, green: 0.7203033566, blue: 0.781376183, alpha: 1)
            button.layer.borderWidth = 1.0
            
            button.addTarget(self, action: #selector(changeBtnStaus(button:)), for: UIControlEvents.touchUpInside)
            tempArr.add(button)
        }
        
        self.buttonList = tempArr
        addFlowButtonView()
    }

}

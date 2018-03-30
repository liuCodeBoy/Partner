//
//  ProviderSearchCell.swift
//  Partner
//
//  Created by Weslie on 21/03/2018.
//

import UIKit
import Masonry

class ProviderSearchCell: UITableViewCell {
    var diyButtonText = [String]()
    var flowButtonView : CFFlowButtonView?
    var buttonList     : NSMutableArray?
    var selectedArr    = NSMutableArray()
    var buttonArr      : [commListModel]?{
        didSet {
            for childView in self.subviews{
                childView.removeFromSuperview()

            }
            addButton()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //请求标签
//    func getTagList(){
//        //保存身份选择
//        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
//            return
//        }
//        NetWorkTool.shareInstance.getTagList(token: access_token, type: 2) { [weak self](result, error) in
//            if error == nil {
//                // MARK:- judge the return data from server
//                if  result?["code"] as? Int == 200  {
//                    let  dictArr = result!["result"] as? [NSDictionary]
//                    for dict in dictArr! {
//                        let tagModel = TageModel.mj_object(withKeyValues: dict)
//                        self?.buttonArr.add(tagModel?.tagName ?? "")
//                    }
//                    self?.buttonArr.add("+自定义")
//                    self?.addButton()
//                } else {
//                    let errorShow = result!["msg"] as! String
//                    //self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
//
//                }
//            }
//        }
//    }

    
    @IBAction func nextStepBtn(_ sender: Any) {
        var nums = 0
        guard buttonList != nil else { return }
        for btn in self.buttonList! {
            let tempBtn = btn as! UIButton
            if tempBtn.isSelected {
                nums += 1
                self.selectedArr.add(tempBtn.titleLabel?.text ?? "")
            }
        }
        if nums > 8 {
            //presentHintMessage(hintMessgae: "请不要选择过多的标签", completion: nil)
            return
        } else if nums == 0 {
           // presentHintMessage(hintMessgae: "至少选择一种标签", completion: nil)
            return
        } else {
            var selectedStr = ""
            for i in 0..<self.selectedArr.count {
                if i == 0 {
                    selectedStr.append((self.selectedArr[0] as? String)!)
                } else {
                    selectedStr.append(",")
                    selectedStr.append((self.selectedArr[i] as? String)!)
                }
            }
       //     perfectTagInfo(selectedStr: selectedStr)
        }
    }
    

    
    func addButton(){
        let  tempArr = NSMutableArray.init()
        for i in 0..<self.buttonArr!.count{
            let button = UIButton.init()
            let size   = CGSize.init(width: 600, height: 34)
            let   buttonText = self.buttonArr![i].name
            let rectSize  = UIButton.getTextRectSize(text: buttonText! as NSString, font: UIFont.systemFont(ofSize: 16.0), size: size)
            
            button.setTitle(buttonText, for: .normal)
            button.foldTag = self.buttonArr![i].id as! Int
            button.frame = CGRect.init(x: 0, y: 0, width: rectSize.width + 48, height: 34)
           
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.layer.cornerRadius = 17
            button.layer.masksToBounds = true
            button.layer.borderColor = #colorLiteral(red: 0.6188373566, green: 0.7203033566, blue: 0.781376183, alpha: 1)
            button.layer.borderWidth = 1.0
             var isSelected = 0
            for  childModel in buttonArr!{
                if button.foldTag == childModel.id as! Int {
                   isSelected = childModel.isSelected
                }
            }
            if isSelected == 1{
                button.backgroundColor = #colorLiteral(red: 0.5860337019, green: 0.6928295493, blue: 0.7612000704, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
            }else{
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                button.setTitleColor(#colorLiteral(red: 0.5860337019, green: 0.6928295493, blue: 0.7612000704, alpha: 1), for: .normal)
            }
            button.addTarget(self, action: #selector(changeBtnStaus(button:)), for: UIControlEvents.touchUpInside)
            tempArr.add(button)
        }
        
        self.buttonList = tempArr
        addFlowButtonView()
    }
    //设置选择样式
    @objc func changeBtnStaus(button : UIButton) -> () {
        if button.isSelected {
            button.isSelected = false
            button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.5860337019, green: 0.6928295493, blue: 0.7612000704, alpha: 1), for: .normal)
            for  childModel in buttonArr!{
                if button.foldTag == childModel.id as! Int {
                    childModel.isSelected = 0
                }
            }
        }else{
            button.isSelected = true
            button.backgroundColor = #colorLiteral(red: 0.5860337019, green: 0.6928295493, blue: 0.7612000704, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
            for  childModel in buttonArr!{
                if button.foldTag == childModel.id as! Int {
                    childModel.isSelected = 1
                }
            }
        }
    }
    
    
  
    // 设置FlowButtonView
    func addFlowButtonView() -> () {
        // 实例化一个FlowView对象
        let  tempFlowButtonView = CFFlowButtonView.init(initWithButtonList: self.buttonList!)
        self.addSubview(tempFlowButtonView)
        self.flowButtonView = tempFlowButtonView
        self.flowButtonView?.bounces = false
        let width = CGFloat(((self.buttonArr?.count)! / 2 + 1) * 48)
        self.flowButtonView?.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: width )
        self.flowButtonView?.contentSize.width = screenWidth
        
    }
}

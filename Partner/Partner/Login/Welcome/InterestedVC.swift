//
//  InterestedVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/1/15.
//

import UIKit
import Masonry

class InterestedVC: UIViewController {
    var diyButtonText = [String]()
    var flowButtonView : CFFlowButtonView?
    var buttonList     : NSMutableArray?
    var scrollview     : UIScrollView?
    var buttonArr      = NSMutableArray()
    var selectedArr    = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        buttonArr.removeAllObjects()
        flowButtonView?.removeFromSuperview()
        for i in 0..<diyButtonText.count{
             let str = diyButtonText[i]
              buttonArr.add(str)
          }
        getTagList()
    }
 
    //请求标签
    func getTagList(){
        //保存身份选择
        guard let access_token = UserDefaults.standard.string(forKey: "temptoken") else {
            return
        }
        NetWorkTool.shareInstance.getTagList(token: access_token, type: 2) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    for dict in dictArr! {
                        let tagModel = TageModel.mj_object(withKeyValues: dict)
                        self?.buttonArr.add(tagModel?.tagName ?? "")
                    }
                    self?.buttonArr.add("+自定义")
                    self?.addButton()
                } else {
                    let errorShow = result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    
                }
            }
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
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
            presentHintMessage(hintMessgae: "请不要选择过多的标签", completion: nil)
            return
        } else if nums == 0 {
            presentHintMessage(hintMessgae: "至少选择一种标签", completion: nil)
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
            perfectTagInfo(selectedStr: selectedStr)
        }
    }
    
 //完善标签信息
    func perfectTagInfo(selectedStr : String){
        
        guard let access_token = UserDefaults.standard.string(forKey: "temptoken") else {
            return
        }
        
        NetWorkTool.shareInstance.perfectUsertagInfo(token: access_token, type: 2, tagName: selectedStr) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    self?.performSegue(withIdentifier: "intestedSeguePushID", sender: nil)
                  
                } else {
                    let errorShow = result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  let dest = segue.destination as? AddTagBtnVC {
              dest.sourceSegue = segue
        }
     
    }

    func addButton(){
        let  tempArr = NSMutableArray.init()
        for i in 0..<self.buttonArr.count{
            let button = UIButton.init()
            let size   = CGSize.init(width: 600, height: 34)
            let   buttonText = self.buttonArr[i] as! NSString
            let rectSize  = UIButton.getTextRectSize(text: buttonText, font: UIFont.systemFont(ofSize: 16.0), size: size)
            
            button.setTitle(buttonText as String, for: .normal)
            button.frame = CGRect.init(x: 0, y: 0, width: rectSize.width + 48, height: 34)
            button.setTitleColor(#colorLiteral(red: 0.6188373566, green: 0.7203033566, blue: 0.781376183, alpha: 1), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.backgroundColor = UIColor.white
            if (i < self.buttonArr.count - 1){
                button.layer.cornerRadius = 17
                button.layer.masksToBounds = true
                
                button.layer.borderColor = #colorLiteral(red: 0.6188373566, green: 0.7203033566, blue: 0.781376183, alpha: 1)
                button.layer.borderWidth = 1.0
                
            button.addTarget(self, action: #selector(changeBtnStaus(button:)), for: UIControlEvents.touchUpInside)
            }else if(i == self.buttonArr.count - 1){
                changeBorder(btn: button)
                button.addTarget(self, action: #selector(editBySelf), for: UIControlEvents.touchUpInside)
            }
            tempArr.add(button)
        }
       
        self.buttonList = tempArr
        addFlowButtonView()
    }

    
    @objc func editBySelf() -> () {
        
        self.performSegue(withIdentifier: "InterestedID", sender: nil)
        
    }

    // 设置FlowButtonView
    func addFlowButtonView() -> () {
        // 实例化一个FlowView对象
        let  tempFlowButtonView = CFFlowButtonView.init(initWithButtonList: self.buttonList!)
        self.view?.addSubview(tempFlowButtonView)
        self.flowButtonView = tempFlowButtonView
        self.flowButtonView?.bounces = false
        //设置约束，不需要设置高度相关的约束
//        self.flowButtonView?.mas_makeConstraints({ (make) in
//            make?.top.equalTo()(self.view.mas_top)?.offset()(100);
//            make?.left.equalTo()(self.view.mas_left);
//            make?.right.equalTo()(self.view.mas_right);
//        })
        self.flowButtonView?.frame = CGRect.init(x: 0, y: 150, width: screenWidth, height: screenHeight * 0.55 )
        self.flowButtonView?.contentSize.width = screenWidth
  
    }
}

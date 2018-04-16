//
//  MyProjectEditRunStatusViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class MyProjectEditRunStatusViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var projID: Int?
    
    var modelView: ProjectDetialModel = ProjectDetialModel()
    
    var editViewModel: ProjectDetialModel?
    var viewModel: ProjectDetialModel? {
        didSet {
            if let income = viewModel?.projMonthIncome {
                momthlyIncomeLbl.text = "\(income)"
                modelView.projMonthIncome = income
            }
            if let active = viewModel?.projMonthUser {
                monthlyActiveUserLbl.text = "\(active)"
                modelView.projMonthUser = active
            }
            if let total = viewModel?.projTotalUser {
                totalUserLbl.text = "\(total)"
                modelView.projTotalUser = total
            }
            if let desc = viewModel?.projDataRemark {
                inputTF.text = desc
                inputString = desc
                placeholderLbl.isHidden = true
                modelView.projDataRemark = desc
            }
        }
    }

    @IBOutlet weak var momthlyIncomeLbl: UILabel!
    @IBOutlet weak var monthlyActiveUserLbl: UILabel!
    @IBOutlet weak var totalUserLbl: UILabel!
    
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var str: String?
    var inputString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
            // MARK:- save description
            modelView.projDataRemark = inputString
        }
    }
    
    @IBAction func showInputVC(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "InputDetial") as! InputDetialViewController
        vc.keyboardType = UIKeyboardType.numberPad
        // MARK:- save input data
        switch sender.inputTitleID {
        case "MPERSIncome":
            let title = "月收入（元）"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save name
                weakSelf?.modelView.projMonthIncome = Int(vc.inputText!)! as NSNumber
                weakSelf?.momthlyIncomeLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "MPERSActive":
            let title = "月活跃用户量（人）"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save job name
                weakSelf?.modelView.projMonthUser = Int(vc.inputText!)! as NSNumber
                weakSelf?.monthlyActiveUserLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "MPERSTotal":
            let title = "用户总量（人）"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save mail
                weakSelf?.modelView.projTotalUser = Int(vc.inputText!)! as NSNumber
                weakSelf?.totalUserLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        default: break
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load string from source controller, hide placeholder
        if str != nil {
            inputTF.text = str
            placeholderLbl.isHidden = true
            // change limit lbl
            inputString = str!
        }
        
        if editViewModel != nil {
            viewModel = editViewModel
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
       saveRunStatusInfo()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTF.text
    }
    
    func saveRunStatusInfo() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        
        guard let projMonthIncome = modelView.projMonthIncome,
              let projMonthUser = modelView.projMonthUser,
              let projTotalUser = modelView.projTotalUser,
              let projDataRemark = modelView.projDataRemark
        else {
            presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
            return
        }
        weak var weakSelf = self
        presentConfirmationAlert(hint: "确认保存吗？", completion: { (_) in
            NetWorkTool.shareInstance.updateOperationState(token: access_token!,
                                                           id: id,
                                                           projMonthIncome: projMonthIncome as! Int,
                                                           projMonthUser: projMonthUser as! Int,
                                                           projTotalUser: projTotalUser as! Int,
                                                           projDataRemark: projDataRemark)
            { (result, error) in
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    weakSelf?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
        })
        
    }

}

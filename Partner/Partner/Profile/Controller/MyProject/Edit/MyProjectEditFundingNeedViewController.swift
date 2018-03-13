//
//  MyProjectEditFundingNeedViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit
import SCLAlertView

class MyProjectEditFundingNeedViewController: UIViewController, UITextViewDelegate {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var projID: Int?
    
    var modelView: ProjectDetialModel = ProjectDetialModel()
    
    var editViewModel: ProjectDetialModel?
    var viewModel: ProjectDetialModel? {
        didSet {
            // FIXME:- save the currency id to model
            if let currency = viewModel?.currency {
                currencyLbl.text = currency
                
            }
            if let expect = viewModel?.projFinancing {
                expectedFinanceLbl.text = "\(expect)"
                modelView.projFinancing = expect
            }
            if let stock = viewModel?.projShare {
                shareStockLbl.text = "\(stock)"
                modelView.projShare = stock
            }
            if let estimate = viewModel?.projValue {
                estimateLbl.text = "\(estimate)"
                modelView.projValue = estimate
            }
            if let plan = viewModel?.projFundPlan {
                inputTF.text = plan
                inputString = plan
                placeholderLbl.isHidden = true
                modelView.projFundPlan = plan
            }
        }
    }

    var currencyData = [[Int: String]]()
    
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var expectedFinanceLbl: UILabel!
    @IBOutlet weak var shareStockLbl: UILabel!
    @IBOutlet weak var estimateLbl: UILabel!
    
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
            modelView.projFundPlan = inputString
        }
    }
    @IBAction func selectCurrencyClicked(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: currencyLbl, type: .financeCurrency, model: modelView, componentDict: currencyData)
    }
    
    @IBAction func showInputVC(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "InputDetial") as! InputDetialViewController
        vc.keyboardType = UIKeyboardType.numberPad
        // MARK:- save input data
        switch sender.inputTitleID {
        case "MPEFNExpect":
            let title = "期望融资（万）"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save job name
                weakSelf?.modelView.projFinancing = Int(vc.inputText!)! as NSNumber
                weakSelf?.expectedFinanceLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "MPEFNStock":
            let title = "转让股份（%）"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save mail
                weakSelf?.modelView.projShare = Int(vc.inputText!)! as NSNumber
                weakSelf?.shareStockLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        case "MPEFNEstimate":
            let title = "融资前估值（万）"
            vc.navTitle = title
            vc.inputPlaceholder = "请输入\(title)"
            vc.saveClousre = {
                weak var weakSelf = self
                // MARK:- save mail
                weakSelf?.modelView.projValue = Int(vc.inputText!)! as NSNumber
                weakSelf?.estimateLbl.text = vc.inputText
                vc.navigationController?.popViewController(animated: true)
            }
        default: break
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if str != nil {
            inputTF.text = str
            placeholderLbl.isHidden = true
            // change limit lbl
            inputString = str!
        }
        
        if editViewModel != nil {
            viewModel = editViewModel
        }
        
        loadCurrencyInfo()

    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        saveFinanceNeedInfo()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTF.text
    }
    
    func loadCurrencyInfo() {
        // currency data
        NetWorkTool.shareInstance.getCurrencyList { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save identity data into an array
                for dict in result!["result"] as! [[String: AnyObject]] {
                    let id = dict["id"] as! Int
                    let idenName = dict["currName"] as! String
                    let dictElement = [id : idenName]
                    weakSelf?.currencyData.append(dictElement)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    func saveFinanceNeedInfo() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        guard let id = projID else { return }
        
        guard let currencyId = modelView.currencyId,
              let projFinancing = modelView.projFinancing,
              let projShare = modelView.projShare,
              let projValue = modelView.projValue,
              let projFundPlan = modelView.projFundPlan
        else {
            presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
            return
        }
        
        weak var weakSelf = self
        presentConfirmationAlert(hint: "确认保存吗？", completion: { (_) in
            NetWorkTool.shareInstance.updateFinancingNeeds(token: access_token!,
                                                           id: id,
                                                           currencyId: currencyId as! Int,
                                                           projFinancing: projFinancing as! Int,
                                                           projShare: projShare as! Int,
                                                           projValue: projValue as! Int,
                                                           projFundPlan: projFundPlan)
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

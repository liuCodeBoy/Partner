//
//  MyHomePageAddEntrepreneurshipExperienceViewController.swift
//  Partner
//
//  Created by Weslie on 13/02/2018.
//

import UIKit

class MyHomePageAddEntrepreneurshipExperienceViewController: UIViewController, UITextViewDelegate, UIScrollViewDelegate {
    
    var isEdit: Bool = false
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    var modelView: EntrepreneurshipModel? = EntrepreneurshipModel()
    var editViewModel: EntrepreneurshipModel?
    var viewModel: EntrepreneurshipModel? {
        didSet {
            if let id = viewModel?.id {
                modelView?.id = id
            }
            if let projName = viewModel?.entrProjName {
                projNameLbl.text = projName
                modelView?.entrProjName = projName
            }
            if let job = viewModel?.entrRole {
                entreRoleLbl.text = job
                modelView?.entrRole = job
            }
            if let time = viewModel?.entrDate {
                timeLbl.text = time
                modelView?.entrDate = time
            }
            if let industry = viewModel?.entrIndustry {
                belongedLbl.text = industry
                modelView?.entrIndustry = industry
            }
            if let location = viewModel?.entrArea {
                locationLbl.text = location
                modelView?.entrArea = location
            }
            if let count = viewModel?.entrPartnership {
                partnerCountLbl.text = count
                modelView?.entrPartnership = count
            }
            if let scale = viewModel?.entrFinancingScale {
                fundingScaleLbl.text = scale
                modelView?.entrFinancingScale = scale
            }
            if let count = viewModel?.entrTeamNum {
                teamMenberCountLbl.text = count
                modelView?.entrTeamNum = count
            }
            if let full = viewModel?.entrFullTime {
                if full == 1 {
                    isFullTimeBtn.isSelected = true
                } else {
                    isFullTimeBtn.isSelected = false
                }
            }
            if let desc = viewModel?.description {
                str = desc
                modelView?.entrDesc = desc
            }
        }
    }
    
    var financingData = [[Int : String]]()

    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var entreRoleLbl: UILabel!
    @IBOutlet weak var belongedLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var partnerCountLbl: UILabel!
    @IBOutlet weak var teamMenberCountLbl: UILabel!
    @IBOutlet weak var fundingScaleLbl: UILabel!
    @IBOutlet weak var isFullTimeBtn: UIButton!
    
    @IBOutlet weak var deleteOrSaveView: UIView!
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    
    var str: String?
    var inputString: String = "" {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
            // MARK:- save description
            modelView?.entrDesc = inputString
        }
    }
    
    @IBAction func selectJob(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("EntrepreneurshipExperienceAlertSheet", owner: nil, options: nil)?.first as! EntrepreneurshipExperienceAlertSheet
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { role in
            self.modelView?.entrRole = role
            self.entreRoleLbl.text = role
        }
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        
        let picker = Bundle.main.loadNibNamed("EntrepreneurshipTimePicker", owner: nil, options: nil)?.first as! EntrepreneurshipTimePicker
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { (begin, end, time) in
            self.modelView?.beginDate = begin
            self.modelView?.entrDateEnd = end
            self.modelView?.entrDate = time
            self.timeLbl.text = time
        }
    }
    
    @IBAction func selectPopulation(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("PartnerPopulationPicker", owner: nil, options: nil)?.first as! PartnerPopulationPicker
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { count in
            self.modelView?.entrPartnership = count
            self.partnerCountLbl.text = count
        }
    }
    
    @IBAction func selectTeamCount(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("PartnerPopulationPicker", owner: nil, options: nil)?.first as! PartnerPopulationPicker
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { count in
            self.modelView?.entrTeamNum = count
            self.teamMenberCountLbl.text = count
        }
    }
    
    @IBAction func selectFinanceScale(_ sender: UIButton) {
        popupPartnerPicker(bindingLabel: fundingScaleLbl, type: .entrepreneurFuncingScale, model: modelView!, componentDict: financingData)
    }
    @IBAction func ifFullTimeBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // save is full time property
        if sender.isSelected {
            modelView?.entrFullTime = 1
        } else {
            modelView?.entrFullTime = 0
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        saveAndSubmit()
    }

    @IBAction func deleteBtnClicked(_ sender: ShadowButton) {
        deleteExperience()
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
        
        if isEdit {
            deleteOrSaveView.isHidden = false
            saveView.isHidden = true
        } else {
            deleteOrSaveView.isHidden = true
            saveView.isHidden = false
        }
        
        loadAndSavePickerData()
        
        modelView?.entrFullTime = 0

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTF.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! InputDetialViewController
        switch segue.identifier! {
        case "MHPEEProjNameSegue":
            dest.navTitle           = "项目名称"
            dest.inputPlaceholder   = "请输入您的项目名称"
        case "MHPEELocationSegue":
            dest.navTitle           = "所在地"
            dest.inputPlaceholder   = "请输入您的创业所在地"
        case "MHPEEBelongedSegue":
            dest.navTitle           = "所在兴业"
            dest.inputPlaceholder   = "请输入所在兴业"
        default: break
        }
        dest.sourceSegue = segue
    }
    

}

extension MyHomePageAddEntrepreneurshipExperienceViewController {
    
    func loadAndSavePickerData() {
        // financing data
        NetWorkTool.shareInstance.getRoundList { (result, error) in
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
                    let idenName = dict["roundName"] as! String
                    let dictElement = [id : idenName]
                    weakSelf?.financingData.append(dictElement)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    // MARK:- save and request network
    func saveAndSubmit() {
        
        guard let entrProjName      = modelView?.entrProjName,
            let entrRole            = modelView?.entrRole,
            let entrIndustry        = modelView?.entrIndustry,
            let entrArea            = modelView?.entrArea,
            let entrPartnership     = modelView?.entrPartnership,
            let entrTeamNum         = modelView?.entrTeamNum,
            let entrFinancingScale  = modelView?.entrFinancingScale,
            let entrFullTime        = modelView?.entrFullTime
            else {
                presentHintMessage(hintMessgae: "请完善信息后再提交", completion: nil)
                return
        }
        
        guard let entrDate            = modelView?.entrDate,
              let beginDate           = modelView?.beginDate,
              let entrDateEnd         = modelView?.entrDateEnd
            else {
                presentHintMessage(hintMessgae: "请重新输入时间后再提交", completion: nil)
                return
        }
        if isEdit == false {
            NetWorkTool.shareInstance.saveUserEntrepreneurship(token:               access_token!,
                                                               entrProjName:        entrProjName,
                                                               entrRole:            entrRole,
                                                               entrIndustry:        entrIndustry,
                                                               entrArea:            entrArea,
                                                               entrDate:            entrDate,
                                                               beginDate:           beginDate,
                                                               entrDateEnd:         entrDateEnd,
                                                               entrPartnership:     entrPartnership,
                                                               entrTeamNum:         entrTeamNum,
                                                               entrFinancingScale:  entrFinancingScale,
                                                               entrFullTime:        entrFullTime as! Int,
                                                               entrDesc:            entrDate)
            { (result, error) in
                // MARK:- result call back in network request
                
                weak var weakSelf = self
                if error != nil {
                    weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                    print(error as AnyObject)
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data into model
                    weakSelf?.presentHintMessage(hintMessgae: "添加成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
                }
            }
        } else {
            guard let id = viewModel?.id else { return }
            NetWorkTool.shareInstance.updateUserEntrepreneurship(token:             access_token!,
                                                                 id:                id as! Int,
                                                                 entrProjName:      entrProjName,
                                                                 entrRole:          entrRole,
                                                                 entrIndustry:      entrIndustry,
                                                                 entrArea:          entrArea,
                                                                 entrDate:          entrDate,
                                                                 beginDate:         beginDate,
                                                                 entrDateEnd:       entrDateEnd,
                                                                 entrPartnership:   entrPartnership,
                                                                 entrTeamNum:       entrTeamNum,
                                                                 entrFinancingScale:entrFinancingScale,
                                                                 entrFullTime:      entrFullTime as! Int,
                                                                 entrDesc:          entrDate)
            { (result, error) in
                // MARK:- result call back in network request
                weak var weakSelf = self
                if error != nil {
                    weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                    print(error as AnyObject)
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- save data into model
                    weakSelf?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                        weakSelf?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
                }
            }
        }
    }
    
    func deleteExperience() {
        guard let id = viewModel?.id else { return }
        NetWorkTool.shareInstance.deleteUserEntrepreneurship(token: access_token!, id: id as! Int) { (result, error) in
            // MARK:- result call back in network request
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                weakSelf?.presentHintMessage(hintMessgae: "删除成功", completion: { (_) in
                    weakSelf?.navigationController?.popViewController(animated: true)
                })
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
}

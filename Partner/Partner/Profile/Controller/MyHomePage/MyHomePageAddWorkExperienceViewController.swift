//
//  MyHomePageAddWorkExperienceViewController.swift
//  Partner
//
//  Created by Weslie on 13/02/2018.
//

import UIKit

class MyHomePageAddWorkExperienceViewController: UIViewController, UITextViewDelegate {
    
    var isEdit: Bool = false
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var modelView: WorkExperienceModel? = WorkExperienceModel()
    var editViewModel: WorkExperienceModel?
    var viewModel: WorkExperienceModel? {
        didSet {
            if let id = viewModel?.id {
                modelView?.id = id
            }
            if let name = viewModel?.jobCompName {
                companyNameLbl.text = name
                modelView?.jobCompName = name
            }
            if let job = viewModel?.jobName {
                positionLbl.text = job
                modelView?.jobName = job
            }
            if let time = viewModel?.jobOnTime {
                inServiceTimeLbl.text = time
                modelView?.jobOnTime = time
            }
            if let desc = viewModel?.jobDesc {
                str = desc
                modelView?.jobDesc = desc
            }
        }
    }

    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var inServiceTimeLbl: UILabel!
    
    @IBOutlet weak var deleteOrSaveView: UIView!
    @IBOutlet weak var saveView: UIView!
    
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var inputTF: UITextView!
    @IBOutlet weak var inputLimitLbl: UILabel!
    
    
    var str: String?
    var inputString: String? {
        didSet {
            let charCount = Int(inputTF.text.count)
            inputLimitLbl.text = "\(charCount)/500"
            if charCount > 500 {
                presentHintMessage(hintMessgae: "字符不能超过500字", completion: nil)
            }
            // MARK:- save description
            modelView?.jobDesc = inputString
        }
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        let picker = Bundle.main.loadNibNamed("EntrepreneurshipTimePicker", owner: nil, options: nil)?.first as! EntrepreneurshipTimePicker
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { (begin, end, time) in
            self.modelView?.beginDate = begin
            self.modelView?.jobOnTimeEnd = end
            self.modelView?.jobOnTime = time
            self.inServiceTimeLbl.text = time
        }
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        saveAndSubmit()
    }
    @IBAction func deleteBtnClicked(_ sender: ShadowButton) {
        deleteExperience()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load string from source controller, hide placeholder
        if str != nil {
            inputTF.text = str
            placeholderLbl.isHidden = true
            // change limit lbl
            inputString = str!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLbl.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        inputString = inputTF.text
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! InputDetialViewController
        if segue.identifier == "MHPWEComNameSegue" {
            dest.navTitle = "公司名称"
            dest.inputPlaceholder = "请输入公司名称"
        } else if segue.identifier == "MHPWEJobNameSegue" {
            dest.navTitle = "职位"
            dest.inputPlaceholder = "请输入职位"
        }
        dest.sourceSegue = segue
    }

}

extension MyHomePageAddWorkExperienceViewController {
    
    // MARK:- save and request network
    func saveAndSubmit() {
        
        guard let jobCompName   = modelView?.jobCompName,
              let jobName       = modelView?.jobName
            else {
                presentHintMessage(hintMessgae: "请完善信息后再提交", completion: nil)
                return
        }
        
        guard let jobOnTime     = modelView?.jobOnTime,
              let beginDate     = modelView?.beginDate,
              let jobOnTimeEnd  = modelView?.jobOnTimeEnd
            else {
                presentHintMessage(hintMessgae: "请重新输入时间后再提交", completion: nil)
                return
        }
        
        if isEdit == false {
            NetWorkTool.shareInstance.saveUserJob(token:        access_token!,
                                                  jobCompName:  jobCompName,
                                                  jobName:      jobName,
                                                  jobOnTime:    jobOnTime,
                                                  beginDate:    beginDate,
                                                  jobOnTimeEnd: jobOnTimeEnd,
                                                  jobDesc:      inputString)
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
            NetWorkTool.shareInstance.editUserJob(token:        access_token!,
                                                  id:           id as! Int,
                                                  jobCompName:  jobCompName,
                                                  jobName:      jobName,
                                                  jobOnTime:    jobOnTime,
                                                  beginDate:    beginDate,
                                                  jobOnTimeEnd: jobOnTimeEnd,
                                                  jobDesc:      inputString)
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
        NetWorkTool.shareInstance.deleteUserJob(token: access_token!, id: id as! Int) { (result, error) in
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

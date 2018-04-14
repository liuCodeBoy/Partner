//
//  MyHomePageAddEducationExperienceViewController.swift
//  Partner
//
//  Created by Weslie on 13/02/2018.
//

import UIKit

class MyHomePageAddEducationExperienceViewController: UIViewController, UITextViewDelegate {
    
    var isEdit: Bool = false
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var modelView: EducationExperienceModel? = EducationExperienceModel()
    var editViewModel: EducationExperienceModel?
    var viewModel: EducationExperienceModel? {
        didSet {
            if let id = viewModel?.id {
                modelView?.id = id
            }
            if let school = viewModel?.eduSchool {
                schoolLbl.text = school
                modelView?.eduSchool = school
            }
            if let degree = viewModel?.eduDegree {
                degreeLbl.text = degree
                modelView?.eduDegree = degree
            }
            if let time = viewModel?.eduDate {
                timeLbl.text = time
            }
            if let desc = viewModel?.eduDesc {
                str = desc
                modelView?.eduDesc = desc
            }
        }
    }
    
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
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
            modelView?.eduDesc = inputString
        }
    }
    @IBAction func selectDegree(_ sender: UIButton) {
        self.view.endEditing(true)
        let picker = Bundle.main.loadNibNamed("DegreePicker", owner: nil, options: nil)?.first as! DegreePicker
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { degree in
            self.modelView?.eduDegree = degree
            self.degreeLbl.text = degree
        }
    }
    
    @IBAction func selectTime(_ sender: UIButton) {
        self.view.endEditing(true)
        let picker = Bundle.main.loadNibNamed("EntrepreneurshipTimePicker", owner: nil, options: nil)?.first as! EntrepreneurshipTimePicker
        picker.frame = UIScreen.main.bounds
        self.view.addSubview(picker)
        
        // MARK:- receive data from picker view
        picker.saveDataClosure = { (begin, end, time) in
            self.modelView?.beginDate = begin
            self.modelView?.eduDateEnd = end
            self.modelView?.eduDate = time
            self.timeLbl.text = time
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
        case "MHPEduEMajorSegue":
            dest.navTitle           = "学位"
            dest.inputPlaceholder   = "请输入您的学位"
        case "MHPEduESchoolSegue":
            dest.navTitle           = "学校"
            dest.inputPlaceholder   = "请输入您的学校"
        default: break
        }
        dest.sourceSegue = segue
    }

}

extension MyHomePageAddEducationExperienceViewController {
    
    // MARK:- save and request network
    func saveAndSubmit() {
        
        guard let eduSchool = modelView?.eduSchool,
              let eduSpecialty = modelView?.eduSpecialty,
              let beginDate = modelView?.beginDate,
              let eduDateEnd = modelView?.eduDateEnd,
              let eduDate = modelView?.eduDate
            else {
                presentHintMessage(hintMessgae: "请完善信息后再提交", completion: nil)
                return
        }
        
        if isEdit == false {
            NetWorkTool.shareInstance.saveUserEdu(token:        access_token!,
                                                  eduSchool:    eduSchool,
                                                  eduDegree:    modelView?.eduSchool,
                                                  eduSpecialty: eduSpecialty,
                                                  eduDate:      eduDate,
                                                  beginDate:    beginDate,
                                                  eduDateEnd:   eduDateEnd,
                                                  eduDesc:      inputString)
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
            NetWorkTool.shareInstance.editUserEdu(token:        access_token!,
                                                  id:           id as! Int,
                                                  eduSchool:    eduSchool,
                                                  eduDegree:    modelView?.eduSchool,
                                                  eduSpecialty: eduSpecialty,
                                                  eduDate:      eduDate,
                                                  beginDate:    beginDate,
                                                  eduDateEnd:   eduDateEnd,
                                                  eduDesc:      inputString)
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
        NetWorkTool.shareInstance.deleteUserEdu(token: access_token!, id: id as! Int) { (result, error) in
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

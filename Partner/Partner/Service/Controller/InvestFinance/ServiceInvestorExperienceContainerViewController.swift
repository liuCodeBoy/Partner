//
//  MyHomePageSelfExperienceContainerViewController.swift
//  Partner
//
//  Created by Weslie on 07/02/2018.
//

import UIKit

class ServiceInvestorExperienceContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segue: UIStoryboardSegue?
    var id  : Int?
    var entreExpModelArray = [EntrepreneurshipModel]()
    var workExpModelArray = [WorkExperienceModel]()
    var eduExpModelArray = [EducationExperienceModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        entreExpModelArray.removeAll()
        workExpModelArray.removeAll()
        eduExpModelArray.removeAll()
        getEntrepreneurInfo()
    }
    
    // MARK:- down swipe to zoom the header image
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        
        guard segue != nil else { return }
        
        let source = segue?.source as! ServiceInvestorProfileViewController
        if point.y < 0 {
            // down swipe
            source.headerImgHCons.constant = -point.y + 160
            source.headerInfoTopCons.constant = -point.y + 100
            if isIPHONEX {
                source.headerImgHCons.constant += 24
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if entreExpModelArray.count != 0 {
            count += 1
        }
        if workExpModelArray.count != 0 {
            count += 1
        }
        if eduExpModelArray.count != 0 {
            count += 1
        }
        return count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MyHomePageExperiencesTableViewSectionHeaderCell") as! MyHomePageExperiencesTableViewSectionHeaderCell
        switch section {
        case 0:
            header.expTitleLbl.text = "创业经历"
            header.addExpBtn.addTarget(self, action: #selector(addEntrepreneurshipExp), for: .touchUpInside)
        case 1:
            header.expTitleLbl.text = "工作经历"
            header.addExpBtn.addTarget(self, action: #selector(addWorkExp), for: .touchUpInside)
        case 2:
            header.expTitleLbl.text = "教育经历"
            header.addExpBtn.addTarget(self, action: #selector(addEducationExp), for: .touchUpInside)
        default: break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return entreExpModelArray.count
        case 1: return workExpModelArray.count
        case 2: return eduExpModelArray.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageEntrepreneurshipExperienceTableViewCell") as! MyHomePageEntrepreneurshipExperienceTableViewCell
            singleCell.viewModel = entreExpModelArray[indexPath.row]
            singleCell.pushControllerClosure = {
                self.editEntreExp(model: self.entreExpModelArray[indexPath.row])
            }
            cell = singleCell
        case 1:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageWorkExperienceTableViewCell") as! MyHomePageWorkExperienceTableViewCell
            singleCell.viewModel = workExpModelArray[indexPath.row]
            singleCell.pushControllerClosure = {
                self.editWorkExp(model: self.workExpModelArray[indexPath.row])
            }
            cell = singleCell
        case 2:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageEducationExperienceTableViewCell") as! MyHomePageEducationExperienceTableViewCell
            singleCell.viewModel = eduExpModelArray[indexPath.row]
            singleCell.pushControllerClosure = {
                self.editEduExp(model: self.eduExpModelArray[indexPath.row])
            }
            cell = singleCell
        default: break
        }
        return cell
    }
    
    
    
}

extension ServiceInvestorExperienceContainerViewController {
    
    // MARK:- network request
    func getEntrepreneurInfo() {
        guard access_token != nil else {
            self.presentHintMessage(hintMessgae: "您还为登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.getUserHomePageInfo(token: access_token!, userId: id!) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save entre data
                if let dictArray = result!["result"]!["entreList"] {
                    for dict in dictArray as! [[String : AnyObject]] {
                        let model = EntrepreneurshipModel.mj_object(withKeyValues: dict)
                        weakSelf?.entreExpModelArray.append(model!)
                    }
                }
                // TODO:- save work data
                if let dictArray = result!["result"]!["jobList"] {
                    for dict in dictArray as! [[String : AnyObject]] {
                        let model = WorkExperienceModel.mj_object(withKeyValues: dict)
                        weakSelf?.workExpModelArray.append(model!)
                    }
                }
                // TODO:- save edu data
                if let dictArray = result!["result"]!["eduList"] {
                    for dict in dictArray as! [[String : AnyObject]] {
                        let model = EducationExperienceModel.mj_object(withKeyValues: dict)
                        weakSelf?.eduExpModelArray.append(model!)
                    }
                }
                
                weakSelf?.tableView.reloadData()
                
                // TODO:- save moments data
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    // MARK:- push vc functions
    func editEntreExp(model: EntrepreneurshipModel) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.entrepreneurshipExp.rawValue) as! MyHomePageAddEntrepreneurshipExperienceViewController
        vc.isEdit = true
        vc.editViewModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editWorkExp(model: WorkExperienceModel) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.workExp.rawValue) as! MyHomePageAddWorkExperienceViewController
        vc.isEdit = true
        vc.editViewModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func editEduExp(model: EducationExperienceModel) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.educationExp.rawValue) as! MyHomePageAddEducationExperienceViewController
        vc.isEdit = true
        vc.editViewModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addEntrepreneurshipExp() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.entrepreneurshipExp.rawValue) as! MyHomePageAddEntrepreneurshipExperienceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addWorkExp() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.workExp.rawValue) as! MyHomePageAddWorkExperienceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addEducationExp() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryboardID.educationExp.rawValue) as! MyHomePageAddEducationExperienceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


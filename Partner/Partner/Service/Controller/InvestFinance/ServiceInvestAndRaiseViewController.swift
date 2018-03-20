//
//  ServiceInvestAndRaiseViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit
import SCLAlertView

class ServiceInvestAndRaiseViewController: UIViewController {
    
    var modelArr  = [ProjectListModel]()
    var hotInvestorListArr = [HotInvestorListModel]()
    @IBOutlet weak var ServiceTableView: UITableView!
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         getSelectedProject()
         getHotInvestorList()
    }

}

// MARK:- 获取精选项目
extension ServiceInvestAndRaiseViewController{
    func getSelectedProject(){
        NetWorkTool.shareInstance.getSelectedProjectList(token: access_token) { [weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for dict in  dictArr {
                       let model = ProjectListModel.mj_object(withKeyValues: dict)
                        self?.modelArr.append(model!)
                    }
                    self?.ServiceTableView.reloadData()
                }
            }else{
                  SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
    
    
    //getHotInvestorList
    func  getHotInvestorList(){
        NetWorkTool.shareInstance.getHotInvestorList { [weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = HotInvestorListModel.mj_object(withKeyValues: dictArr[i]){
                        self?.hotInvestorListArr.append(statusViewModel)
                }
            }
             self?.ServiceTableView.reloadData()
             }
            }else{
                  SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
}



extension ServiceInvestAndRaiseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return modelArr.count
        case 2: return hotInvestorListArr.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "ServiceInvestAndRaiseHeaderTitleTableViewCell") as! ServiceInvestAndRaiseHeaderTitleTableViewCell
        switch section {
        case 0: return nil
        case 1: header.titleLbl.text = "精选项目"
        case 2: header.titleLbl.text = "热门投资人"
        default: break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceInvestAndRaiseTableViewHeaderCell")
            cell = singleCell!
        case 1:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceProjectBriefTableViewCell") as! ServiceProjectBriefTableViewCell
            if modelArr.count > 0 {
                singleCell.model = modelArr[indexPath.row]
            }
            cell = singleCell
        case 2:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceFounderBriefTableViewCell") as! ServiceFounderBriefTableViewCell
            if hotInvestorListArr.count > 0 {
                singleCell.model = hotInvestorListArr[indexPath.row]
            }
            cell = singleCell
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
            if modelArr.count > 0 {
                let model = modelArr[indexPath.row]
                destVC.projID = model.projectId as? Int
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            break
        case 2:
            let destVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
            if hotInvestorListArr.count > 0 {
                let model = hotInvestorListArr[indexPath.row]
                destVC.id = model.uid as? Int
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            break
            
        default: break
            
        }
    }
}



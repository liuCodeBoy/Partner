//
//  MyProjectEditViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class MyProjectEditViewController: UIViewController {
    
    internal class edited {
        static var members     = false
        static var introduce   = false
        static var analysis    = false
        static var run         = false
        static var funding     = false
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var isEdited = true
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToEditWithoutSave(_ segue: UIStoryboardSegue) { }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
}

extension MyProjectEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let header  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditHeaderTableViewCell")           as! ProjectEditHeaderTableViewCell
            cell = header
        case 1:
            let member  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditMembersBriefTableViewCell")     as! ProjectEditMembersBriefTableViewCell
            cell = member
        case 2:
            let intro   = tableView.dequeueReusableCell(withIdentifier: "ProjectEditIntroductionTableViewCell")     as! ProjectEditIntroductionTableViewCell
            cell = intro
        case 3:
            let market  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditMarketAnalysisTableViewCell")   as! ProjectEditMarketAnalysisTableViewCell
            cell = market
        case 4:
            let run     = tableView.dequeueReusableCell(withIdentifier: "ProjectEditRunStatusTableViewCell")        as! ProjectEditRunStatusTableViewCell
            cell = run
        case 5:
            let funding = tableView.dequeueReusableCell(withIdentifier: "ProjectEditFundingNeedTableViewCell")      as! ProjectEditFundingNeedTableViewCell
            cell = funding
        case 6:
            let plan    = tableView.dequeueReusableCell(withIdentifier: "ProjectEditBusinessPlanBookTableViewCell") as! ProjectEditBusinessPlanBookTableViewCell
            cell = plan
        case 7:
            let confirm = tableView.dequeueReusableCell(withIdentifier: "ProjectEditConfirmButtonTableViewCell")    as! ProjectEditConfirmButtonTableViewCell
            cell = confirm
            
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        switch indexPath.row {
        case 0: return 264
        case 1: return 60
        case 2:
            if edited.introduce == false {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        case 3:
            if edited.analysis == false {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        case 4:
            if edited.run == false {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        case 5:
            if edited.funding == false {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        default: return UITableViewAutomaticDimension
        }
    }
    
    
}

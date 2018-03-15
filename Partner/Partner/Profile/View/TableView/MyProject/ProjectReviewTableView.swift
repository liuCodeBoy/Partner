//
//  ProjectReviewTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectReviewTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var memberModelArray: [ProjectMemberModel] = [ProjectMemberModel]()

    var modelView: ProjectDetialModel? {
        didSet {
            memberModelArray.removeAll()
            if let memberInfoDict = modelView?.membInfos {
                for dict in memberInfoDict {
                    let model = ProjectMemberModel.mj_object(withKeyValues: dict)
                    memberModelArray.append(model!)
                }
            }
            reloadData()
        }
    }
    
    var selectImageClosure: NonParamClosure?
    
    override func awakeFromNib() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else { return }
        
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return memberModelArray.count
        } else if section == 6 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewSectionHeaderTableViewCell") as! ProjectReviewSectionHeaderTableViewCell
        switch section {
        case 1: header.headerLbl.text = "团队介绍"; return header
        case 2: header.headerLbl.text = "项目介绍"; return header
        case 3: header.headerLbl.text = "市场分析"; return header
        case 4: header.headerLbl.text = "运营状况"; return header
        case 5: header.headerLbl.text = "融资需求"; return header
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 || section == 6 {
            return 0.0001
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewBasicInfomationHeaderTableViewCell")           as! ProjectReviewBasicInfomationHeaderTableViewCell
            // TODO:- pass view model to cell
            header.viewModel = modelView
            cell = header
        case 1:
            let member  = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewMemberIntroductionTableViewCell")     as! ProjectReviewMemberIntroductionTableViewCell
            // TODO:- pass avatar image urls to cell
            member.viewModel = memberModelArray[indexPath.row]
            cell = member
        case 2:
            let intro   = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewIntroductionTableViewCell")     as! ProjectReviewIntroductionTableViewCell
            
            // TODO:- pass detial string to cell
            intro.viewModel = modelView
            cell = intro
        case 3:
            let market  = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewMarketAnalysisTableViewCell")   as! ProjectReviewMarketAnalysisTableViewCell
            
            // TODO:- pass detial string to cell
            market.viewModel = modelView
            cell = market
        case 4:
            let run     = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewRunStatusTableViewCell")        as! ProjectReviewRunStatusTableViewCell
            // MARK:- pass detial string to cell
            run.viewModel = modelView
            cell = run
        case 5:
            let funding = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewFundingNeedTableViewCell")      as! ProjectReviewFundingNeedTableViewCell
            // MARK:- pass detial string to cell
            funding.viewModel = modelView
            cell = funding
        case 6:
            if indexPath.row == 0 {
                let plan    = tableView.dequeueReusableCell(withIdentifier: "ProjectEditBusinessPlanBookTableViewCell") as! ProjectEditBusinessPlanBookTableViewCell
                // MARK:- pass plan name to cell
                plan.viewModel = modelView
                cell = plan
            } else if indexPath.row == 1 {
                let confirm = tableView.dequeueReusableCell(withIdentifier: "ProjectReviewConfirmButtonTableViewCell")    as! ProjectReviewConfirmButtonTableViewCell
                // MARK:- pass id to cell
                if let id = modelView?.projectId {
                    confirm.projID = id as? Int
                }
                cell = confirm
            }
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableViewAutomaticDimension
    }
    
}

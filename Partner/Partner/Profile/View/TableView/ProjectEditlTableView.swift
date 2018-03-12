//
//  ProjectDetialTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/10.
//

import UIKit
import SCLAlertView

internal class edited {
    static var members     = false
    static var introduce   = false
    static var analysis    = false
    static var run         = false
    static var funding     = false
    static var membersCount          = ""
    
    static var projIntro             = ""
    static var projHighlights        = ""
    
    static var aimUserGroup          = ""
    static var profitMod             = ""
    static var competitionRival      = ""
    static var ownSource             = ""
    
    static var monthSalary           = ""
    static var monthActivePeople     = ""
    static var totalUser             = ""
    static var runData               = ""
    
    static var fundingMomey          = ""
    static var transferShares        = ""
    static var fundingExpectation    = ""
    static var moneyUsingPlan        = ""
    
    static var planBook              = ""
    
}

typealias NonParamClosure = () -> Void

class ProjectEditlTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- project id
    var projID: Int? {
        didSet {
            loadProjBasicInfo()
        }
    }
    
    var modelView: ProjectDetialModel? {
        didSet {
            reloadData()
        }
    }
    
   

    override func awakeFromNib() {
        
        guard UserDefaults.standard.string(forKey: "token") != nil else { return }
        
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
        
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let header  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditHeaderTableViewCell")           as! ProjectEditHeaderTableViewCell
            header.viewModel = modelView?.basicInfo
            cell = header
        case 1:
            let member  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditMembersBriefTableViewCell")     as! ProjectEditMembersBriefTableViewCell
            member.membersCountLbl.text = edited.membersCount
            cell = member
        case 2:
            let intro   = tableView.dequeueReusableCell(withIdentifier: "ProjectEditIntroductionTableViewCell")     as! ProjectEditIntroductionTableViewCell
            intro.projIntroLbl.text = edited.projIntro
            intro.projHighlightsLbl.text = edited.projHighlights
            if edited.introduce == true {
                intro.addCoverView.isHidden = true
            }
            cell = intro
        case 3:
            let market  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditMarketAnalysisTableViewCell")   as! ProjectEditMarketAnalysisTableViewCell
            market.aimUserGroupLbl.text = edited.aimUserGroup
            market.profitModLbl.text = edited.profitMod
            market.competitionRivalLbl.text = edited.competitionRival
            market.ownSourceLbl.text = edited.ownSource
            if edited.analysis == true {
                market.addCoverView.isHidden = true
            }
            cell = market
        case 4:
            let run     = tableView.dequeueReusableCell(withIdentifier: "ProjectEditRunStatusTableViewCell")        as! ProjectEditRunStatusTableViewCell
            run.monthSalaryLbl.text = edited.monthSalary
            run.monthActivePeopleLbl.text = edited.monthActivePeople
            run.totalUserLbl.text = edited.totalUser
            run.runDataLbl.text = edited.runData
            if edited.run == true {
                run.addCoverView.isHidden = true
            }
            cell = run
        case 5:
            let funding = tableView.dequeueReusableCell(withIdentifier: "ProjectEditFundingNeedTableViewCell")      as! ProjectEditFundingNeedTableViewCell
            funding.fundingMomeyLbl.text = edited.fundingMomey
            funding.transferSharesLbl.text = edited.transferShares
            funding.moneyUsingPlanLbl.text = edited.moneyUsingPlan
            if edited.funding == true {
                funding.addCoverView.isHidden = true
            }
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

// MARK:- network requrest

extension ProjectEditlTableView {
    
    func loadProjBasicInfo() {
        
        guard let id = projID else { return }
        NetWorkTool.shareInstance.getProjectEditInfo(token: access_token!, id: id) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                let basicInfoModel = ProjectBasicInfoModel.mj_object(withKeyValues: result!["result"])
                
                let model = ProjectDetialModel()
                model.basicInfo = basicInfoModel
                weakSelf?.modelView = model
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
}



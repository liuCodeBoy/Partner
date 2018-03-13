//
//  ProjectDetialTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/10.
//

import UIKit
import SCLAlertView

typealias NonParamClosure = () -> Void

let presentImagePickerNotification = "com.Partner.project.businessPlanBook.present"

class ProjectEditlTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var headerModelView: ProjectBasicInfoModel? {
        didSet {
            reloadData()
        }
    }
    
    var modelView: ProjectDetialModel? {
        didSet {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: "ProjectEditHeaderTableViewCell")           as! ProjectEditHeaderTableViewCell
            // TODO:- pass view model to cell 
            header.viewModel = headerModelView
            cell = header
        case 1:
            let member  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditMembersBriefTableViewCell")     as! ProjectEditMembersBriefTableViewCell
            // TODO:- pass avatar image urls to cell
            member.imgURLs = modelView?.membImgUrls
            cell = member
        case 2:
            let intro   = tableView.dequeueReusableCell(withIdentifier: "ProjectEditIntroductionTableViewCell")     as! ProjectEditIntroductionTableViewCell

            // TODO:- pass detial string to cell
            intro.viewModel = modelView
            cell = intro
        case 3:
            let market  = tableView.dequeueReusableCell(withIdentifier: "ProjectEditMarketAnalysisTableViewCell")   as! ProjectEditMarketAnalysisTableViewCell

            // TODO:- pass detial string to cell
            market.viewModel = modelView
            cell = market
        case 4:
            let run     = tableView.dequeueReusableCell(withIdentifier: "ProjectEditRunStatusTableViewCell")        as! ProjectEditRunStatusTableViewCell
            // MARK:- pass detial string to cell
            run.viewModel = modelView
            cell = run
        case 5:
            let funding = tableView.dequeueReusableCell(withIdentifier: "ProjectEditFundingNeedTableViewCell")      as! ProjectEditFundingNeedTableViewCell
            // MARK:- pass detial string to cell
            funding.viewModel = modelView
            cell = funding
        case 6:
            let plan    = tableView.dequeueReusableCell(withIdentifier: "ProjectEditBusinessPlanBookTableViewCell") as! ProjectEditBusinessPlanBookTableViewCell
            // MARK:- pass plan name to cell 
            plan.viewModel = modelView
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
            if modelView?.projDesc == nil &&
                modelView?.projHighlights == nil {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        case 3:
            if modelView?.projUserGroup == nil &&
                modelView?.projProfitModel == nil &&
                modelView?.projCompetitor == nil &&
                modelView?.projResources == nil {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        case 4:
            if modelView?.projMonthIncome == nil && modelView?.projMonthUser == nil &&
                modelView?.projTotalUser == nil &&
                modelView?.projDataRemark == nil {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        case 5:
            if modelView?.currency == nil &&
                modelView?.projFinancing == nil &&
                modelView?.projShare == nil &&
                modelView?.projValue == nil &&
                modelView?.projFundPlan == nil {
                return 135
            } else {
                return UITableViewAutomaticDimension
            }
        default: return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6 {
            // MARK:- select image as business plane book
            NotificationCenter.default.post(name: NSNotification.Name.init(presentImagePickerNotification), object: nil)
        }
    }
    
}

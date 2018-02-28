//
//  ServiceInvestorExperienceContainerViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceInvestorExperienceContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var expCount = [1, 2, 3]
    
    var segue: UIStoryboardSegue?
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
        return 3
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
        case 0: return expCount[0]
        case 1: return expCount[1]
        case 2: return expCount[2]
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageEntrepreneurshipExperienceTableViewCell") as! MyHomePageEntrepreneurshipExperienceTableViewCell
            cell = singleCell
        case 1:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageWorkExperienceTableViewCell") as! MyHomePageWorkExperienceTableViewCell
            cell = singleCell
        case 2:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageEducationExperienceTableViewCell") as! MyHomePageEducationExperienceTableViewCell
            cell = singleCell
        default: break
        }
        return cell
    }
    
    @objc func addEntrepreneurshipExp() {
        
        let vc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.entrepreneurshipExp.rawValue)  as! MyHomePageAddEntrepreneurshipExperienceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addWorkExp() {
        let vc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.workExp.rawValue) as! MyHomePageAddWorkExperienceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func addEducationExp() {
        let vc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: StoryboardID.educationExp.rawValue) as! MyHomePageAddEducationExperienceViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
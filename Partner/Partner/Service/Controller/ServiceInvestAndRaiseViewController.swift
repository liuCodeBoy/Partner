//
//  ServiceInvestAndRaiseViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceInvestAndRaiseViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ServiceInvestAndRaiseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return 5
        case 2: return 8
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "ServiceInvestAndRaiseHeaderTitleTableViewCell") as! ServiceInvestAndRaiseHeaderTitleTableViewCell
        switch section {
        case 0: return nil
        case 1: header.titleLbl.text = "精选项目"
        case 2: header.titleLbl.text = "精选项目"
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
            cell = singleCell
        case 2:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceFounderBriefTableViewCell") as! ServiceFounderBriefTableViewCell
            cell = singleCell
        default: break
        }
        return cell
    }
}

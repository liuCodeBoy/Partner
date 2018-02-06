//
//  MyHomePageViewController.swift
//  Partner
//
//  Created by Weslie on 06/02/2018.
//

import UIKit

class MyHomePageViewController: UIViewController {

    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerImgHCons: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func uploadHeaderBackImgClicked(_ sender: ShadowButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        if isIPHONEX {
            headerImgHCons.constant += 24
        }
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

}

extension MyHomePageViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- down swipe to zoom the header image 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        if point.y < 0 {
            headerImgHCons.constant = -point.y + 200
        } else {
            headerImgHCons.constant = 200
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        } else {
            return 0.00001
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cellView = tableView.dequeueReusableCell(withIdentifier: "MyHomePageAllMomentsTableViewSectionHeaderCell") as! MyHomePageAllMomentsTableViewSectionHeaderCell
            return cellView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageBasicInfomationTableViewCell") as! MyHomePageBasicInfomationTableViewCell
            cell = singleCell
        default: break
        }
        return cell
    }
    
    
}

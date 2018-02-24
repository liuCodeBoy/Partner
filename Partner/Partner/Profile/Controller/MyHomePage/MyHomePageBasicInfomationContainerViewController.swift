//
//  MyHomePageBasicInfomationContainerViewController.swift
//  Partner
//
//  Created by Weslie on 07/02/2018.
//

import UIKit

class MyHomePageBasicInfomationContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var segue: UIStoryboardSegue?
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ProfileInfoModel? {
        didSet {
            if let url = viewModel?.userImgUrl {
                
            }
        }
    }
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
        
        let source = segue?.source as! MyHomePageViewController
        if point.y < 0 {
            // down swipe
            source.headerImgHCons.constant = -point.y + 160
            source.headerInfoTopCons.constant = -point.y + 100
            if isIPHONEX {
                source.headerImgHCons.constant += 24
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageBasicInfomationTableViewCell") as! MyHomePageBasicInfomationTableViewCell
            cell = singleCell
        case 1:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageAllMomentsTableViewSectionHeaderCell") as! MyHomePageAllMomentsTableViewSectionHeaderCell
            cell = singleCell
        default:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "MyHomePageMomentsTableViewCell") as! MyHomePageMomentsTableViewCell
            cell = singleCell
        }
        return cell
    }

}


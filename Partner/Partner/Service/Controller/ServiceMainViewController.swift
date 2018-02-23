//
//  ServiceMainViewController.swift
//  Partner
//
//  Created by Weslie on 31/01/2018.
//

import UIKit

class ServiceMainViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension ServiceMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceMainHeaderTableViewCell") as! ServiceMainHeaderTableViewCell
            cell = singleCell
        case 1:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceMainFounderListTableViewCell") as! ServiceMainFounderListTableViewCell
            cell = singleCell
        case 2:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceMainProviderHeaderTableViewCell")
            cell = singleCell!
        default:
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceMainProviderListTableViewCell") as! ServiceMainProviderListTableViewCell
            cell = singleCell
        }
        return cell
    }
}

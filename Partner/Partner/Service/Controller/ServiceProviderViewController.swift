//
//  ServiceProviderViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceProviderViewController: UIViewController {
    
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

extension ServiceProviderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceProviderCompanyIntroductionTableViewCell") as! ServiceProviderCompanyIntroductionTableViewCell
        return cell
    }
}

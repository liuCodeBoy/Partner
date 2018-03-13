//
//  ServiceMainViewController.swift
//  Partner
//
//  Created by Weslie on 31/01/2018.
//

import UIKit

class ServiceMainViewController: UIViewController {
    @IBOutlet weak var serviceTableView: UITableView!
    
    var modelArr = [ServiceProvideListModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
         getListType()
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
            if modelArr.count > 0 {
                 singleCell.modelArr = modelArr
            }
            singleCell.pushClouse = { (id ,typename) in
                let  showProviderVC = UIStoryboard.init(name: "Service", bundle: nil).instantiateViewController(withIdentifier: "GetProvideVCID") as! GetProvideVC
                showProviderVC.provideID = id
                showProviderVC.showTypeName = typename
                self.navigationController?.pushViewController(showProviderVC, animated: true)
                
            }
         
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


extension  ServiceMainViewController {
    
    func getListType(){
        NetWorkTool.shareInstance.getTypeList(typeCate: 2) { [weak self](info, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if info?["code"] as? Int == 200 {
                    if  let  dictARR = info?["result"] as? [NSDictionary]{
                        for  dict in dictARR{
                            let   model = ServiceProvideListModel.mj_object(withKeyValues: dict)
                            self?.modelArr.append(model!)
                        }
                        self?.serviceTableView.reloadData()
                    }
                } else {
                        let  errorShow  =  info!["msg"] as! String
                        self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                        self?.serviceTableView.reloadData()
                    
                }
            }
        }
    }
    
}

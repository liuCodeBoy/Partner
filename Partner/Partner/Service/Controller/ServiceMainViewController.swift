//
//  ServiceMainViewController.swift
//  Partner
//
//  Created by Weslie on 31/01/2018.
//

import UIKit
import SCLAlertView
class ServiceMainViewController: UIViewController {
    @IBOutlet weak var serviceTableView: UITableView!
    
    var modelArr = [ServiceProvideListModel]()
    var modelSelectedArr = [SelectedProviderModel]()

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
         getListType()
        getSelectedProviderList()
    }

}

extension ServiceMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  modelSelectedArr.count + 3
        
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
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceMainProviderHeaderTableViewCell") as! ServiceMainProviderHeaderTableViewCell
            singleCell.showVC = {(num) in
                let destvC = UIStoryboard.init(name: "ServiceProvider", bundle: nil).instantiateViewController(withIdentifier: "ServiceProviderViewControllerID")
                self.navigationController?.pushViewController(destvC, animated: true)
            }
            cell = singleCell
        default:
            if self.modelSelectedArr.count > 0  && indexPath.row > 2{
                let singleCell = tableView.dequeueReusableCell(withIdentifier: "ServiceMainProviderListTableViewCell") as! ServiceMainProviderListTableViewCell
                let model = modelSelectedArr[indexPath.row - 3]
                singleCell.model = model
                cell = singleCell
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.modelSelectedArr.count > 0  && indexPath.row > 2{
            let destvC = UIStoryboard.init(name: "ServiceProvider", bundle: nil).instantiateViewController(withIdentifier: "ServiceProviderViewControllerID")
            self.navigationController?.pushViewController(destvC, animated: true)
        }
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
    //获取精选服务商
    func getSelectedProviderList(){
        NetWorkTool.shareInstance.getSelectedProviderList { (result, error) in
            weak var  weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                if let dictArr  = result!["result"] as? [NSDictionary] {
                    for dict in dictArr {
                        let model = SelectedProviderModel.mj_object(withKeyValues: dict)
                        weakSelf?.modelSelectedArr.append(model!)
                    }
                    weakSelf?.serviceTableView.reloadData()
                }
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
}

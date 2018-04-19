//
//  IntentionProjectViewController.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit
import SCLAlertView

class IntentionProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var pageNum = 1
    var pageSize = 10
    
    var modelArray: [ProjectBasicInfoModel] = [ProjectBasicInfoModel]() {
        didSet {
            tableView.reloadData()
            if modelArray.count == 0 {
                tableView.addPlaceholder()
            } else {
                tableView.removePlaceholder()
            }
        }
    }
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IntentionProjectTableViewCell") as! IntentionProjectTableViewCell
        cell.viewModel = modelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func loadData() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        NetWorkTool.shareInstance.getIntendedProjectList(token: access_token!, pageNum: pageNum, pageSize: pageSize) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                guard let resultDictArray = result!["result"] as? [String : AnyObject] else { return }
                if let list = resultDictArray["list"] as? [[String : AnyObject]] {
                    for dict in list {
                        let model = ProjectBasicInfoModel.mj_object(withKeyValues: dict)
                        weakSelf?.modelArray.append(model!)
                    }
                }
                
                if weakSelf?.modelArray.count == 0 {
                    weakSelf?.tableView.addPlaceholder()
                } else {
                    weakSelf?.tableView.removePlaceholder()
                }
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
}

//
//  ProjectCollectionViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProjectCollectionViewController: UIViewController {
    
    var pageNum: Int = 1
    var pageSize: Int = 10
    
    @IBOutlet weak var tableView: ProjectCollectionTableView!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadProjData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProjData()
        
        tableView.pushProjReviewClosure = { id in
            let vc = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
            vc.projID = id
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}

extension ProjectCollectionViewController {
    
    func loadProjData() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        NetWorkTool.shareInstance.getMyFocusProjectList(token: access_token!, pageNum: pageNum, pageSize: pageSize) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- remove the former data
                weakSelf?.tableView.modelArray.removeAll()
                // TODO:- save data into model
                let resultDict = result!["result"] as! [String : AnyObject]
                if resultDict["list"] == nil {
                    // FIXME:- show placeholser
                    return
                }
                if let dic = resultDict["list"] as? [[String : AnyObject]], dic.count != 0 {
                    for dict in resultDict["list"] as! [[String : AnyObject]] {
                        let model = ProjectListModel.mj_object(withKeyValues: dict)
                        weakSelf?.tableView.modelArray.append(model!)
                    }
                    
                } else {
                    return
                }
                // TODO:- convert dict to model and assign to view to show
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
}

//
//  MyProjectViewController.swift
//  Partner
//
//  Created by Weslie on 26/01/2018.
//

import UIKit

class MyProjectViewController: UIViewController {
    
    var pageNum: Int = 1
    var pageSize: Int = 10
    
    var projID: Int = 0
        
    var isInvestor: Bool = true
    
    @IBOutlet weak var myProjectTableView: ProjectListTableView!
    @IBOutlet weak var investProjectTableView: ProjectListTableView!
    
    // cover the table view, no proj placeholder
    @IBOutlet weak var placeholderContainerView: UIView!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var createProjBtn: UIButton!
    @IBAction func createProjBtnClicked(_ sender: UIButton) {
        // MARK:- creat a new proj
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "CreateProject") as! MyProjectEditAndCreateViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var intentionBtn: UIButton!
    @IBAction func intentionBtnClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var investorsSelectViewHCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var investorCreateProjBtn: ShadowButton!
    @IBAction func investorCreateProjBtnClicked(_ sender: ShadowButton) {
        investorCreateProjBtn.setSelected()
        investorInvestProjBtn.reverseSelected()
        // show my proj
        myProjectTableView.isHidden     = false
        investProjectTableView.isHidden = true
        createProjBtn.isHidden = false
        intentionBtn.isHidden  = true
    }
    @IBOutlet weak var investorInvestProjBtn: ShadowButton!
    @IBAction func investorInvestProjBtnClicked(_ sender: ShadowButton) {
        investorCreateProjBtn.reverseSelected()
        investorInvestProjBtn.setSelected()
        // show invest proj
        myProjectTableView.isHidden     = true
        investProjectTableView.isHidden = false
        createProjBtn.isHidden = true
        intentionBtn.isHidden  = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isInvestor == true {
            createProjBtn.isHidden = true
            intentionBtn.isHidden  = false
            investorsSelectViewHCons.constant = 70
        } else {
            createProjBtn.isHidden = false
            intentionBtn.isHidden  = true
            investorsSelectViewHCons.constant = 0
        }
        
        loadData()
        
        // MARK:- receive passed proj id to table view
        myProjectTableView.passIDClosure = { id in
            weak var weakSelf = self
            weakSelf?.projID = id
        }
        
        investProjectTableView.passIDClosure = { id in
            weak var weakSelf = self
            weakSelf?.projID = id
        }
        
    }
    
    func loadData() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        // MARK:- load my proj
        NetWorkTool.shareInstance.getMyProjectList(token: access_token!, pageNum: pageNum, pageSize: pageSize) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- remove the former data
                weakSelf?.myProjectTableView.modelArray.removeAll()
                // TODO:- save data into model
                let resultDict = result!["result"] as! [String : AnyObject]
                if resultDict["list"] == nil {
                    // TODO:- no data, show placeholder
                    weakSelf?.placeholderContainerView.isHidden = false
                    return
                }
                weakSelf?.placeholderContainerView.isHidden = true
                // TODO:- convert dict to model and assign to view to show
                for dict in resultDict["list"] as! [[String : AnyObject]] {
                    let model = ProjectListModel.mj_object(withKeyValues: dict)
                    weakSelf?.myProjectTableView.modelArray.append(model!)
                }
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
        // MARK:- load invest proj
        NetWorkTool.shareInstance.getMyInvestProjectList(token: access_token!, pageNum: pageNum, pageSize: pageSize) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- remove the former data
                weakSelf?.investProjectTableView.modelArray.removeAll()
                // TODO:- save data into model
                let resultDict = result!["result"] as! [String : AnyObject]
                if resultDict["list"] == nil {
                    // TODO:- no data, show placeholder
                    weakSelf?.placeholderContainerView.isHidden = false
                    return
                }
                weakSelf?.placeholderContainerView.isHidden = true
                // TODO:- convert dict to model and assign to view to show
                if let resultDict = resultDict["list"] as? [[String : AnyObject]] {
                    for dict in resultDict {
                        let model = ProjectListModel.mj_object(withKeyValues: dict)
                        weakSelf?.investProjectTableView.modelArray.append(model!)
                    }
                }
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MPEDetialInfoSegue" {
            let dest = segue.destination as! MyProjectEditViewController
            dest.projID = projID
        } else if segue.identifier == "MPRDetialInfoSegue" {
            let dest = segue.destination as! MyProjectReviewViewController
            dest.projID = projID
        }
    }

}


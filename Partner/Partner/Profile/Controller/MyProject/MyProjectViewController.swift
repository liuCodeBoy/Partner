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
    
    var isInvestor: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var createProjBtn: UIButton!
    @IBAction func createProjBtnClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var intentionBtn: UIButton!
    @IBAction func intentionBtnClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var investorsSelectViewHCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var investorCreateProjBtn: ShadowButton!
    @IBAction func investorCreateProjBtnClicked(_ sender: ShadowButton) {
        investorCreateProjBtn.setSelected()
        investorInvestProjBtn.reverseSelected()
    }
    @IBOutlet weak var investorInvestProjBtn: ShadowButton!
    @IBAction func investorInvestProjBtnClicked(_ sender: ShadowButton) {
        investorCreateProjBtn.reverseSelected()
        investorInvestProjBtn.setSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
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
    }
    
    func loadData() {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        NetWorkTool.shareInstance.getMyProjectList(token: access_token!, pageNum: pageNum, pageSize: pageSize) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model 
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }

}

extension MyProjectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleProjectTableViewCell") as! SingleProjectTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
}

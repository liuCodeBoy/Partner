//
//  InvestorListVC.swift
//  Partner
//
//  Created by Weslie on 17/03/2018.
//

import UIKit
import MJRefresh
import SCLAlertView

class InvestorListVC: UIViewController {
    var   pageNum  = 1 //标记nextPage 是否为空
    var   nextPage = 1
    
    var modelArr = [HotInvestorListModel]()
    @IBOutlet weak var projectListTableView: UITableView!
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var hotBtn: ShadowButton!
    @IBOutlet weak var newBtn: ShadowButton!
    var order = 2         //排序条件，1热门 2最新
    
    
    @IBAction func hotClicked(_ sender: ShadowButton) {
        hotBtn.setSelected()
        newBtn.reverseSelected()
        order = 1
        
        pageNum  = 1 //标记nextPage 是否为空
        nextPage = 1
        self.modelArr.removeAll()
        // TODO:- reload data
        getProjectList()
        
    }
    @IBAction func newClicked(_ sender: ShadowButton) {
        hotBtn.reverseSelected()
        newBtn.setSelected()
        order = 2
        
        pageNum  = 1 //标记nextPage 是否为空
        nextPage = 1
        self.modelArr.removeAll()
        // TODO:- reload data
        getProjectList()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet(tableView: projectListTableView)
        getProjectList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    
    func loadRefreshComponet(tableView : UITableView) -> () {
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
        
    }
    
    @objc func  endrefresh() -> (){
        getProjectList()
    }
    
    
    
}

extension InvestorListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceFounderBriefTableViewCell") as! ServiceFounderBriefTableViewCell
        if modelArr.count > 0 {
            let model = modelArr[indexPath.row]
            cell.model = model
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController
        if modelArr.count > 0 {
            let model = modelArr[indexPath.row]
//            destVC.projID = model.uid as? Int
//            self.navigationController?.pushViewController(destVC, animated: true)
//            if access_token != nil {
//                NetWorkTool.shareInstance.scanProject(token: access_token!, id: (model.projectId as? Int)!, finished: { (result, error) in
//                    
//                })
//            }
        }
    }
    
    
    func getProjectList(){
        if  self.nextPage == 0 {
            projectListTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
 
        NetWorkTool.shareInstance.getInvestorList(pageNum: pageNum, order: order, type: nil, id: nil, fuzzy: nil) { [weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                let dict  =   result!["result"] as? NSDictionary
                if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
                {
                    if statusViewModel.hasNextPage == 0 {
                        self?.nextPage = 0
                    }else{
                        self?.nextPage = statusViewModel.nextPage as! Int
                    }
                    self?.pageNum += 1
                }
                
                if  let dictArr  =   result!["result"]!["list"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = HotInvestorListModel.mj_object(withKeyValues: dictArr[i]){
                            self?.modelArr.append(statusViewModel)
                        }
                    }
                    self?.projectListTableView.mj_footer.endRefreshing()
                    self?.projectListTableView.reloadData()
                    
                }
                
            }else{
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
}

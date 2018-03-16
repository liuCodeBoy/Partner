//
//  ServiceProviderViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit
import SCLAlertView
import MJRefresh

class ServiceProviderViewController: UIViewController {
    @IBOutlet weak var topScrollView: UIView!
    var modelArr = [SelectedProviderModel]()
    var   pageNum  = 1 //标记nextPage 是否为空
    var   nextPage = 1
    var   newsModelArr = [SelectedProviderModel]()

    @IBOutlet weak var serviceProvideTableView: UITableView!
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
         pageNum  = 1 //标记nextPage 是否为空
         nextPage = 1
        newsModelArr.removeAll()
        getSearchProvider()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet(tableView: serviceProvideTableView)
         getSelectedProviderList()
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
                        weakSelf?.modelArr.append(model!)
                    }
                    weakSelf?.addButton(modelArr: (weakSelf?.modelArr)!)
                }
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
    
    
    func loadRefreshComponet(tableView : UITableView) -> () {
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true

    }
    
    @objc func  endrefresh() -> (){
        getSearchProvider()
    }
    

    
    
    //addButton TO ScrollView
    func addButton(modelArr : [SelectedProviderModel]){
        for i  in  0..<modelArr.count{
            let model = modelArr[i]
            let width = CGFloat((screenWidth - 40) / 3)
            let height = CGFloat(self.topScrollView.frame.height)
            let button = UIButton.init(frame: CGRect.init(x: CGFloat(i) * width + CGFloat(i + 1) * 10 , y: 0, width: width, height: height))
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            button.foldTag = model.providerId as! Int
            if let url = model.imgUrl {
                button.setBackgroundImageFor(.normal, with: URL.init(string: url)!)
            }
            self.topScrollView.addSubview(button)
        }
    }
    
    @objc func btnClick(btn : UIButton){
        let serviceDetialVC = UIStoryboard.init(name: "ServiceProvider", bundle: nil).instantiateViewController(withIdentifier: "ServiceDetialViewControllerID") as! ServiceDetialViewController
        serviceDetialVC.id = btn.foldTag
        self.navigationController?.pushViewController(serviceDetialVC, animated: true)
        
    }

}

extension ServiceProviderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceProviderCompanyIntroductionTableViewCell") as! ServiceProviderCompanyIntroductionTableViewCell
        if newsModelArr.count > 0 {
            let model = newsModelArr[indexPath.row]
            cell.model = model
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newsModelArr.count > 0 {
            //初始化控制器
            let VC  = UIStoryboard.init(name: "ServiceProvider", bundle: nil).instantiateViewController(withIdentifier: "ServiceDetialViewControllerID") as! ServiceDetialViewController
            let model = newsModelArr[indexPath.row]
            VC.id = model.providerId as? Int
            NetWorkTool.shareInstance.scanProvider(id:  (model.providerId as? Int)!, finished: { (result, error) in
                
            })
            self.navigationController?.pushViewController(VC, animated: true)

        }
    }
    
    //浏览服务商
    
    
    //获取服务商信息
    func getSearchProvider(){
        if  self.nextPage == 0 {
            serviceProvideTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        NetWorkTool.shareInstance.searchProvider(pageNum: pageNum, pageSize: 10, fuzzy: nil, type: nil, name: nil) {[weak self](result, error) in
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
                    if statusViewModel.nextPage == 0 {
                            self?.nextPage = 0
                        }else{
                    self?.nextPage = statusViewModel.nextPage as! Int
                        }
                    self?.pageNum += 1
                }
                
                if  let dictArr  =   result!["result"]!["list"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = SelectedProviderModel.mj_object(withKeyValues: dictArr[i]){
                            self?.newsModelArr.append(statusViewModel)
                        }
                    }
                    self?.serviceProvideTableView.reloadData()
                }
                
            }else{
               SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
    }
}

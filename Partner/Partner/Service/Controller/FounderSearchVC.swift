//
//  FounderSearchVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/25.
//


import UIKit
import SCLAlertView
import SDWebImage
import MJRefresh

class FounderSearchVC: UIViewController,UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate{
    
    var searchType = 1
    //1搜索用户 2搜索服务商
    var type : Int?
    //初始化资讯模型数组
    var id : Int?
    var    infoModelArr = [TypeListModel]()
    @IBOutlet weak var searchTextF: UITextField!
    var   pageNum         = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    var   newsModelArr = [HotInvestorListModel]()
    
    @IBOutlet weak var newsListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet(tableView: newsListTableView)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var  fuzzy  : String?
        if textField.text != "" {
            fuzzy = textField.text! + string
        }else{
            fuzzy =  string
        }
        if string.count == 0 && textField.text?.count == 1 {
            fuzzy = ""
        }
        
        self.newsModelArr.removeAll()
        setdeafultStatus()
        getInfoList(type:type, fuzzy: fuzzy)
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextF.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! FounderFliterVC
        destVC.seague = segue
    }
    
    
    
    
    
    func loadRefreshComponet(tableView : UITableView) -> () {
        //默认下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        //上拉刷新
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        tableView.mj_footer.isAutomaticallyHidden = true
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    
    @objc func refresh() -> () {
        self.newsModelArr.removeAll()
        setdeafultStatus()
        getInfoList(type:type, fuzzy: nil)
    }
    @objc func  endrefresh() -> (){
        getInfoList(type:type, fuzzy: nil)
    }
    
    //设置初始状态
    func setdeafultStatus(){
        self.newsModelArr.removeAll()
        pageNum  = 1
        nextPage = 1
    }
    
    @IBAction func popViewControl(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}




extension FounderSearchVC {
    //加载资讯列表
    func  getInfoList(type : Int?, fuzzy : String?){
        if  self.nextPage == 0 {
            newsListTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard access_token != nil else {
            return
        }
        //        var name : String?
        //        if type == nil {
        //            name = fuzzy
        //        }
        //type 1投资行业 2投资轮次
        NetWorkTool.shareInstance.getInvestorList(pageNum: pageNum, order: 2, type: type, id: id, fuzzy: fuzzy) { [weak self](info, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if info?["code"] as? Int == 200 {
                    guard let resultArray = info else{
                        return
                    }
                    let dict  =   resultArray["result"] as? NSDictionary
                    if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
                    {
                        if statusViewModel.nextPage == 0 {
                            self?.nextPage = 0
                        }else{
                            self?.nextPage = statusViewModel.nextPage as! Int
                        }
                        self?.pageNum += 1
                    }
                    
                    if  let  dictARR = info?["result"]!["list"] as? [NSDictionary]{
                        for  dict in dictARR{
                            let   model = HotInvestorListModel.mj_object(withKeyValues: dict)
                            self?.newsModelArr.append(model!)
                        }
                        self?.newsListTableView.mj_header.endRefreshing()
                        self?.newsListTableView.reloadData()
                    }else{
                        SCLAlertView().showError("还未找到相关数据", subTitle: "")
                    }
                } else {
                    let  errorShow  =  info!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelArr.count
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return  90
    //    }
    //
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceFounderBriefTableViewCell", for: indexPath) as! ServiceFounderBriefTableViewCell
        if self.newsModelArr.count > 0  {
            //取出模型
            let  model = newsModelArr[indexPath.row]
            cell.model = model
        }
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let destVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
//        if newsModelArr.count > 0 {
//            let model = newsModelArr[indexPath.row]
//            destVC.id = model.uid as? Int
//        }
//        self.navigationController?.pushViewController(destVC, animated: true)
        if newsModelArr.count > 0 {
            let model = newsModelArr[indexPath.row]
            let  uid = UserDefaults.standard.integer(forKey: "uid")
            if model.uid as? Int == uid {
                let  showProviderVC = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "MyHomePageViewControllerID") as! MyHomePageViewController
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }else{
                let  showProviderVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
                showProviderVC.id = model.uid as? Int
                self.navigationController?.pushViewController(showProviderVC, animated: true)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchTextF.resignFirstResponder()
    }
    
}
//
//  InVestorListVC.swift
//  Partner
//
//  Created by Weslie on 07/03/2018.
//

import UIKit
import MJRefresh

class InVestorListVC: UIViewController {
    
    var projId: Int?
    var isSingle = true
    
    @IBOutlet weak var hostestBtn: ShadowButton!
    @IBOutlet weak var lastedBtn: ShadowButton!
    @IBOutlet weak var investorTableView: UITableView!
    
    var   pageNum  = 1 //标记nextPage 是否为空
    var   nextPage = 1
    var   newsModelArr = [HotInvestorListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveProjectDeliverInfo(_:)), name: NSNotification.Name.init(deliverProjectNotification), object: nil)

    }
    
    @objc func receiveProjectDeliverInfo(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            projId = userInfo["projID"] as? Int
            isSingle = userInfo["isSingle"] as! Bool
        }
        
    }

    @IBAction func popVCCliclk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hotlistClick(_ sender: Any) {
        hostestBtn.setSelected()
        lastedBtn.reverseSelected()
    }
    
    @IBAction func lastedlistClick(_ sender: Any) {
        hostestBtn.reverseSelected()
        lastedBtn.setSelected()
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
      //  getInfoList(type:type, fuzzy: nil)
    }
    @objc func  endrefresh() -> (){
       // getInfoList(type:type, fuzzy: nil)
    }
    
    //设置初始状态
    func setdeafultStatus(){
        self.newsModelArr.removeAll()
        pageNum  = 1
        nextPage = 1
    }
}


extension InVestorListVC {
    //加载资讯列表
    func  getInfoList(type : Int?, fuzzy : String?){
        if  self.nextPage == 0 {
            investorTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        
        func  getHotInvestorList(){
            NetWorkTool.shareInstance.getHotInvestorList { [weak self](result, error) in
                guard error == nil else {
                    return
                }
                if  result?["code"] as? Int == 200  {
                    guard   result != nil else{
                        return
                    }
                    if  let dictArr  =   result!["result"] as? [NSDictionary]{
                        for i in 0..<dictArr.count{
                            if  let statusViewModel = HotInvestorListModel.mj_object(withKeyValues: dictArr[i]){
                                self?.newsModelArr.append(statusViewModel)
                            }
                        }
                        if dictArr.count == 0 {
                            self?.presentHintMessage(hintMessgae: "未查找到数据", completion: nil)
                        }
                    }
                    
                }else{
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
                
            }
        }

        
//        NetWorkTool.shareInstance.getInfoList(type: type, fuzzy: fuzzy, pageNum: pageNum) { [weak self](info, error) in
//            if error == nil {
//                // MARK:- judge the return data from server
//                if info?["code"] as? Int == 200 {
//                    guard let resultArray = info else{
//                        return
//                    }
//                    let dict  =   resultArray["result"] as? NSDictionary
//                    if  let statusViewModel = StatusViewModel.mj_object(withKeyValues: dict)
//                    {
//                        if statusViewModel.nextPage == 0 {
//                            self?.nextPage = 0
//                        }else{
//                            self?.nextPage = statusViewModel.nextPage as! Int
//                        }
//                        self?.pageNum += 1
//                    }
//
//                    if  let  dictARR = info?["result"]!["list"] as? [NSDictionary]{
//                        for  dict in dictARR{
//                            let   model = infoModel.mj_object(withKeyValues: dict)
//                            self?.newsModelArr.append(model!)
//
//                        }
//                        self?.investorTableView.mj_header.endRefreshing()
//                        self?.investorTableView.reloadData()
//                    }
//                } else {
//                    let  errorShow  =  info!["msg"] as! String
//                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
//                }
//            }
//
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfomationCellID", for: indexPath) as! InfomationCell
        if self.newsModelArr.count > 0  {
            //取出模型
            let  model = newsModelArr[indexPath.row]
           // cell.viewModel = model
        }
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.newsModelArr.count > 0  {
//            //取出模型
//            let informationVC  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InfoNewsDetailVCID") as! InfoNewsDetailVC
//            let  model = newsModelArr[indexPath.row]
//            if let urlStr = model.infoUrl{
//                let   url = NSURL.init(string: urlStr)
//                informationVC.url = url
//            }
//            self.navigationController?.pushViewController(informationVC, animated: true)
//        }
        
        // MARK:- if is pushed from seliver project
        if let uid = newsModelArr[indexPath.row].uid as? Int, let projId = self.projId, isSingle == true {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ServiceInvestorProfileViewControllerID") as! ServiceInvestorProfileViewController
            
            vc.id = uid
            vc.isSingle = true
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
}





//
//  searchVC.swift
//  Partner
//
//  Created by Weslie on 20/03/2018.
//

import UIKit
import SDWebImage
import MJRefresh

class searchVC: UIViewController,UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate{

    var searchType = 0
    //1搜索用户 2搜索服务商
    
    //初始化资讯模型数组
    var    infoModelArr = [TypeListModel]()
    @IBOutlet weak var searchTextF: UITextField!
    var   pageNum         = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    var   newsModelArr = [infoModel]()
    
    
    var  type = 0
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
        getInfoList(type:0, fuzzy: fuzzy)
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextF.resignFirstResponder()
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
    
    
    //展示列表
    @objc func   btnClickShowTbaleList(btn : UIButton){
        type  = btn.tag - 9231
        self.newsModelArr.removeAll()
        setdeafultStatus()
        getInfoList(type:type, fuzzy: nil)
    }
    
}




extension searchVC {
    //加载资讯列表
    func  getInfoList(type : Int?, fuzzy : String?){
        if  self.nextPage == 0 {
            newsListTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        guard access_token != nil else {
            return
        }
        NetWorkTool.shareInstance.searchUserList(token: access_token!, type: 1, fuzzy: fuzzy!, circleId: nil) { [weak self](info, error) in
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
                            let   model = infoModel.mj_object(withKeyValues: dict)
                            self?.newsModelArr.append(model!)
                            
                        }
                        self?.newsListTableView.mj_header.endRefreshing()
                        self?.newsListTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfomationCellID", for: indexPath) as! InfomationCell
        if self.newsModelArr.count > 0  {
            //取出模型
            let  model = newsModelArr[indexPath.row]
            cell.viewModel = model
        }
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.newsModelArr.count > 0  {
            //取出模型
            let informationVC  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InfoNewsDetailVCID") as! InfoNewsDetailVC
            let  model = newsModelArr[indexPath.row]
            if let urlStr = model.infoUrl{
                let   url = NSURL.init(string: urlStr)
                informationVC.url = url
            }
            self.navigationController?.pushViewController(informationVC, animated: true)
        }
    }
}

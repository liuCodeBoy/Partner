//
//  ProjectSearchVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/25.
//
import UIKit
import SCLAlertView
import SDWebImage
import MJRefresh

class ProjectSearchVC: UIViewController,UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate{
    
    var searchType = 1
    //1搜索用户 2搜索服务商
    var type : Int? //1行业领域 2城市 3轮次
    var id   : Int?
    //初始化资讯模型数组
    var    infoModelArr = [TypeListModel]()
    @IBOutlet weak var searchTextF: UITextField!
    var   pageNum         = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    var   newsModelArr = [ProjectListModel]()
    
    @IBOutlet weak var newsListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRefreshComponet(tableView: newsListTableView)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let fuzzy = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        self.newsModelArr.removeAll()
        setdeafultStatus()
        getInfoList(type:type, fuzzy: fuzzy)
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextF.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ProjectFliterVC
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




extension ProjectSearchVC {
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
        NetWorkTool.shareInstance.getProjectList(token: access_token, order: 2, type: type, id: id, fuzzy: fuzzy, pageNum: pageNum) { [weak self](info, error) in
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
                            let   model = ProjectListModel.mj_object(withKeyValues: dict)
                            self?.newsModelArr.append(model!)
                        }
                        self?.newsListTableView.mj_header.endRefreshing()
                        self?.newsListTableView.reloadData()
                    }else{
                      //  SCLAlertView().showError("还未找到相关数据", subTitle: "")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceProjectBriefTableViewCell", for: indexPath) as! ServiceProjectBriefTableViewCell
        if self.newsModelArr.count > 0  {
            //取出模型
            let  model = newsModelArr[indexPath.row]
            cell.model = model
        }
        return  cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if newsModelArr.count > 0 {
            //初始化控制器
            let destVC = UIStoryboard.init(name: "MyProject", bundle: nil).instantiateViewController(withIdentifier: "MyProjectReview") as! MyProjectReviewViewController

            let model = newsModelArr[indexPath.row]
            destVC.projID = model.projectId as? Int
            self.navigationController?.pushViewController(destVC, animated: true)
            if access_token != nil {
                NetWorkTool.shareInstance.scanProject(token: access_token!, id: (model.projectId as? Int)!, finished: { (result, error) in
                    
                })
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchTextF.resignFirstResponder()
    }
    
}

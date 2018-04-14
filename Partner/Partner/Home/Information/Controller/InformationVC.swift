//
//  InformationVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/5.
//

import UIKit
import SDWebImage
import MJRefresh

class InformationVC: UIViewController ,UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate{
    //初始化资讯模型数组
    var    infoModelArr = [TypeListModel]()
    @IBOutlet weak var InformationChildsView: UIScrollView!
    @IBOutlet weak var scrollH: NSLayoutConstraint!
    @IBOutlet weak var searchTextF: UITextField!
    var   pageNum         = 1
    //标记nextPage 是否为空
    var   nextPage = 1
    var   newsModelArr = [infoModel]()

    
    var  type = 0
    @IBOutlet weak var newsListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoList(type:type, fuzzy: nil)
        getTypeList()
        loadRefreshComponet(tableView: newsListTableView)
    }


    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let fuzzy = (currentText as NSString).replacingCharacters(in: range, with: string)
        if fuzzy == "" {
            scrollH.constant = 100
        }else{
            scrollH.constant = 0
        }
      self.newsModelArr.removeAll()
      setdeafultStatus()
      getInfoList(type:0, fuzzy: fuzzy)
      return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextF.resignFirstResponder()
    }
    

    
    
    
    //初始化scrollView
    func  initScroll(){
          self.InformationChildsView.showsHorizontalScrollIndicator = false
          let modelCount  = infoModelArr.count
          self.InformationChildsView.contentSize.width = CGFloat(modelCount * 110)
        for i  in 0..<modelCount {
            //取出模型
            let model = infoModelArr[i]
            let  x  = CGFloat(i)  * 100 + CGFloat(i + 1)  * 10
            let btn = UIButton.init(frame: CGRect.init(x: x, y: 0, width: 100, height: 100))
            btn.contentHorizontalAlignment = .center
            btn.contentVerticalAlignment   = .center
            btn.layer.cornerRadius = 5
            btn.clipsToBounds = true
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.setTitle(model.typeName, for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.backgroundColor =  UIColor.blue
            btn.addTarget(self, action: #selector(btnClickShowTbaleList(btn:)), for: .touchUpInside)
            btn.tag = Int(truncating: model.typeId!) + 9231
            if let imageUrl  = model.imgUrl {
            btn.setBackgroundImageFor(.normal, with:URL.init(string: imageUrl)!)
            }
              self.InformationChildsView.addSubview(btn)
        }
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




extension InformationVC {
    //资讯类型列表（info/type/list）
    func getTypeList(){
        self.newsModelArr.removeAll()
        setdeafultStatus()
        //TypeListModel
        NetWorkTool.shareInstance.getTypeList {[weak self](result, error) in
            guard error == nil else {
                return
            }
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for i in 0..<dictArr.count{
                        if  let statusViewModel = TypeListModel.mj_object(withKeyValues: dictArr[i]){
                            self?.infoModelArr.append(statusViewModel)
                        }
                    }
                    self?.initScroll()
                }
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    //加载资讯列表
    func  getInfoList(type : Int?, fuzzy : String?){
        if  self.nextPage == 0 {
            newsListTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
     
         NetWorkTool.shareInstance.getInfoList(type: type, fuzzy: fuzzy, pageNum: pageNum) { [weak self](info, error) in
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
            if let id  = model.infoId{
                NetWorkTool.shareInstance.apiScan(id: Int(truncating: id), finished: { (result, error) in
                    
                })
            }
            self.navigationController?.pushViewController(informationVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

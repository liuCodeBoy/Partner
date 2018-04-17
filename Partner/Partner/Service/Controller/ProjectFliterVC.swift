//
//  ProjectFliterVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/25.
//

import UIKit
class ProjectFliterVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var serviceListTabview: UITableView!
    @IBOutlet weak var restartBtn: ShadowButton!
    @IBOutlet weak var sureBtn: ShadowButton!
    
    var  type = 1
    var  headerArr = ["投资行业","城市","轮次"]
    var  rowArr = [Int]()
    var  commentList = [[commListModel]]()
    var  buttonArr = [UIButton]()
    var seague : UIStoryboardSegue?
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<3{
            let button = UIButton.init(frame: CGRect.init(x: screenWidth - 100, y: 15, width: 100, height: 30))
            button.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "up_arrow"), for: .selected)
            button.addTarget(self, action: #selector(self.changeStatus(btn:)), for: .touchUpInside)
            self.buttonArr.append(button)
        }
        getInvestIndustryList()
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func restartClick(_ sender: Any) {
        clearAllSelected()
    }
    
    @IBAction func providerTypeClick(_ sender: Any) {
        var count = 0
        var id :Int?
        if seague != nil {
            let sourceVC = seague?.source as! ProjectSearchVC
            for  i in 0..<commentList.count{
                let childArr = commentList[i]
                for model in childArr{
                    if model.isSelected == 1 {
                        count += 1
                        type = i + 1
                        id = model.id as? Int
                    }
                }
            }
            if count > 1{
                self.presentHintMessage(hintMessgae: "最多只能选择一个标签", completion: { (action) in
                })
            }else if count == 1 {
                sourceVC.newsModelArr.removeAll()
                sourceVC.pageNum  = 1
                sourceVC.nextPage = 1
                sourceVC.id = id
                sourceVC.getInfoList(type: type, fuzzy: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func clearAllSelected(){
        for  childArr in commentList{
            for model in childArr{
                if model.isSelected == 1 {
                    model.isSelected = 0
                }
            }
        }
        serviceListTabview.reloadData()
    }
}

extension ProjectFliterVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowArr[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowArr.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 60))
        let cityLab = UILabel.init(frame: CGRect.init(x: 20, y: 15, width: 150, height: 30))
        let button = self.buttonArr[section]
        button.foldTag = section
        if headerArr.count > 0{
            cityLab.text = headerArr[section]
        }
        view.addSubview(cityLab)
        view.addSubview(button)
        return view
        
    }
    
    //change section status
    @objc func  changeStatus(btn : UIButton){
        let section = btn.foldTag
        if btn.isSelected == true {
            rowArr[section] = 0
            btn.isSelected = false
        }else{
            rowArr[section] = 1
            btn.isSelected = true
        }
        self.serviceListTabview.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderSearchCellID", for: indexPath) as! ProviderSearchCell
        if  commentList.count >  0 {
            cell.buttonArr = commentList[indexPath.section]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.commentList.count > 0 ? CGFloat((self.commentList[indexPath.section].count / 2 + 1) * 48) : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
}

extension ProjectFliterVC {
    //search getCommunityCityList
    func getInvestIndustryList(){
//        guard access_token != nil else{
//            return
//        }
        NetWorkTool.shareInstance.getInvestIndustryList { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    var  commentArr = [commListModel]()
                    for dict in dictArr! {
                        let model = commListModel.mj_object(withKeyValues: dict)
                        model?.name = model?.induName
                        commentArr.append(model!)
                        }
                    self?.commentList.append(commentArr)
                    }
                    self?.getProjectCityList()
                    self?.rowArr.append(0)
                    self?.serviceListTabview.reloadData()
                } else {
                    //  let errorShow = result!["msg"] as! String
                    //self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
            }
        }
    
    //
    func getRoundList(){
        NetWorkTool.shareInstance.getRoundList { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    var  commentArr = [commListModel]()
                    for dict in dictArr! {
                        let model = commListModel.mj_object(withKeyValues: dict)
                        model?.name = model?.roundName
                        commentArr.append(model!)
                    }
                    self?.commentList.append(commentArr)
                }
                self?.rowArr.append(0)
                self?.serviceListTabview.reloadData()
            } else {
                //  let errorShow = result!["msg"] as! String
                //self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    func getProjectCityList(){
        NetWorkTool.shareInstance.getProjectCityList { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    var  commentArr = [commListModel]()
                    for dict in dictArr! {
                        let model = commListModel.mj_object(withKeyValues: dict)
                        model?.name = model?.cityName
                        commentArr.append(model!)
                    }
                    self?.commentList.append(commentArr)
                }
                self?.rowArr.append(0)
                  self?.getRoundList()
                self?.serviceListTabview.reloadData()
            } else {
                //  let errorShow = result!["msg"] as! String
                //self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
    }
    
    
    
}

//
//  SearchFliterVC.swift
//  Partner
//
//  Created by Weslie on 21/03/2018.
//

import UIKit

class SearchFliterVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
 
    
    @IBOutlet weak var serviceListTabview: UITableView!
    @IBOutlet weak var providerComunityBtn: ShadowButton!
    @IBOutlet weak var providerTypeBtn: ShadowButton!
    
    @IBOutlet weak var noLimitedBtn: ShadowButton!
    @IBOutlet weak var restartBtn: ShadowButton!
    @IBOutlet weak var sureBtn: ShadowButton!
    
    var  type = 1
    var  headerArr = [String]()
    var  rowArr = [Int]()
    var  commentList = [[commListModel]]()
    var  buttonArr = [UIButton]()
    var seague : UIStoryboardSegue?
    override func viewDidLoad() {
        super.viewDidLoad()
       getCommunityCityList()
    }
    
    @IBAction func providerComunityClick(_ sender: Any) {
        type = 1
        rowArr.removeAll()
        headerArr.removeAll()
        buttonArr.removeAll()
        commentList.removeAll()
        getCommunityCityList()
        providerComunityBtn.setSelected()
        providerTypeBtn.reverseSelected()
        noLimitedBtn.setTitle("全部社区", for: .normal)
        noLimitedBtn.setTitle("全部社区", for: .selected)

    }
    
    @IBAction func ProviderTypeClick(_ sender: Any) {
        type = 2
        rowArr.removeAll()
        headerArr.removeAll()
        buttonArr.removeAll()
        commentList.removeAll()
        getServiceTypeList()
        providerTypeBtn.setSelected()
        providerComunityBtn.reverseSelected()
        noLimitedBtn.setTitle("全部类型", for: .normal)
        noLimitedBtn.setTitle("全部类型", for: .selected)
    }

    @IBAction func restartClick(_ sender: Any) {
            clearAllSelected()
    }
    
    @IBAction func noLimiteClick(_ sender: ShadowButton) {
        if sender.isSelected == true {
            sender.reverseSelected()
        }else{
            sender.setSelected()
            clearAllSelected()
        }
         sender.isSelected = !sender.isSelected
    }
    
    @IBAction func providerTypeClick(_ sender: Any) {
        var count = 0
        var fuzzy :String?
        if seague != nil {
            let sourceVC = seague?.source as! searchVC
            for  childArr in commentList{
                for model in childArr{
                    if model.isSelected == 1 {
                        count += 1
                        fuzzy = model.name != nil ? model.name : model.typeName
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
                sourceVC.getInfoList(type: type, fuzzy: fuzzy)
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

extension SearchFliterVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowArr[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerArr.count
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
        cell.buttonArr = commentList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  CGFloat((self.commentList[indexPath.section].count / 2 + 1) * 48)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 0.01
    }
    

}

extension SearchFliterVC {
    //search getCommunityCityList
    func getCommunityCityList(){
        guard access_token != nil else{
            return
        }
        NetWorkTool.shareInstance.getCommunityCityList(token: access_token!) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    for dict in dictArr! {
                        if  let cityName = dict["name"] {
                            self?.headerArr.append(cityName as! String)
                        }
                        var  commentArr = [commListModel]()
                        if let comm  = dict["commList"]  as? [NSDictionary]{
                            for dict in comm {
                                let model = commListModel.mj_object(withKeyValues: dict)
                                commentArr.append(model!)
                            }
                        }
                        self?.commentList.append(commentArr)
                        self?.rowArr.append(0)
                        let button = UIButton.init(frame: CGRect.init(x: screenWidth - 100, y: 15, width: 100, height: 30))
                        button.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
                        button.setImage(#imageLiteral(resourceName: "up_arrow"), for: .selected)
                        button.addTarget(self, action: #selector(self?.changeStatus(btn:)), for: .touchUpInside)
                        self?.buttonArr.append(button)
                    }
                    self?.serviceListTabview.reloadData()
                } else {
                  //  let errorShow = result!["msg"] as! String
                 //self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    
                }
            }
        }
    }
    
  //
    func getServiceTypeList(){
        NetWorkTool.shareInstance.getServiceTypeList() { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if  result?["code"] as? Int == 200  {
                    let  dictArr = result!["result"] as? [NSDictionary]
                    for dict in dictArr! {
                        if  let cityName = dict["name"] {
                            self?.headerArr.append(cityName as! String)
                        }
                        var  commentArr = [commListModel]()
                        if let comm  = dict["children"]  as? [NSDictionary]{
                            for dict in comm {
                                let model = commListModel.mj_object(withKeyValues: dict)
                                model?.name = model?.typeName
                                commentArr.append(model!)
                            }
                        }
                        self?.commentList.append(commentArr)
                        self?.rowArr.append(0)
                        let button = UIButton.init(frame: CGRect.init(x: screenWidth - 100, y: 15, width: 100, height: 30))
                        button.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
                        button.setImage(#imageLiteral(resourceName: "up_arrow"), for: .selected)
                        button.addTarget(self, action: #selector(self?.changeStatus(btn:)), for: .touchUpInside)
                        self?.buttonArr.append(button)
                    }
                    self?.serviceListTabview.reloadData()
                } else {
                    //  let errorShow = result!["msg"] as! String
                    //self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    
                }
            }
        }
    }
    
}

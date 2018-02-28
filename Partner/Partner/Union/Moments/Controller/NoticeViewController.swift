//
//  NoticeViewController.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/28.
//

import UIKit

class NoticeViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var userTableView: UITableView!
    var  modelArr = [NoticeInfoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.delegate = self
        userTableView.dataSource = self
        loadNotice()
    }
    
    
    
    

    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //网络请求
    func loadNotice() -> () {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.getNoticeApiList(token: access_token) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr  =   result!["result"] as? [NSDictionary]{
                    for dict in dictArr{
                        if  let statusViewModel = NoticeInfoModel.mj_object(withKeyValues: dict){
                            self?.modelArr.append(statusViewModel)
                        }
                    }
                    self?.userTableView.reloadData()
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
}


extension NoticeViewController {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCellID", for: indexPath) as! NoticeListCell
        if  modelArr.count > 0 {
            cell.viewModel = modelArr[indexPath.row]
        }
        
        return cell
    }

}


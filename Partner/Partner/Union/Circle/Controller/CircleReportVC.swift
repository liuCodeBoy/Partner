//
//  CircleReportVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit

class CircleReportVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var reportTableview: UITableView!
    var  reportArrModelArr = [reportReasonModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getReportList()
        // Do any additionl setup after loading the view.
    }

    @IBAction func dismissVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func  getReportList(){
        NetWorkTool.shareInstance.getReportReasonListinviteJoin { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
                }
                if  let dictArr =   result!["result"] as? [NSDictionary]{
                        for dict in dictArr{
                            if  let statusViewModel = reportReasonModel.mj_object(withKeyValues: dict){
                                self?.reportArrModelArr.append(statusViewModel)
                            }
                        }
                        self?.reportTableview.reloadData()
            }else{
                let  errorShow  =  result!["msg"] as! String
                self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
            }
        }
   }
 }
}


extension  CircleReportVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let  numb = reportArrModelArr.count >  0  ? reportArrModelArr.count : 0
        return numb
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let   cellID = "CircleReportVCID"
        var    cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if  cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CircleReportVCID")
        }
        if reportArrModelArr.count > 0{
            let  model = reportArrModelArr[indexPath.row]
            cell?.textLabel?.text = model.reaContent
        }
        cell?.accessoryType = .disclosureIndicator
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取出模型
        guard  reportArrModelArr.count  > 0 else{
            return
        }
        let model = reportArrModelArr[indexPath.row]
        self.presentAlert(title: "确认举报", hint: "", confirmTitle: "确定", cancelTitle: "取消", confirmation: { (action) in
            self.report(reaId:model.id as! Int)
            }, cancel: nil)

    }
    
    
    //举报函数
    func  report(reaId : Int){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else{
            self.presentHintMessage(hintMessgae: "您尚未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.report(token: access_token, repoType: 3, reaId: reaId) { [weak self](result, error) in
            if  result?["code"] as? Int == 200  {
                guard   result != nil else{
                    return
              }
            self?.presentHintMessage(hintMessgae:  "举报成功", completion: { (action) in
                    self?.navigationController?.popViewController(animated: true)
             })
            }else{
            let  errorShow  =  result!["msg"] as! String
            self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                }
        }
    }
    
    
    
}

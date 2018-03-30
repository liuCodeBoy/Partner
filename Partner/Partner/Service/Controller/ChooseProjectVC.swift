//
//  ChooseProjectVC.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/3/29.
//

import UIKit
import MJExtension

class ChooseProjectVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userId : Int?
    var project: Int?
    @IBOutlet weak var projectTableView: UITableView!
    var projectModelArr = [ProjectListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChooseProject()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectModelArr.count
    }
    @IBAction func popSelf(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectChooseCellID", for: indexPath) as! ProjectChooseCell
        if projectModelArr.count > 0{
             let model = projectModelArr[indexPath.row]
            if model.isSelected == nil {
                model.isSelected = false
            }
             cell.viewModel = model
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetModel()
        if projectModelArr.count > 0{
            let model = projectModelArr[indexPath.row]
            model.isSelected = true
            self.project = model.projectId as? Int
            self.projectTableView.reloadData()
        }
    }
    
    //还原模型默认属性
    func resetModel(){
        for model in projectModelArr{
            model.isSelected = false
        }
        self.projectTableView.reloadData()
    }
    
    @IBAction func deliverAction(_ sender: Any) {
        deliverProject()
    }
    
    func deliverProject(){
        guard access_token != nil else {
            return
        }
        
        NetWorkTool.shareInstance.deliverProject(token: access_token!, userId: self.userId!, projectIds: self.project!) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if result?["code"] as? Int == 200 {
                    let destVC = UIStoryboard.init(name: "InvestFinance", bundle: nil).instantiateViewController(withIdentifier: "DeliverResultVCID")
                    self?.navigationController?.pushViewController(destVC, animated: true)
                } else {
                    //let  errorShow  =  result!["msg"] as! String
                    return
                }
            }else{
                //                print(error)
            }
        }
    }
    
    
    func loadChooseProject(){
        guard access_token != nil else {
            return
        }
        NetWorkTool.shareInstance.getMyDeliverProjectList(token: access_token!) { [weak self](result, error) in
            if error == nil {
                // MARK:- judge the return data from server
                if result?["code"] as? Int == 200 {
                    guard   result != nil else{
                        return
                    }
                    if let dictArr = result!["result"] as? [NSDictionary]{
                        for dict in dictArr{
                          if let projectModel = ProjectListModel.mj_object(withKeyValues: dict){
                            self?.projectModelArr.append(projectModel)
                            }
                        }
                        self?.projectTableView.reloadData()
                    }

                } else {
                    let  errorShow  =  result!["msg"] as! String
                    self?.presentHintMessage(hintMessgae: errorShow, completion: nil)
                    return
                }
            }else{
                //                print(error)
            }
        }
    }

}

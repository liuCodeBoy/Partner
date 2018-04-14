//
//  ProjectEditTeamMemberTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/12.
//

import UIKit
import SCLAlertView

class ProjectEditTeamMemberTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- project id
    var projID: Int?
    var status: Int? {
        didSet {
            if status != 0 {
                self.allowsSelection = false
            }
        }
    }
    
    var passIDClosure: ((_ memberID: Int) -> Void)?
    
    var modelArray: [ProjectMemberModel] = [ProjectMemberModel]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectEditSingleTeamMemberTableViewCell") as! ProjectEditSingleTeamMemberTableViewCell
        cell.viewModel = modelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
//        let projID = modelArray[indexPath.row].id as! Int
        let memberID = modelArray[indexPath.row].id as! Int
        
        if passIDClosure != nil {
            passIDClosure!(memberID)
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    //MARK: - left slide to delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //TODO: remove form data source
        if editingStyle == .delete {
            // MARK:- post request to server
            
            deleteMember(memberId: modelArray[indexPath.row].id as! Int)
            
            modelArray.remove(at: indexPath.row)
            
            tableView.reloadData()
            //            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            
        }
        
    }
    
    
}

extension ProjectEditTeamMemberTableView {
    
    func loadMemberdata() {
        
        modelArray.removeAll()
        
        guard UserDefaults.standard.string(forKey: "token") != nil else { return }
        guard let projectId = projID else { return }
        
        NetWorkTool.shareInstance.getMemberList(token: access_token!, projectId: projectId) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                // TODO:- save data into model
                guard let resultDictArray = result!["result"] as? [[String : AnyObject]] else { return }
                for dict in resultDictArray {
                    let model = ProjectMemberModel.mj_object(withKeyValues: dict)
                    weakSelf?.modelArray.append(model!)
                }
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
        
    }
    
    // MARK:- delete member
    func deleteMember(memberId: Int) {
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            return
        }
        guard let id = projID else { return }
        
        NetWorkTool.shareInstance.deleteMember(token: access_token!, id: id, memberId: memberId) { (result, error) in
            if error != nil {
                SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                return
            }
            if result!["code"] as! Int == 200 {
                SCLAlertView().showSuccess("删除成功", subTitle: "")
                
            } else {
                SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
            }
        }
        
    }
    
}



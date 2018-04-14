//
//  ProjectListTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/10.
//

import UIKit
import SCLAlertView

let passProjectIDNOtification = "com.Partner.projectID.pass"

class ProjectListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var passIDClosure: ((_ projID: Int) -> Void)?
    
    var modelArray: [ProjectListModel] = [ProjectListModel]() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleProjectTableViewCell") as! SingleProjectTableViewCell
        cell.viewModel = modelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let id = modelArray[indexPath.row].projectId as! Int
        
        let status = modelArray[indexPath.row].status as! Int
        // 项目状态，0未融资 1审核中 2通过 3审核不通过
        if status == 1 {
            SCLAlertView().showNotice("审核中无法查看", subTitle: "")
            return nil
        }
        
        if passIDClosure != nil {
            passIDClosure!(id)
        }
        
        return indexPath
    }
    
}


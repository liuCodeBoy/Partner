//
//  ProjectListTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/10.
//

import UIKit

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
        
        if passIDClosure != nil {
            passIDClosure!(id)
        }
        
        return indexPath
    }
    
}


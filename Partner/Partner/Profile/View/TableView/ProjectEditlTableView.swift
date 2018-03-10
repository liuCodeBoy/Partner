//
//  ProjectDetialTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/10.
//

import UIKit

class ProjectEditlTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
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
    
}



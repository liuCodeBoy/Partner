//
//  CircleWatingJoinInListTableView.swift
//  Partner
//
//  Created by LiuXinQiang on 2018/2/26.
//

import UIKit

class CircleWatingJoinInListTableView: UITableView ,UITableViewDelegate,UITableViewDataSource{
    var  userModelArr = [UserModel]() {
        didSet {
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userModelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "WatingJionInCellID", for: indexPath) as! WatingJionInCell
        if  userModelArr.count > 0 {
            cell.viewModel = userModelArr[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取出模型
        let  model = userModelArr[indexPath.row]
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate   = self
        self.dataSource = self
    }
}

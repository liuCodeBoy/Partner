//
//  ProjectCollectionTableView.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit
import SCLAlertView

class ProjectCollectionTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var pushProjReviewClosure: ((_ id: Int) -> Void)?
    
    var modelArray: [ProjectListModel] = [ProjectListModel]() {
        didSet {
            reloadData()
            if modelArray.count == 0 {
                self.addPlaceholder()
            } else {
                self.removePlaceholder()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCollectionSingleTableViewCell") as! ProjectCollectionSingleTableViewCell
        cell.viewModel = modelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = modelArray[indexPath.row].projectId as? Int, pushProjReviewClosure != nil {
            pushProjReviewClosure!(id)
        }
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
            
            guard let id = modelArray[indexPath.row].projectId else { return }
            NetWorkTool.shareInstance.updateFocusProject(token: access_token!, id: id as! Int, type: 2) { (result, error) in
                
                if error != nil {
                    SCLAlertView().showError("request error", subTitle: "\(error as AnyObject)")
                    return
                }
                if result!["code"] as! Int == 200 {
                    // TODO:- delete succeeded
                    SCLAlertView().showSuccess("删除成功", subTitle: "")
                    
                } else {
                    SCLAlertView().showError("post request failed, code: \(String(describing: result!["code"]!))", subTitle: "reason: \(String(describing: result!["msg"]!))")
                }
            }
            
            modelArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }

}

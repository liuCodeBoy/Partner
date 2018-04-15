//
//  MyProjectRejectedIssueViewController.swift
//  Partner
//
//  Created by Weslie on 2018/4/15.
//

import UIKit

class MyProjectRejectedIssueViewController: UIViewController {
    
    var projId: Int?
    @IBOutlet weak var reasonTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let id = self.projId else { return }
        NetWorkTool.shareInstance.getApproveList(token: access_token!, type: 4, id: id) { (result, error) in
            weak var weakSelf = self
            if error != nil {
                weakSelf?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
                return
            }
            if result!["code"] as! Int == 200 {
                
                if let resultDict = result!["result"] as? [[String : AnyObject]], let dict = resultDict.first {
                    let reason = dict["apprContent"] as! String
                    self.reasonTV.text = reason
                }
                
            } else {
                weakSelf?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"]!)), reason: \(String(describing: result!["msg"]!))", completion: nil)
            }
        }
    }
    
    
}

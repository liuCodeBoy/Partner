//
//  MyProjectEditViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class MyProjectEditViewController: UIViewController {
    
    var isEdited = true
    
    var projID: Int? 
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableView: ProjectEditlTableView!
    
    @IBAction func backToEditWithoutSave(_ segue: UIStoryboardSegue) { }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.projID = projID
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushEditProjVC(_:)), name: NSNotification.Name.init(pushEditProjBasicInfoNotification), object: nil)
        
    }
    
    @objc func pushEditProjVC(_ notification: Notification) {
        let model = notification.object as! ProjectBasicInfoModel
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "CreateProject") as! MyProjectEditAndCreateViewController
        vc.editViewModel = model
        vc.isEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destnation = segue.destination
        if segue.identifier == "MPEPushTMSegue" {
            let dest = destnation as! MyProjectEditTeamMembersViewController
            // TODO:- pass id to dest controller
            dest.projID = projID
        }
    }
    
}


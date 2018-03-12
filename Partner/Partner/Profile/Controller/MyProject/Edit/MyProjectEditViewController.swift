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
        
    }
   
    
}


//
//  MyProjectEditTeamMembersViewController.swift
//  Partner
//
//  Created by Weslie on 29/01/2018.
//

import UIKit

class MyProjectEditTeamMembersViewController: UIViewController {
    
    var projID: Int?

    @IBOutlet weak var tableView: ProjectEditTeamMemberTableView!
    
    @IBAction func addMemberClicked(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO:- pass proj id to tableview
        tableView.projID = projID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! MyProjectEditAddTeamMembersViewController
        if segue.identifier == "MPETMPushDetialInfoSegue" {
            dest.isEditMember = true
        } else if segue.identifier == "MPETMPushAddMemberSegue" {
            dest.isEditMember = false
        }
    }

}

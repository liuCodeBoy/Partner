//
//  MyHomePageAddEducationExperienceViewController.swift
//  Partner
//
//  Created by Weslie on 13/02/2018.
//

import UIKit

class MyHomePageAddEducationExperienceViewController: UIViewController {
    
    @IBOutlet weak var schoolLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var majorLbl: UILabel!
    
    @IBOutlet weak var deleteOrSaveView: UIView!
    @IBOutlet weak var saveView: UIView!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! InputDetialViewController
        switch segue.identifier! {
        case "MHPEduEMajorSegue":
            dest.navTitle           = "学位"
            dest.inputPlaceholder   = "请输入您的学位"
        case "MHPEduESchoolSegue":
            dest.navTitle           = "学校"
            dest.inputPlaceholder   = "请输入您的学校"
        default: break
        }
        dest.sourceSegue = segue
    }

}

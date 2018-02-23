//
//  MyHomePageAddWorkExperienceViewController.swift
//  Partner
//
//  Created by Weslie on 13/02/2018.
//

import UIKit

class MyHomePageAddWorkExperienceViewController: UIViewController {

    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var positionLbl: UILabel!
    @IBOutlet weak var inServiceTimeLbl: UILabel!
    
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
        if segue.identifier == "MHPWEComNameSegue" {
            dest.navTitle = "公司名称"
            dest.inputPlaceholder = "请输入公司名称"
        }
        dest.sourceSegue = segue
    }

}

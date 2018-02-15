//
//  MyHomePageAddEntrepreneurshipExperienceViewController.swift
//  Partner
//
//  Created by Weslie on 13/02/2018.
//

import UIKit

class MyHomePageAddEntrepreneurshipExperienceViewController: UIViewController {
    
    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var entreRoleLbl: UILabel!
    @IBOutlet weak var belongedLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var partnerCountLbl: UILabel!
    @IBOutlet weak var teamMenberCountLbl: UILabel!
    @IBOutlet weak var fundingScaleLbl: UILabel!
    @IBOutlet weak var isFullTimeBtn: UIButton!
    
    @IBOutlet weak var deleteOrSaveView: UIView!
    @IBOutlet weak var saveView: UIView!
    
    @IBAction func ifFullTimeBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
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
        case "MHPEEProjNameSegue":
            dest.navTitle           = "项目名称"
            dest.inputPlaceholder   = "请输入您的项目名称"
        case "MHPEELocationSegue":
            dest.navTitle           = "所在地"
            dest.inputPlaceholder   = "请输入您的创业所在地"
        case "MHPEEBelongedSegue":
            dest.navTitle           = "所在兴业"
            dest.inputPlaceholder   = "请输入所在兴业"
        default: break
        }
        dest.sourceSegue = segue
    }


}

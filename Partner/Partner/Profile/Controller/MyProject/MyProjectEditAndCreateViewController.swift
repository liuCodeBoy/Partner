//
//  MyProjectEditAndCreateViewController.swift
//  Partner
//
//  Created by Weslie on 25/01/2018.
//

import UIKit

class MyProjectEditAndCreateViewController: UIViewController {
    
    @IBOutlet weak var projectLogoImg   : UIImageView!
    @IBOutlet weak var projNameLbl      : UILabel!
    @IBOutlet weak var comFullNameLbl   : UILabel!
    @IBOutlet weak var contactNameLbl   : UILabel!
    @IBOutlet weak var contactPhoneLbl  : UILabel!
    @IBOutlet weak var emailLbl         : UILabel!
    @IBOutlet weak var identityLbl      : UILabel!
    @IBOutlet weak var locationLbl      : UILabel!
    @IBOutlet weak var industryLbl      : UILabel!
    @IBOutlet weak var financingLbl     : UILabel!
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadAvatarClicked(_ sender: UIButton) {
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func createProjBtnClicked(_ sender: ShadowButton) {
        // check wheather the infomation is completed
        if  projNameLbl.text        != "请输入"  &&
            comFullNameLbl.text     != "请输入"  &&
            contactNameLbl.text     != "请输入"  &&
            contactPhoneLbl.text    != "请输入"  &&
            emailLbl.text           != "请输入"  &&
            identityLbl.text        != "请选择"  &&
            locationLbl.text        != "请选择"  &&
            industryLbl.text        != "请选择"  &&
            financingLbl.text       != "请选择"
        {
            // TODO:- the infomation has completed, post request to upload
            
            presentHintMessage(hintMessgae: "创建成功", completion: { [weak self](_) in
                self?.navigationController?.popViewController(animated: true)
            })
        } else {
            presentHintMessage(hintMessgae: "请完善您的项目信息", completion: nil)
        }
        
        presentConfirmationAlert(hint: "确认要创建项目吗") { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! InputDetialViewController
        switch segue.identifier! {
        case "projNameSegue":
            dest.navTitle           = "项目名称"
            dest.inputPlaceholder   = "请输入您的项目名称"
        case "comFullNameSegue":
            dest.navTitle           = "公司全称"
            dest.inputPlaceholder   = "请输入您的公司全称"
        case "contactNameSegue":
            dest.navTitle           = "联系人姓名"
            dest.inputPlaceholder   = "请输入联系人姓名"
        case "contactPhoneSegue":
            dest.navTitle           = "联系电话"
            dest.inputPlaceholder   = "请输入联系电话"
        case "emailSegue":
            dest.navTitle           = "邮箱"
            dest.inputPlaceholder   = "请输入邮箱"
        default: break
        }
        dest.sourceSegue = segue
    }

}

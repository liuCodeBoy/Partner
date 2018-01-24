//
//  ProfileEditInfomationViewController.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class ProfileEditInfomationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveEditClicked(_ sender: UIButton) {
        presentConfirmationAlert(hint: "确认保存修改？") { [weak self](_) in
            // TODO:- save data
            
        self?.navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var profileInfoTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileInfoTableView.delegate = self
        profileInfoTableView.dataSource = self
        
        profileInfoTableView.registerNibs(nibName: ["ProfileTableViewHeaderCell",
                                                    "ProfileHobbiesSelectorTableViewBodyCell",
                                                    "ProfileSkillsSelectorTableViewBodyCell",
                                                    "ProfileTextInputTableViewBodyCell"])
        
        
        notificationAddKeyboardObserver()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewHeaderCell") as! ProfileTableViewHeaderCell
        switch section {
        case 0: headerView.headerTitleLbl.text = "个人信息"
        case 1: headerView.headerTitleLbl.text = "兴趣"
        case 2: headerView.headerTitleLbl.text = "技能标签"
        case 3: headerView.headerTitleLbl.text = "合伙需求"
        case 4: headerView.headerTitleLbl.text = "个人介绍"
        default: break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditSelfInfomationCell")!
            switch indexPath.row {
            case 0: cell.textLabel?.text       = "姓名"
                    cell.detailTextLabel?.text = "请输入"
            case 1: cell.textLabel?.text       = "性别"
                    cell.detailTextLabel?.text = "请选择"
            case 2: cell.textLabel?.text       = "联系电话"
                    cell.detailTextLabel?.text = "请输入"
            case 3: cell.textLabel?.text       = "邮箱"
                    cell.detailTextLabel?.text = "请输入"
            case 4: cell.textLabel?.text       = "公司"
                    cell.detailTextLabel?.text = "请输入"
            case 5: cell.textLabel?.text       = "职位"
                    cell.detailTextLabel?.text = "请选择"
            case 6: cell.textLabel?.text       = "社区"
                    cell.detailTextLabel?.text = "请选择"
            case 7: cell.textLabel?.text       = "切换身份  审核中、游客无法编辑"
                    cell.detailTextLabel?.text = "请选择"
            default: break
            }
        case 1: cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHobbiesSelectorTableViewBodyCell")!
        case 2: cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSkillsSelectorTableViewBodyCell")!
        case 3: let tagCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextInputTableViewBodyCell") as! ProfileTextInputTableViewBodyCell
            tagCell.placeholderLbl.text = "简要介绍你的合伙需求（必填）"
        tagCell.presentAlert = { [weak self]() in
            self?.presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
        }
            cell = tagCell
        case 4: let tagCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextInputTableViewBodyCell") as! ProfileTextInputTableViewBodyCell
            tagCell.placeholderLbl.text = "可简单的介绍下自己（选填）"
            cell = tagCell

        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:     return 52
        case 1, 2:  return 190
        case 3, 4:  return 160
        default:    return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // MARK:- end deiting to force the object resign first responder
        self.profileInfoTableView.endEditing(true)
        keyboardWillHide(from: profileInfoTableView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.profileInfoTableView.endEditing(true)
    }

}

extension UITableView {
    func registerNibs(nibName: [String]) {
        for name in nibName {
            let nib = UINib(nibName: name, bundle: nil)
            register(nib, forCellReuseIdentifier: name)
        }
    }
}

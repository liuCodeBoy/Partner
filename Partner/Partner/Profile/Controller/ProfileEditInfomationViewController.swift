//
//  ProfileEditInfomationViewController.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class ProfileEditInfomationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isExpandedArray = [true, true, false, false, false, false]
    
    var rows = [1, 8, 1, 1, 1, 1]
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveEditClicked(_ sender: UIButton) {
        presentConfirmationAlert(hint: "确认保存修改？") { [weak self](_) in
            // TODO:- save data
            
        self?.navigationController?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func foldExpandHeader(_ tap : UITapGestureRecognizer) {
        let tag = tap.view!.foldTag
        if isExpandedArray[tag] == false {
            // expand section
            isExpandedArray.remove(at: tag)
            isExpandedArray.insert(true, at: tag)
        } else {
            // fold section
            isExpandedArray.remove(at: tag)
            isExpandedArray.insert(false, at: tag)
        }
        let index = IndexPath(item: 0, section: tag)
        let range = Range.init(NSRange.init(location: index.section, length: 1))
        guard range != nil else { return }
        let set = IndexSet.init(integersIn: range!)
        profileInfoTableView.reloadSections(set, with: .automatic)
    }
    
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var profileInfoTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileInfoTableView.delegate = self
        profileInfoTableView.dataSource = self
        
        notificationAddKeyboardObserver()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpandedArray[section] == true {
            return rows[section]
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("ProfileEditTableViewHeader", owner: self, options: nil)?.first as! ProfileEditTableViewHeader
 
        switch section {
        case 0 : return nil
        case 1: headerView.headerTitleLbl.text = "个人信息"
        case 2: headerView.headerTitleLbl.text = "兴趣"
        case 3: headerView.headerTitleLbl.text = "技能标签"
        case 4: headerView.headerTitleLbl.text = "合伙需求"
        case 5: headerView.headerTitleLbl.text = "个人介绍"
        default: break
        }
        
        if isExpandedArray[section] == true {
            headerView.arrowImg.image = #imageLiteral(resourceName: "down_arrow")
        } else {
            headerView.arrowImg.image = #imageLiteral(resourceName: "up_arrow")
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(foldExpandHeader(_:)))
        headerView.addGestureRecognizer(tap)
        headerView.foldTag = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00001
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0: let avatarCell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditChooseAvatarTableViewCell") as! ProfileEditChooseAvatarTableViewCell
            cell = avatarCell
        case 1:
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
        case 2: cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHobbiesSelectorTableViewBodyCell")!
        case 3: cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSkillsSelectorTableViewBodyCell")!
        case 4: let tagCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextInputTableViewBodyCell") as! ProfileTextInputTableViewBodyCell
            tagCell.placeholderLbl.text = "简要介绍你的合伙需求（必填）"
        tagCell.presentAlert = { [weak self]() in
            self?.presentHintMessage(hintMessgae: "字符不能超过300字", completion: nil)
        }
            cell = tagCell
        case 5: let tagCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextInputTableViewBodyCell") as! ProfileTextInputTableViewBodyCell
            tagCell.placeholderLbl.text = "可简单的介绍下自己（选填）"
            cell = tagCell

        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:     return 150
        case 1:     return 52
        case 2, 3:  return 190
        case 4, 5:  return 160
        default:    return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // MARK:- end deiting to force the object resign first responder
        self.profileInfoTableView.endEditing(true)
        keyboardWillHide(withTransforming: profileInfoTableView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.profileInfoTableView.endEditing(true)
    }

}

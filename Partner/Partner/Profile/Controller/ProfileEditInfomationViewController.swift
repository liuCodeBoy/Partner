//
//  ProfileEditInfomationViewController.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit
import ImagePicker
import Lightbox

class ProfileEditInfomationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImagePickerDelegate {
    
    var viewModel: ProfileInfoModel? {
        didSet {
            if let avatar = viewModel?.userImgUrl {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 0))
                // MARK:- judge the cell, in case it is invisible and be reused
                if cell is ProfileEditChooseAvatarTableViewCell {
                    let avatarCell = cell as! ProfileEditChooseAvatarTableViewCell
                    avatarCell.avatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: nil, options: .continueInBackground, completed: nil)
                }
            }
            if let name = viewModel?.userName {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.detailTextLabel?.text = name
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.detailTextLabel?.text = "请输入"
            }
            if let gender = viewModel?.gender {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 1, section: 1))
                switch gender {
                case 0: cell?.detailTextLabel?.text = "保密"
                case 1: cell?.detailTextLabel?.text = "男"
                case 2: cell?.detailTextLabel?.text = "女"
                default: break
                }
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.detailTextLabel?.text = "请选择"
            }
            if let phone = viewModel?.phone {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 2, section: 1))
                cell?.detailTextLabel?.text = phone
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 2, section: 1))?.detailTextLabel?.text = "请绑定"
            }
            if let mail = viewModel?.mail {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 3, section: 1))
                cell?.detailTextLabel?.text = mail
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 3, section: 1))?.detailTextLabel?.text = "请输入"
            }
            if let company = viewModel?.compName {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 4, section: 1))
                cell?.detailTextLabel?.text = company
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 4, section: 1))?.detailTextLabel?.text = "请输入"
            }
            if let job = viewModel?.jobName {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 5, section: 1))
                cell?.detailTextLabel?.text = job
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 5, section: 1))?.detailTextLabel?.text = "请输入"
            }
            // TODO:- post request to get community name
            if let community = viewModel?.communityId {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 6, section: 1))
                cell?.detailTextLabel?.text = "\(community)"
            } else {
                profileInfoTableView.cellForRow(at: IndexPath.init(row: 6, section: 1))?.detailTextLabel?.text = "请选择"
            }
            if let id = viewModel?.idenId {
                let cell = profileInfoTableView.cellForRow(at: IndexPath.init(row: 7, section: 1))
                switch id {
                case 1: cell?.detailTextLabel?.text = "投资商"
                case 2: cell?.detailTextLabel?.text = "创业者"
                case 3: cell?.detailTextLabel?.text = "普通用户"
                default: break
                }
            }
            viewModel?.hobby = "asd, 124, 2345"

        }
    }
    
//    class viewModel {
//        static var image: UIImage?
//        static var name: String?
//        static var gender: NSNumber?
//        static var mail: String?
//        static var companyName: String?
//        static var communityId: NSNumber? = 1
//        static var identityId: NSNumber?
//        static var job: String?
//        static var hobby: String?
//        static var skill: String?
//        static var require: String?
//        static var desc: String?
//    }

    
    func checkEditInfoCompleted() -> Bool {
        if viewModel?.userName != nil && viewModel?.gender != nil && viewModel?.mail != nil && viewModel?.compName != nil && viewModel?.communityId != nil && viewModel?.idenId != nil && viewModel?.jobName != nil && viewModel?.hobby != nil && viewModel?.skill != nil && viewModel?.require != nil {
            return true
        } else {
            return false
        }
    }
    
    var isExpandedArray = [true, true, false, false, false, false]
    
    var destnationVC: ProfileEditInfomationInputDetialViewController?
    
    var rows = [1, 8, 1, 1, 1, 1]
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveEditClicked(_ sender: UIButton) {
        presentConfirmationAlert(hint: "确认保存修改？") { [weak self](_) in
            // TODO:- save data
            self?.checkLoginStatus()
            
            if self?.checkEditInfoCompleted() == false {
                self?.presentHintMessage(hintMessgae: "请完善信息后再提交", completion: { (_) in
                    return
                })
                return
            }
            
            // save hobby and skil
            let hobbyCell = self?.profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 2)) as! ProfileHobbiesSelectorTableViewBodyCell
            let hobbies = hobbyCell.hobbyString
            let skillCell = self?.profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 3)) as! ProfileSkillsSelectorTableViewBodyCell
            let skills = skillCell.skillString
            if hobbies == "" || skills == "" {
                self?.presentHintMessage(hintMessgae: "请完善信息后再提交", completion: { (_) in
                    return
                })
                return
            } else {
                self?.viewModel?.skill = skills
                self?.viewModel?.hobby = hobbies
            }
            
            // save require and desc
            let requireCell = self?.profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 4)) as! ProfileTextInputTableViewBodyCell
            if let require = requireCell.inputTextView.text, require != "" && require.replacingOccurrences(of: " ", with: "") != "" {
                self?.viewModel?.require = require
            } else {
                self?.presentHintMessage(hintMessgae: "请完善信息后再提交", completion: { (_) in
                    return
                })
                return
            }
            let descCell = self?.profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 5)) as! ProfileTextInputTableViewBodyCell
            if let desc = descCell.inputTextView.text, desc != "" && desc.replacingOccurrences(of: " ", with: "") != "" {
                self?.viewModel?.desc = desc
            } else {
                self?.presentHintMessage(hintMessgae: "请完善信息后再提交", completion: { (_) in
                    return
                })
                return
            }
            
//            NetWorkTool.shareInstance.editUser(token: access_token!,
//                                               image: editUserInfo.image!,
//                                               userName: editUserInfo.name!,
//                                               userGender: editUserInfo.gender as! Int,
//                                               userMail: editUserInfo.mail!,
//                                               userCompanyName: editUserInfo.name!,
//                                               userJob: editUserInfo.job!,
//                                               communityId: editUserInfo.communityId as! Int,
//                                               identityId: editUserInfo.identityId as! Int,
//                                               userHobby: editUserInfo.hobby!,
//                                               userSkill: editUserInfo.skill!,
//                                               userRequire: editUserInfo.require!,
//                                               userDesc: editUserInfo.desc!,
//                                               finished: { (result, error) in
//            // finish result callback
//
//
//
//            })
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
    
    override func viewDidAppear(_ animated: Bool) {

        // save section 1 infomation
        viewModel?.userName = (profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 1)))?.detailTextLabel?.text
        viewModel?.mail = (profileInfoTableView.cellForRow(at: IndexPath.init(row: 3, section: 1)))?.detailTextLabel?.text
        viewModel?.compName = (profileInfoTableView.cellForRow(at: IndexPath.init(row: 4, section: 1)))?.detailTextLabel?.text
        viewModel?.jobName = (profileInfoTableView.cellForRow(at: IndexPath.init(row: 5, section: 1)))?.detailTextLabel?.text
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileInfoTableView.delegate = self
        profileInfoTableView.dataSource = self
        
        notificationAddKeyboardObserver()
        
        // load data
        checkLoginStatus()
        NetWorkTool.shareInstance.getMyInfo(token: access_token!) { [weak self](result, error) in
            if error != nil {
                self?.presentConfirmationAlert(hint: "\(error as AnyObject)", completion: nil)
                print(error as AnyObject)
            }
            if result!["code"] as! Int == 200 {
                let model = ProfileInfoModel.mj_object(withKeyValues: result!["result"])
                self?.viewModel = model
            } else {
                self?.presentConfirmationAlert(hint: "post request failed with exit code: \(String(describing: result!["code"])), reason: \(String(describing: result!["msg"])))", completion: nil)
            }
        }
        
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
        case 0:
            let avatarCell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditChooseAvatarTableViewCell") as! ProfileEditChooseAvatarTableViewCell
        // tap to pick image
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseAvatar))
        avatarCell.avatar.addGestureRecognizer(tap)
            cell = avatarCell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditSelfInfomationCell")!
            switch indexPath.row {
            case 0: cell.textLabel?.text       = "姓名"
            case 1: cell.textLabel?.text       = "性别"
            case 2: cell.textLabel?.text       = "联系电话"
            case 3: cell.textLabel?.text       = "邮箱"
            case 4: cell.textLabel?.text       = "公司"
            case 5: cell.textLabel?.text       = "职位"
            case 6: cell.textLabel?.text       = "社区"
                    cell.detailTextLabel?.text = "请选择"
            case 7: cell.textLabel?.text       = "切换身份  审核中、游客无法编辑"
                    cell.detailTextLabel?.text = "请选择"
            default: break
            }
        case 2:
            let hobbyCell = tableView.dequeueReusableCell(withIdentifier: "ProfileHobbiesSelectorTableViewBodyCell") as! ProfileHobbiesSelectorTableViewBodyCell
            if let hobbies = viewModel?.hobby {
                // get the single element of the string
                let hobbyArray = hobbies.components(separatedBy: ",")
                // remove the same element of an array
                var hobbyArr = Array(Set(hobbyArray))
                // traverse the whole array and set selected status
                for hobby in hobbyArr {
                    for btn in hobbyCell.contentView.subviews {
                        let button = btn as! ShadowButton
                        let btnTitle = button.titleLabel!.text!
                        if hobby == btnTitle {
                            button.isSelected = true
                            button.backgroundColor = #colorLiteral(red: 0.5529412031, green: 0.6274510026, blue: 0.6941176653, alpha: 1)
                            button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                            // remove the selected button in array
                            hobbyArr.remove(at: hobbyArr.index(of: btnTitle)!)
                        } else {
                            continue
                        }
                    }
                }
                switch hobbyArr.count {
                case 0: break
                case 1:
                    hobbyCell.customBtn1.setTitle(hobbyArr[0], for: .normal)
                    hobbyCell.customBtn1.isSelected = true
                    hobbyCell.customBtn2.isHidden = false
                case 2:
                    hobbyCell.customBtn1.setTitle(hobbyArr[0], for: .normal)
                    hobbyCell.customBtn2.setTitle(hobbyArr[1], for: .normal)
                    hobbyCell.customBtn1.isSelected = true
                    hobbyCell.customBtn2.isSelected = true
                    hobbyCell.customBtn2.isHidden = false
                    hobbyCell.customBtn3.isHidden = false
                case 3:
                    hobbyCell.customBtn1.setTitle(hobbyArr[0], for: .normal)
                    hobbyCell.customBtn2.setTitle(hobbyArr[1], for: .normal)
                    hobbyCell.customBtn3.setTitle(hobbyArr[2], for: .normal)
                    hobbyCell.customBtn1.isSelected = true
                    hobbyCell.customBtn2.isSelected = true
                    hobbyCell.customBtn3.isSelected = true
                    hobbyCell.customBtn2.isHidden = false
                    hobbyCell.customBtn3.isHidden = false
                    hobbyCell.customBtn4.isHidden = false
                case 4:
                    hobbyCell.customBtn1.setTitle(hobbyArr[0], for: .normal)
                    hobbyCell.customBtn2.setTitle(hobbyArr[1], for: .normal)
                    hobbyCell.customBtn3.setTitle(hobbyArr[2], for: .normal)
                    hobbyCell.customBtn4.setTitle(hobbyArr[3], for: .normal)
                    hobbyCell.customBtn1.isSelected = true
                    hobbyCell.customBtn2.isSelected = true
                    hobbyCell.customBtn3.isSelected = true
                    hobbyCell.customBtn4.isSelected = true
                    hobbyCell.customBtn2.isHidden = false
                    hobbyCell.customBtn3.isHidden = false
                    hobbyCell.customBtn4.isHidden = false
                    
                default: break
                    
                    
                }
//                if hobbyArr.count > 0 {
//                    if hobbyCell.customBtn1.isSelected == false {
//                        hobbyCell.customBtn1.setTitle(hobby, for: .normal)
//                        hobbyCell.customBtn1.isSelected = true
//                        hobbyCell.customBtn2.isHidden = false
//                    } else if hobbyCell.customBtn2.isSelected == false {
//                        hobbyCell.customBtn2.setTitle(hobby, for: .normal)
//                        hobbyCell.customBtn2.isSelected = true
//                        hobbyCell.customBtn3.isHidden = false
//                    } else if hobbyCell.customBtn3.isSelected == false {
//                        hobbyCell.customBtn3.setTitle(hobby, for: .normal)
//                        hobbyCell.customBtn3.isSelected = true
//                        hobbyCell.customBtn4.isHidden = false
//                    } else {
//                        hobbyCell.customBtn4.setTitle(hobby, for: .normal)
//                        hobbyCell.customBtn4.isSelected = true
//                    }
//                }
                

                
            }
            
            cell = hobbyCell
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
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0, 3, 4, 5: return indexPath
            case 1:
                let sheet = UIAlertController(title: "请选择性别", message: nil, preferredStyle: .actionSheet)
                let secret = UIAlertAction(title: "保密", style: .default, handler: { (_) in
                    tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "保密"
                    self.viewModel?.gender = 0
                })
                let female = UIAlertAction(title: "女", style: .default, handler: { (_) in
                    self.viewModel?.gender = 2
                    tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "女"
                })
                let male = UIAlertAction(title: "男", style: .default, handler: { (_) in
                    self.viewModel?.gender = 1
                    tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "男"
                })
                sheet.addAction(male)
                sheet.addAction(female)
                sheet.addAction(secret)
                present(sheet, animated: true, completion: {
                    return
                })
            case 6: print("6")
            case 7: print("7")
            default: break
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let selectedCell = tableView.cellForRow(at: indexPath)
            let detialText = selectedCell?.textLabel?.text!
            destnationVC?.navTitle = detialText
            destnationVC?.previousIndexPath = indexPath
            destnationVC?.inputPlaceholder = "请输入你的\(String(describing: detialText!))"
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // MARK:- end deiting to force the object resign first responder
        self.profileInfoTableView.endEditing(true)
        keyboardWillHide(withTransforming: profileInfoTableView)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ProfileEditInfomationInputDetialViewController
        destnationVC = dest
        destnationVC?.segue = segue
        if segue.identifier != "PEIInputDetialSegue" {
            destnationVC?.navTitle = "自定义标签"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.profileInfoTableView.endEditing(true)
    }
    
    @objc func chooseAvatar() {
        let picker = ImagePickerController()
        picker.delegate = self
        picker.imageLimit = 1
        present(picker, animated: true, completion: nil)
    }
    
    // MARK:- image picker protocol functions

    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        imagePicker.dismiss(animated: true) {
            weak var weakSelf = self
            for img in images {
                let avatarCell = weakSelf?.profileInfoTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! ProfileEditChooseAvatarTableViewCell
                avatarCell.avatar.image = img
            }
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
